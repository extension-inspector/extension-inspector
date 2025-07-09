CLASS zei_cl_dtel_cache DEFINITION PUBLIC FINAL INHERITING FROM zei_cl_cacheobject CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      cache REDEFINITION.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS zei_cl_dtel_cache IMPLEMENTATION.

  METHOD cache.

    DATA(data_element) = xco_abap_dictionary=>data_element( CONV #( object_name ) ).
    IF data_element->exists( ) = abap_False.
      RETURN.
    ENDIF.

    DATA(data_type) = data_element->content( )->get_data_type( ).

    IF data_type->is_domain( ) = abap_true.
      me->add_to_rel( i_tgt_type = 'DOMA'
                      i_tgt_name = CONV #( to_upper( data_type->get_domain( )->name ) )
                      i_relation = 'DTEL_TYPE' ).
    ENDIF.
    IF data_type->is_class( ) = abap_true.
      me->add_to_rel( i_tgt_type = 'CLAS'
                      i_tgt_name = CONV #( to_upper( data_type->get_class( )->name ) )
                      i_relation = 'DTEL_TYPE' ).
    ENDIF.
    IF data_type->is_interface( ) = abap_true.
      me->add_to_rel( i_tgt_type = 'INTF'
                      i_tgt_name = CONV #( to_upper( data_type->get_interface( )->name ) )
                      i_relation = 'DTEL_TYPE' ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
