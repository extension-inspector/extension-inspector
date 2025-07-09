CLASS zei_cl_tran_cache DEFINITION PUBLIC FINAL INHERITING FROM zei_cl_cacheobject CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      cache REDEFINITION.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS zei_cl_tran_cache IMPLEMENTATION.

  METHOD cache.

    SELECT SINGLE FROM tstc
        FIELDS *
        WHERE tcode = @object_name
        INTO @DATA(properties).

    IF properties-pgmna IS NOT INITIAL.
      me->add_to_rel( i_tgt_type = 'PROG'
                      i_tgt_name = CONV #( to_upper( properties-pgmna ) )
                      i_relation = 'PROG_STARTS' ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
