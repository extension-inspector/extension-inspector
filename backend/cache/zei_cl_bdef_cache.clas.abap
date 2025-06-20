CLASS zei_cl_bdef_cache DEFINITION PUBLIC FINAL INHERITING FROM zei_cl_cacheobject CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      cache REDEFINITION.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA:
        behavior_definition TYPE REF TO if_xco_behavior_definition.

    METHODS:
      _handle_bdef_extension.
ENDCLASS.



CLASS zei_cl_bdef_cache IMPLEMENTATION.

  METHOD cache.
    behavior_definition = xco_cds=>behavior_definition( CONV #( object_name ) ).

    IF behavior_definition->exists( ) = abap_false.
      RETURN.
    ENDIF.

    _handle_bdef_extension( ).
  ENDMETHOD.

  METHOD _handle_bdef_extension.
    SELECT *
        FROM enhbdex
        WHERE extendname = @behavior_definition->name
        INTO TABLE @DATA(extensions).

    LOOP AT extensions ASSIGNING FIELD-SYMBOL(<extension>).
      me->add_to_rel( i_tgt_type = 'BDEF'
                      i_tgt_name = CONV #( to_upper( <extension>-parentname ) )
                      i_relation = 'BDEF_EXT' ).
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
