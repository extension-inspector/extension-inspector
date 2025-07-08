CLASS zei_cl_dcls_cache DEFINITION PUBLIC FINAL INHERITING FROM zei_cl_cacheobject CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      cache REDEFINITION.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS zei_cl_dcls_cache IMPLEMENTATION.

  METHOD cache.

  " TODO add relationship for inherited ddls sources

    SELECT *
        FROM acmdclmetadataen
        WHERE artifactname = @object_name
        INTO TABLE @DATA(controlled_entities).

    LOOP AT controlled_entities ASSIGNING FIELD-SYMBOL(<controlled_entity>).
      me->add_to_rel( i_tgt_type = 'DDLS'
                      i_tgt_name = CONV #( to_upper( <controlled_entity>-entity_id ) )
                      i_relation = 'DCLS_FOR' ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
