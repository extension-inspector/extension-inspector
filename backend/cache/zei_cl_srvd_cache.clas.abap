CLASS zei_cl_srvd_cache DEFINITION PUBLIC FINAL INHERITING FROM zei_cl_cacheobject CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      cache REDEFINITION.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA:
        service_definition TYPE REF TO  if_xco_service_definition.

ENDCLASS.



CLASS zei_cl_srvd_cache IMPLEMENTATION.

  METHOD cache.
    service_definition = xco_abap_repository=>object->srvd->for(  CONV #( object_name ) ).

    IF service_definition->exists( ) = abap_false.
      RETURN.
    ENDIF.

    DATA(exposures) = service_definition->exposures->all->get_cds_entities( ).

    LOOP AT exposures ASSIGNING FIELD-SYMBOL(<exposure>).
      me->add_to_rel( i_tgt_type = 'DDLS'
                      i_tgt_name = CONV #( <exposure> )
                      i_relation = 'DDLS_EXPO' ).
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
