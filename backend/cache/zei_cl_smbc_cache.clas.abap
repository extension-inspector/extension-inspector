CLASS zei_cl_smbc_cache DEFINITION PUBLIC FINAL INHERITING FROM zei_cl_cacheobject CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      cache REDEFINITION.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA:
        business_config TYPE REF TO if_mbc_api_business_config.

ENDCLASS.



CLASS zei_cl_smbc_cache IMPLEMENTATION.

  METHOD cache.
    business_config = mbc_api=>business_configuration(  CONV #( object_name ) ).

    IF business_config->exists( ) = abap_false.
      RETURN.
    ENDIF.

    DATA(settings) = business_config->read( ).

    me->add_to_def( i_def_type = 'VERSION'
                    i_access_modifier = '+'
                    i_def_name = CONV #( settings-service_version ) ).

    me->add_to_rel( i_tgt_type = 'SRVB'
                    i_tgt_name = settings-service_binding
                    i_relation = 'LNK_SOLID' ).

  ENDMETHOD.

ENDCLASS.
