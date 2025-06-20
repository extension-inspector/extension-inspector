CLASS zei_cl_calc_c_objects DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS:
      _getADTLink
        IMPORTING
          i_ObjectType  TYPE trobjtype
          i_ObjectName  TYPE sobj_name
        RETURNING
          VALUE(r_link) TYPE char256,
      _getWebLink
        IMPORTING
          i_ObjectType  TYPE trobjtype
          i_ObjectName  TYPE sobj_name
        RETURNING
          VALUE(r_link) TYPE char256.
ENDCLASS.



CLASS zei_cl_calc_c_objects IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.
    CHECK NOT it_original_data IS INITIAL.

    DATA calculated_data TYPE STANDARD TABLE OF zei_c_objects WITH DEFAULT KEY.
    MOVE-CORRESPONDING it_original_data TO calculated_data.

    DATA(scts_objects) = zei_cl_co_utils=>get_abap_object_types( ).

    SELECT *
        FROM ZEI_R_TransportEntries
        FOR ALL ENTRIES IN @calculated_data
        WHERE ProgramId = @calculated_data-ProgramId
          AND ABAPObjectType = @calculated_data-ABAPObjectType
          AND IsLocked = 'X'
        INTO TABLE @DATA(transport_entries).

    SELECT *
        FROM ZEI_I_ObjectRelations
        FOR ALL ENTRIES IN @calculated_data
        WHERE ( SourceObjectType = @calculated_data-ABAPObjectType
                AND SourceObjectName = @calculated_data-ABAPObject )
           OR ( TargetObjectType = @calculated_data-ABAPObjectType
                AND TargetObjectName = @calculated_data-ABAPObject )
        INTO TABLE @DATA(object_relations).

    DATA(object_desc_table) = VALUE zei_cl_co_utils=>object_desc_table( FOR data IN calculated_data ( objecttype = data-ABAPObjectType
                                                                                                      objectname = data-ABAPObject ) ).
    DATA(object_descriptions) = zei_cl_co_utils=>get_object_descriptions( object_desc_table ).

    LOOP AT calculated_data ASSIGNING FIELD-SYMBOL(<calculated_data>).
      <calculated_data>-ABAPObjectDescription = VALUE #( object_descriptions[ objecttype = <calculated_data>-ABAPObjectType
                                                                              objectname = <calculated_data>-ABAPObject ]-objectdescription OPTIONAL ).

      <calculated_data>-ABAPObjectTypeName = VALUE #( scts_objects[ objecttype = <calculated_data>-ABAPObjectType ]-objecttypetext OPTIONAL ).
      <calculated_data>-ADTLink = _getADTLink( i_objecttype = <calculated_data>-ABAPObjectType i_objectname = <calculated_data>-ABAPObject ).
      <calculated_data>-WebLink = _getWebLink( i_objecttype = <calculated_data>-ABAPObjectType i_objectname = <calculated_data>-ABAPObject ).
      <calculated_data>-LockedInTransport = VALUE #( transport_entries[ ProgramId = <calculated_data>-ProgramId
                                                                        ABAPObjectType = <calculated_data>-ABAPObjectType
                                                                        ABAPObject = <calculated_data>-ABAPObject ]-RequestTask OPTIONAL ).

      IF VALUE #( object_relations[ SourceObjectType = <calculated_data>-ABAPObjectType
                                    SourceObjectName = <calculated_data>-ABAPObject ] OPTIONAL ) IS NOT INITIAL
         OR VALUE #( object_relations[ TargetObjectType = <calculated_data>-ABAPObjectType
                                    TargetObjectName = <calculated_data>-ABAPObject ] OPTIONAL ) IS NOT INITIAL.
        <calculated_data>-HasRelations = abap_true.
      ENDIF.

    ENDLOOP.
    MOVE-CORRESPONDING calculated_data TO ct_calculated_data.
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
  ENDMETHOD.

  METHOD _getadtlink.
    DATA(path) = ||.
    CASE i_objecttype.
      WHEN 'CLAS'.
        path = |sap/bc/adt/oo/classes|.
      WHEN 'INTF'.
        path = |sap/bc/adt/oo/interfaces|.
      WHEN 'DDLS'.
        path = |sap/bc/adt/ddic/ddl/sources|.
      WHEN 'DEVC'.
        path = |sap/bc/adt/packages|.
      WHEN 'BDEF'.
        path = |sap/bc/adt/bo/behaviordefinitions|.
      WHEN 'DOMA'.
        path = |sap/bc/adt/ddic/domains|.
      WHEN 'DTEL'.
        path = |sap/bc/adt/ddic/dataelements|.
      WHEN 'SRVB'.
        path = |sap/bc/adt/businessservices/bindings|.
      WHEN 'SRVD'.
        path = |sap/bc/adt/ddic/srvd/sources|.
      WHEN 'TABL'.
        path = |sap/bc/adt/ddic/tables|.
      WHEN 'DCLS'.
        path = |sap/bc/adt/acm/dcl/sources|.
      WHEN 'DDLX'.
        path = |sap/bc/adt/ddic/ddlx/sources|.
    ENDCASE.

    r_link = |adt://{ sy-sysid }/{ path }/{ i_objectname }|.

    IF path IS INITIAL.
      r_link = ||.
    ENDIF.
  ENDMETHOD.

  METHOD _getweblink.
    DATA(path) = ||.
    CASE i_objecttype.
      WHEN 'CLAS'.
        path = |sap/bc/adt/oo/classes|.
      WHEN 'INTF'.
        path = |sap/bc/adt/oo/interfaces|.
      WHEN 'DDLS'.
        path = |sap/bc/adt/ddic/ddl/sources|.
      WHEN 'BDEF'.
        path = |sap/bc/adt/bo/behaviordefinitions|.
      WHEN 'SRVD'.
        path = |sap/bc/adt/ddic/srvd/sources|.
      WHEN 'TABL'.
        path = |sap/bc/adt/ddic/tables|.
      WHEN 'DCLS'.
        path = |sap/bc/adt/acm/dcl/sources|.
      WHEN 'DDLX'.
        path = |sap/bc/adt/ddic/ddlx/sources|.
    ENDCASE.

    IF path IS NOT INITIAL.
      DATA: serverlist TYPE STANDARD TABLE OF icm_sinfo2.
      CALL FUNCTION 'ICM_GET_INFO2'
        TABLES
          servlist = serverlist.

      DATA(host) = VALUE #( serverlist[ protocol = 2 ]-hostname OPTIONAL ).
      DATA(port) = VALUE #( serverlist[ protocol = 2 ]-service OPTIONAL ).
    ENDIF.

    r_link = |https://{ host }:{ port }/{ path }/{ i_objectname }/source/main?version=active&sap-client={ sy-mandt }|.

    IF path IS INITIAL.
      r_link = ||.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
