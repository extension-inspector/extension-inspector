CLASS zei_cl_ttyp_cache DEFINITION PUBLIC FINAL INHERITING FROM zei_cl_cacheobject CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      cache REDEFINITION.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS zei_cl_ttyp_cache IMPLEMENTATION.

  METHOD cache.

    DATA(table_type) = xco_abap_dictionary=>table_type( CONV #( object_name ) ).
    IF table_type->exists( ) = abap_False.
      RETURN.
    ENDIF.

    DATA(row_type) = table_type->content( )->get_row_type( ).

    IF row_type->is_data_element( ) = abap_true.
      me->add_to_rel( i_tgt_type = 'DTEL'
                      i_tgt_name = CONV #( to_upper( row_type->get_data_element( )->name ) )
                      i_relation = 'TTYP_TYPE' ).
    ENDIF.
    IF row_type->is_structure( ) = abap_true.
      me->add_to_rel( i_tgt_type = 'TABL'
                      i_tgt_name = CONV #( to_upper( row_type->get_structure( )->name ) )
                      i_relation = 'TTYP_TYPE' ).
    ENDIF.
    IF row_type->is_class( ) = abap_true.
      me->add_to_rel( i_tgt_type = 'CLAS'
                      i_tgt_name = CONV #( to_upper( row_type->get_class( )->name ) )
                      i_relation = 'TTYP_TYPE' ).
    ENDIF.
    IF row_type->is_interface( ) = abap_true.
      me->add_to_rel( i_tgt_type = 'INTF'
                      i_tgt_name = CONV #( to_upper( row_type->get_interface( )->name ) )
                      i_relation = 'TTYP_TYPE' ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
