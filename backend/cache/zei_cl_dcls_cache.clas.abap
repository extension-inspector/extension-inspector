CLASS zei_cl_dcls_cache DEFINITION PUBLIC FINAL INHERITING FROM zei_cl_cacheobject CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      cache REDEFINITION.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS zei_cl_dcls_cache IMPLEMENTATION.

  METHOD cache.
    " handle relations to controlled ddls
    SELECT *
        FROM acmdclmetadataen
        WHERE artifactname = @object_name
        INTO TABLE @DATA(controlled_entities).

    LOOP AT controlled_entities ASSIGNING FIELD-SYMBOL(<controlled_entity>).
      me->add_to_rel( i_tgt_type = 'DDLS'
                      i_tgt_name = CONV #( to_upper( <controlled_entity>-entity_id ) )
                      i_relation = 'DCLS_FOR' ).
    ENDLOOP.

    " handle relations to dcls we are inheriting from
    SELECT FROM acmdclmetadatair
        FIELDS *
        WHERE artifactname = @object_name
        INTO TABLE @DATA(parent_entities).

    LOOP AT parent_entities ASSIGNING FIELD-SYMBOL(<parent>).
      me->add_to_rel( i_tgt_type = 'DCLS'
                      i_tgt_name = CONV #( to_upper( <parent>-inherit_from_entityname ) )
                      i_relation = 'DCLS_INH' ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
