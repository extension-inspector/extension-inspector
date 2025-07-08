CLASS zei_cl_sajc_cache DEFINITION PUBLIC FINAL INHERITING FROM zei_cl_cacheobject CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      cache REDEFINITION.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS zei_cl_sajc_cache IMPLEMENTATION.

  METHOD cache.

    SELECT SINGLE FROM apj_w_jce_root
        FIELDS *
        WHERE job_catalog_entry_name = @object_name
        INTO @DATA(properties).

    IF properties-report_name IS NOT INITIAL.
      me->add_to_rel( i_tgt_type = 'CLAS'
                  i_tgt_name = CONV #( to_upper( properties-report_name ) )
                  i_relation = 'SAJC_IM_EX' ).
    ENDIF.

    IF properties-check_class IS NOT INITIAL.
      me->add_to_rel( i_tgt_type = 'CLAS'
                  i_tgt_name = CONV #( to_upper( properties-check_class ) )
                  i_relation = 'SAJC_IM_CK' ).
    ENDIF.

    IF properties-value_help_exit_class IS NOT INITIAL.
      me->add_to_rel( i_tgt_type = 'CLAS'
                  i_tgt_name = CONV #( to_upper( properties-value_help_exit_class ) )
                  i_relation = 'SAJC_IM_VH' ).
    ENDIF.

    IF properties-notif_exit_class IS NOT INITIAL.
      me->add_to_rel( i_tgt_type = 'CLAS'
                  i_tgt_name = CONV #( to_upper( properties-notif_exit_class ) )
                  i_relation = 'SAJC_IM_NO' ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
