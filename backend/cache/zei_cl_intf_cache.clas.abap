CLASS zei_cl_intf_cache DEFINITION PUBLIC FINAL INHERITING FROM zei_cl_cacheobject CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      cache REDEFINITION.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA:
        interface TYPE REF TO if_xco_ao_interface.

    METHODS:
      _handle_interfaces,
      _handle_data,
      _handle_methods.

ENDCLASS.



CLASS zei_cl_intf_cache IMPLEMENTATION.

  METHOD cache.
    interface = xco_abap=>interface( CONV #( object_name ) ).

    IF interface->exists( ) = abap_false.
      RETURN.
    ENDIF.

    _handle_interfaces( ).
    _handle_data( ).
    _handle_methods( ).

  ENDMETHOD.

  METHOD _handle_data.
    DATA(interface_data) = interface->components->data->all->get( ).
    DATA(interface_types) = interface->components->type->all->get( ).

    LOOP AT interface_data ASSIGNING FIELD-SYMBOL(<data>).
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
                  i_access_modifier = '+'
                  i_def_name = CONV #( data_name )
                  i_ref_var1 = CONV #( data_type ) ).
    ENDLOOP.
  ENDMETHOD.

  METHOD _handle_interfaces.
    DATA(interfaces) = interface->content( )->get_interfaces( ).
    LOOP AT interfaces ASSIGNING FIELD-SYMBOL(<interface>).
      me->add_to_rel( i_tgt_type = 'INTF'
                    i_tgt_name = CONV #( <interface>->name )
                    i_relation = 'INHER' ).
    ENDLOOP.
  ENDMETHOD.

  METHOD _handle_methods.
    DATA(interface_methods) = interface->components->method->all->get( ).

    LOOP AT interface_methods ASSIGNING FIELD-SYMBOL(<method>).
      DATA(method_name) = <method>->name.
      DATA(changing_params) = <method>->changing_parameters->all->get( ).
      DATA(importing_params) = <method>->importing_parameters->all->get( ).
      DATA(exporting_params) = <method>->exporting_parameters->all->get( ).

      DATA(returning_params) = <method>->returning_parameters->all->get( ).
      DATA(returning_param_name) = VALUE #( returning_params[ 1 ]->name OPTIONAL ).

      add_to_def( i_def_type = 'METHOD'
                  i_access_modifier = '+'
                  i_def_name = CONV #( method_name )
                  i_ref_var1 = REDUCE #( INIT s = ||
                                         FOR <importing_param> IN importing_params
                                         NEXT s = COND #( WHEN s IS INITIAL
                                                          THEN |{ <importing_param>->name }|
                                                          ELSE |{ s }, { <importing_param>->name }| ) )
                  i_ref_var2 = CONV #( returning_param_name ) ).
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
