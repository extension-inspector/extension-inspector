CLASS zei_cl_wapa_cache DEFINITION PUBLIC FINAL INHERITING FROM zei_cl_cacheobject CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      cache REDEFINITION.

  PROTECTED SECTION.

  PRIVATE SECTION.
    METHODS:
      _handle_data_sources,
      _get_manifest_object
        RETURNING
          VALUE(r_manifest_object) TYPE REF TO data,
      _get_implementing_class
        IMPORTING
          i_service_name              TYPE /iwbep/med_grp_technical_name
        RETURNING
          VALUE(r_implementing_class) TYPE /iwbep/med_runtime_service,
      _get_segw_project_by_impl_clas
        IMPORTING
          i_implementing_class  TYPE /iwbep/med_runtime_service
        RETURNING
          VALUE(r_segw_project) TYPE /iwbep/sbdm_project.
    DATA:
        app_name TYPE sobj_name.
    CONSTANTS:
        c_manifest_string TYPE string VALUE 'MANIFEST.JSON                                                         '.

ENDCLASS.



CLASS zei_cl_wapa_cache IMPLEMENTATION.

  METHOD cache.
    app_name = object_name.

    _handle_data_sources( ).
  ENDMETHOD.

  METHOD _handle_data_sources.
    DATA(manifest_object) = _get_manifest_object( ).

    " navigate to sap.app -> dataSources
    ASSIGN manifest_object->* TO FIELD-SYMBOL(<manifest>).
    ASSIGN COMPONENT 'SAP_APP' OF STRUCTURE <manifest> TO FIELD-SYMBOL(<sap_app>).
    IF <sap_app> IS NOT ASSIGNED.
      RETURN.
    ENDIF.
    ASSIGN <sap_app>->* TO <sap_app>. " remove dereference

    ASSIGN COMPONENT 'DATASOURCES' OF STRUCTURE <sap_app> TO FIELD-SYMBOL(<datasources>).
    IF <datasources> IS NOT ASSIGNED.
      RETURN.
    ENDIF.
    ASSIGN <datasources>->* TO <datasources>. " remove dereference

    " get descriptor of all components (list of models)
    DATA(strucdescr) = CAST cl_abap_structdescr( cl_abap_typedescr=>describe_by_data( <datasources> ) ).
    DATA(entries) = strucdescr->get_components( ).

    " add service paths to list
    LOOP AT entries ASSIGNING FIELD-SYMBOL(<entry>).
      ASSIGN COMPONENT <entry>-name OF STRUCTURE <datasources> TO FIELD-SYMBOL(<service>).
      ASSIGN <service>->* TO <service>. " remove dereference

      ASSIGN COMPONENT 'URI' OF STRUCTURE <service> TO FIELD-SYMBOL(<uri_value>).
      ASSIGN <uri_value>->* TO <uri_value>. " remove dereference

      IF <uri_value> IS NOT ASSIGNED.
        RETURN.
      ENDIF.

      DATA(uri) = CONV string( <uri_value> ).
      DATA(service_info) = lcl_odata_parser=>analyze_path( uri ).
      CASE service_info-version.
        WHEN 'V4'.
          me->add_to_rel( i_tgt_type = 'SRVB'
                          i_tgt_name = CONV #( to_upper( service_info-binding_name ) )
                          i_relation = 'DDLS_DS' ).
        WHEN 'V2'.
          DATA(impl_class) = _get_implementing_class( CONV #( service_info-binding_name ) ).

          IF impl_class = 'CL_SADL_RAP_EXPOSURE_DPC'.
            " RAP based service
            me->add_to_rel( i_tgt_type = 'SRVB'
                          i_tgt_name = CONV #( to_upper( service_info-binding_name ) )
                          i_relation = 'DS' ).
          ELSE.
            DATA(segw_project) = _get_segw_project_by_impl_clas( impl_class ).
            me->add_to_rel( i_tgt_type = 'IWPR'
                          i_tgt_name = CONV #( to_upper( segw_project ) )
                          i_relation = 'DDLS_DS' ).
          ENDIF.
        WHEN OTHERS.
          CONTINUE.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.

  METHOD _get_manifest_object.
    cl_ci_provide_bsp=>get_handle( EXPORTING p_applname = to_upper( app_name ) IMPORTING p_handle = DATA(handle) ).

    DATA(page_key) = VALUE o2pagkey( applname = to_upper( app_name ) pagekey = c_manifest_string ).
    handle->get_pagecontent( EXPORTING p_pagkey = page_key IMPORTING p_pagcontent = DATA(page_content) ).
    DATA(lv_json_string) = REDUCE string( INIT result = `` FOR ls_line IN page_content NEXT result = result && ls_line-line ).

    IF lv_json_string IS INITIAL.
      RETURN.
    ENDIF.

    /ui2/cl_json=>deserialize( EXPORTING json = lv_json_string CHANGING data = r_manifest_object ).
  ENDMETHOD.

  METHOD _get_implementing_class.
    SELECT SINGLE FROM /iwbep/i_mgw_srh
        FIELDS class_name
        WHERE technical_name = @i_service_name
        INTO @r_implementing_class.
  ENDMETHOD.

  METHOD _get_segw_project_by_impl_clas.
    SELECT SINGLE FROM /iwbep/i_sbd_ga
        FIELDS project
        WHERE name = @i_implementing_class
        INTO @r_segw_project.
  ENDMETHOD.

ENDCLASS.
