CLASS zei_cl_ddlx_cache DEFINITION PUBLIC FINAL INHERITING FROM zei_cl_cacheobject CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      cache REDEFINITION.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS zei_cl_ddlx_cache IMPLEMENTATION.

  METHOD cache.

    SELECT SINGLE FROM ddlx_rt_header
        FIELDS *
        WHERE ddlxname = @object_name
        INTO @DATA(properties).

    IF properties-extended_artifact IS NOT INITIAL.
      me->add_to_rel( i_tgt_type = 'DDLS'
                  i_tgt_name = CONV #( to_upper( properties-extended_artifact ) )
                  i_relation = 'DDLX_EXT' ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
