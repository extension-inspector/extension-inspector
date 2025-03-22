CLASS zei_cl_srvb_cache DEFINITION PUBLIC FINAL INHERITING FROM zei_cl_cacheobject CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      cache REDEFINITION.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA:
        service_binding TYPE REF TO if_xco_service_binding.

ENDCLASS.



CLASS zei_cl_srvb_cache IMPLEMENTATION.

  METHOD cache.
    service_binding = xco_abap_repository=>object->srvb->for(  CONV #( object_name ) )..

    DATA(services) = service_binding->services->all->get( ).

    LOOP AT services ASSIGNING FIELD-SYMBOL(<service>).
      IF <service>->exists( ) = abap_false.
        CONTINUE.
      ENDIF.

      DATA(versions) = <service>->versions->all->get( ).
      LOOP AT versions ASSIGNING FIELD-SYMBOL(<version>).
        IF <version>->exists( ) = abap_false.
          CONTINUE.
        ENDIF.

        DATA(service_definition) = <version>->content( )->get_service_definition( ).
        me->add_to_rel( i_tgt_type = 'SRVD'
                        i_tgt_name = CONV #( service_definition->name )
                        i_relation = 'DDLS_BIND' ).
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
