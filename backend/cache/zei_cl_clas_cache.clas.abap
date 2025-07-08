CLASS zei_cl_clas_cache DEFINITION PUBLIC FINAL INHERITING FROM zei_cl_cacheobject CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      cache REDEFINITION.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA:
        class TYPE REF TO if_xco_ao_class.

    METHODS:
      _handle_header,
      _handle_sections,
      _handle_section
        IMPORTING
          i_section         TYPE REF TO if_xco_clas_definition_section
          i_access_modifier TYPE zei_accessmodifier,
      _handle_section_data
        IMPORTING
          i_section         TYPE REF TO if_xco_clas_definition_section
          i_access_modifier TYPE zei_accessmodifier,
      _handle_section_methods
        IMPORTING
          i_section         TYPE REF TO if_xco_clas_definition_section
          i_access_modifier TYPE zei_accessmodifier,
      _handle_acccesses.

ENDCLASS.



CLASS zei_cl_clas_cache IMPLEMENTATION.

  METHOD cache.
    class = xco_abap=>class( CONV #( object_name ) ).

    IF class->exists( ) = abap_false.
      RETURN.
    ENDIF.

    _handle_header( ).
    _handle_sections( ).
    _handle_acccesses( ).
  ENDMETHOD.

  METHOD _handle_header.
    DATA(definition_content) = class->definition->content( )->get( ).

    IF definition_content-superclass IS NOT INITIAL.
      me->add_to_rel( i_tgt_type = 'CLAS'
                      i_tgt_name = CONV #( definition_content-superclass->name )
                      i_relation = 'INHER' ).
    ENDIF.

    LOOP AT definition_content-interfaces ASSIGNING FIELD-SYMBOL(<interface>).
      me->add_to_rel( i_tgt_type = 'INTF'
                      i_tgt_name = CONV #( <interface>->name )
                      i_relation = 'RLZTN' ).
    ENDLOOP.

    IF definition_content-for_behavior_of IS NOT INITIAL.
      me->add_to_rel( i_tgt_type = 'BDEF'
                      i_tgt_name = CONV #( definition_content-for_behavior_of->name )
                      i_relation = 'BDEF_IMPL' ).
    ENDIF.
  ENDMETHOD.

  METHOD _handle_sections.
    DATA(sections) = class->definition->section.

    me->_handle_section( i_access_modifier = '+' i_section = sections-public ).
    me->_handle_section( i_access_modifier = '-' i_section = sections-private ).
    me->_handle_section( i_access_modifier = '#' i_section = sections-protected ).
  ENDMETHOD.

  METHOD _handle_section.
    _handle_section_data( i_access_modifier = i_access_modifier i_section = i_section ).
    _handle_section_methods( i_access_modifier = i_access_modifier i_section = i_section ).
  ENDMETHOD.

  METHOD _handle_section_data.
    DATA(data) = i_section->components->data->all->get( ).
    LOOP AT data ASSIGNING FIELD-SYMBOL(<data>).
      DATA(content) = <data>->content( )->get( ).

      DATA(data_name) = <data>->name.
      DATA(data_type) = content-typing_definition->get_value( ).

      IF data_type IS INITIAL.
        DATA(source) = content-typing_definition->get_source( ).
        " typing_method will be "SEE_CODE", if so
        " source will contain something like this "variablename TYPE c LENGTH 10\r\n" or "testtab TYPE TABLE OF matnr\r\n"
        " the typing needs to be read out the type and length (if defined) needs to be extracted and added to the data type
      ENDIF.

      " create rel entries for associations if data entries referencing classes exist
      " HARDER (as this table reference is either a local class TYPE or a table type/structure) ...
      " ... or data tables referencing classes are being used

      add_to_def( i_def_type = 'DATA'
                  i_access_modifier = i_access_modifier
                  i_def_name = CONV #( data_name )
                  i_ref_var1 = CONV #( data_type ) ).
    ENDLOOP.
  ENDMETHOD.

  METHOD _handle_section_methods.
    DATA(methods) = i_section->components->method->all->get( ).
    DATA(types) = i_section->components->type->all->get( ).

    LOOP AT methods ASSIGNING FIELD-SYMBOL(<method>).
      DATA(method_name) = <method>->name.
      DATA(changing_params) = <method>->changing_parameters->all->get( ).
      DATA(importing_params) = <method>->importing_parameters->all->get( ).
      DATA(exporting_params) = <method>->exporting_parameters->all->get( ).

      DATA(returning_params) = <method>->returning_parameters->all->get( ).
      DATA(returning_param_name) = VALUE #( returning_params[ 1 ]->name OPTIONAL ).

      add_to_def( i_def_type = 'METHOD'
                  i_access_modifier = i_access_modifier
                  i_def_name = CONV #( method_name )
                  i_ref_var1 = REDUCE #( INIT s = ||
                                         FOR <importing_param> IN importing_params
                                         NEXT s = COND #( WHEN s IS INITIAL
                                                          THEN |{ <importing_param>->name }|
                                                          ELSE |{ s }, { <importing_param>->name }| ) )
                  i_ref_var2 = CONV #( returning_param_name ) ).
    ENDLOOP.
  ENDMETHOD.

  METHOD _handle_acccesses.
    DATA(object_type) = CONV seu_obj( 'CLAS' ).
    DATA(object_name) = CONV sobj_name( class->name ).

    DATA: environment_table TYPE TABLE OF senvi.
    CALL FUNCTION 'REPOSITORY_ENVIRONMENT_SET'
      EXPORTING
        obj_type    = object_type
        object_name = object_name
      TABLES
        environment = environment_table.

    LOOP AT environment_table ASSIGNING FIELD-SYMBOL(<enviroment>) WHERE type = 'CLAS' OR type = 'BDEF' OR type = 'INCL' OR type = 'FUNC'.
      me->add_to_rel( i_tgt_type = CONV #( <enviroment>-type )
                      i_tgt_name = CONV #( <enviroment>-object )
                      i_relation = 'ACCESSING' ).
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
