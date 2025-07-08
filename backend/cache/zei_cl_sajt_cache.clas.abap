CLASS zei_cl_sajt_cache DEFINITION PUBLIC FINAL INHERITING FROM zei_cl_cacheobject CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      cache REDEFINITION.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS zei_cl_sajt_cache IMPLEMENTATION.

  METHOD cache.

    SELECT SINGLE FROM apj_w_jt_root
        FIELDS *
        WHERE job_template_name = @object_name
        INTO @DATA(properties).

    IF properties-job_catalog_entry_name IS NOT INITIAL.
      me->add_to_rel( i_tgt_type = 'SAJC'
                  i_tgt_name = CONV #( to_upper( properties-job_catalog_entry_name ) )
                  i_relation = 'SAJT_FOR' ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
