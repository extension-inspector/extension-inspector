CLASS zei_cl_ddls_cache DEFINITION PUBLIC FINAL INHERITING FROM zei_cl_cacheobject CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      cache REDEFINITION.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA:
        data_definition TYPE REF TO if_xco_data_definition.

    METHODS:
      _handle_type,
      _handle_data_source,
      _handle_joins
        IMPORTING
          joins TYPE sxco_t_ddl_expr_data_sources,
      _handle_query_implementation
        IMPORTING
          ddls TYPE sxco_cds_object_name,
      _handle_associations
        IMPORTING
          associations TYPE sxco_t_cds_associations,
      _handle_compositions
        IMPORTING
          compositions TYPE sxco_t_cds_compositions,
      _handle_access_control,
      _handle_behavior_definition.

ENDCLASS.



CLASS zei_cl_ddls_cache IMPLEMENTATION.

  METHOD cache.
    data_definition = xco_cds=>data_definition( CONV #( object_name ) ).

    IF data_definition->exists( ) = abap_false.
      RETURN.
    ENDIF.

    _handle_type( ).
    _handle_data_source( ).
    _handle_access_control( ).
    _handle_behavior_definition( ).
  ENDMETHOD.

  METHOD _handle_type.
    DATA(type) = data_definition->get_type( ).

    add_to_def( i_def_type = 'TYPE'
                i_access_modifier = '+'
                i_def_name = CONV #( type->value ) ).
  ENDMETHOD.

  METHOD _handle_data_source.
    DATA(type) = data_definition->get_type( )->value.

    TRY.

        " currently not handled: E, X, H, F
        CASE type.
          WHEN 'V'. " View
            DATA(view) = data_definition->view( ).
            DATA(view_data_source) = view->content( )->get_data_source( ).

            DATA(select_from_object) = view_data_source-entity.
            DATA(select_from_type) = 'DDLS'.
            DATA(select_from_object_object) = xco_cds=>data_definition( select_from_object ).
            IF select_from_object_object->exists( ) = abap_false.
              select_from_type = 'TABL'.
            ENDIF.

            me->add_to_rel( i_tgt_type = select_from_type
                            i_tgt_name = CONV #( to_upper( select_from_object ) )
                            i_relation = 'DDLS_SELECT' ).

            _handle_joins( view_data_source-inner_joins ).
            _handle_joins( view_data_source-left_outer_joins ).
            _handle_joins( view_data_source-right_outer_joins ).
            _handle_associations( view->associations->all->get( ) ).
            _handle_compositions( view->compositions->all->get( ) ).

          WHEN 'A'. " Abstract Entity
            DATA(abstract_entity) = data_definition->abstract_entity( ).
            " nothing to do here

          WHEN 'Q'. " Custom Entity
            _handle_query_implementation( data_definition->name ).

          WHEN 'P'. " Projection View
            DATA(projection_view) = data_definition->projection_view( ).
            DATA(projection_view_data_source) = projection_view->content( )->get_data_source( ).

            me->add_to_rel( i_tgt_type = 'DDLS'
                            i_tgt_name = CONV #( to_upper( projection_view_data_source-view_entity ) )
                            i_relation = 'DDLS_PROJ' ).

          WHEN 'W'. " View Entity
            DATA(view_entity) = data_definition->view_entity( ).
            DATA(view_entity_data_source) = view_entity->content( )->get_data_source( ).

            DATA(select_from_object1) = view_entity_data_source-view_entity.
            DATA(select_from_type1) = 'DDLS'.
            DATA(select_from_object_object1) = xco_cds=>data_definition( select_from_object1 ).
            IF select_from_object_object1->exists( ) = abap_false.
              select_from_type1 = 'TABL'.
            ENDIF.

            me->add_to_rel( i_tgt_type = select_from_type1
                            i_tgt_name = CONV #( to_upper( select_from_object1 ) )
                            i_relation = 'DDLS_SELECT' ).

            _handle_joins( view_data_source-inner_joins ).
            _handle_joins( view_data_source-left_outer_joins ).
            _handle_joins( view_data_source-right_outer_joins ).
            _handle_associations( view_entity->associations->all->get( ) ).
            _handle_compositions( view_entity->compositions->all->get( ) ).

        ENDCASE.

      CATCH cx_root INTO DATA(error).

    ENDTRY.
  ENDMETHOD.

  METHOD _handle_joins.
    DATA: join_expr TYPE REF TO cl_xco_ddl_expr_ds_join.
    LOOP AT joins ASSIGNING FIELD-SYMBOL(<join>).
      join_expr ?= <join>.
      DATA(source_lines) = join_expr->get_source( )->get_lines( ).
      DATA(source_line) = VALUE #( source_lines->value[ 1 ] ).
      REPLACE space WITH '@' INTO source_line.
      DATA(source) = substring_before( val = source_line sub = '@' ).

      me->add_to_rel( i_tgt_type = 'DDLS'
                      i_tgt_name = CONV #( to_upper( source ) )
                      i_relation = 'DDLS_IJOIN' ).
    ENDLOOP.
  ENDMETHOD.

  METHOD _handle_query_implementation.
    cl_dd_ddl_analyze=>get_annotations( EXPORTING
                                            ddlnames = VALUE #( ( to_upper( ddls ) ) )
                                            leaves_only = abap_true
                                        IMPORTING
                                            headerannos  = DATA(annotations) ).
    DATA(source) = VALUE #( annotations[ annoname = 'OBJECTMODEL.QUERY.IMPLEMENTEDBY' ]-value OPTIONAL ).
    source = substring( val = source off = 1 len = strlen( source ) - 2 ).
    source = substring_after( val = source sub = ':' ).

    me->add_to_rel( i_tgt_type = 'CLAS'
                    i_tgt_name = CONV #( to_upper( source ) )
                    i_relation = 'DDLS_IMPL' ).
  ENDMETHOD.

  METHOD _handle_associations.
    LOOP AT associations ASSIGNING FIELD-SYMBOL(<association>).
      me->add_to_rel( i_tgt_type = 'DDLS'
                      i_tgt_name = CONV #( to_upper( <association>->content( )->get_target( ) ) )
                      i_relation = 'DDLS_ASSOC' ).
    ENDLOOP.
  ENDMETHOD.

  METHOD _handle_compositions.
    LOOP AT compositions ASSIGNING FIELD-SYMBOL(<composition>).
      me->add_to_rel( i_tgt_type = 'DDLS'
                      i_tgt_name = CONV #( to_upper( <composition>->target ) )
                      i_relation = 'DDLS_COMP' ).
    ENDLOOP.
  ENDMETHOD.


  METHOD _handle_access_control.
    SELECT *
        FROM acmdclmetadataen
        WHERE entity_id = @data_definition->name
        INTO TABLE @DATA(access_controls).

    LOOP AT access_controls ASSIGNING FIELD-SYMBOL(<access_control>).
      me->add_to_rel( i_tgt_type = 'DCLS'
                      i_tgt_name = CONV #( to_upper( <access_control>-artifactname ) )
                      i_relation = 'DDLS_AC' ).
    ENDLOOP.
  ENDMETHOD.


  METHOD _handle_behavior_definition.
    SELECT ABAPObjectType, ABAPObject
        FROM ZEI_R_DevObjects
        WHERE ABAPObjectType = 'BDEF'
          AND ABAPObject = @data_definition->name
        INTO TABLE @DATA(behavior_definitions).

    LOOP AT behavior_definitions ASSIGNING FIELD-SYMBOL(<behavior_definition>).
      me->add_to_rel( i_tgt_type = 'BDEF'
                      i_tgt_name = CONV #( to_upper( <behavior_definition>-ABAPObject ) )
                      i_relation = 'DDLS_BDEF' ).
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
