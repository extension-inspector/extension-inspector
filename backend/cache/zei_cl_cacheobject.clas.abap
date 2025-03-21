CLASS zei_cl_cacheobject DEFINITION PUBLIC CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS:
      constructor
        IMPORTING
          i_object_type TYPE trobjtype
          i_object_name TYPE sobj_name,
      cache.

  PROTECTED SECTION.
    DATA:
      object_type TYPE trobjtype,
      object_name TYPE sobj_name.

    METHODS:
      add_to_def
        IMPORTING
          i_def_type        TYPE char10
          i_access_modifier TYPE char01
          i_def_name        TYPE char64
          i_ref_var1        TYPE char128 OPTIONAL
          i_ref_var2        TYPE char128 OPTIONAL,

      add_to_rel
        IMPORTING
          i_tgt_type TYPE trobjtype
          i_tgt_name TYPE sobj_name
          i_relation TYPE zei_relation.

  PRIVATE SECTION.

ENDCLASS.



CLASS zei_cl_cacheobject IMPLEMENTATION.

  METHOD constructor.
    me->object_type = i_object_type.
    me->object_name = i_object_name.
  ENDMETHOD.

  METHOD cache.

  ENDMETHOD.

  METHOD add_to_def.
    TRY.
        DATA(guid) = cl_system_uuid=>create_uuid_c32_static( ).
      CATCH cx_uuid_error.
        "won´t ever happen
    ENDTRY.

    MODIFY ENTITIES OF zei_i_objectdefinitions
      ENTITY ObjectDefinition
          CREATE FROM VALUE #( ( %cid = guid
                                 Guid = guid
                                 SourceObjectType = object_type
                                 SourceObjectName = object_name
                                 DefinitionType = i_def_type
                                 AccessModifier = i_access_modifier
                                 DefinitionName = i_def_name
                                 ReferenceVariable1 = i_ref_var1
                                 ReferenceVariable2 = i_ref_var2
                                 CreatedAt = cl_abap_context_info=>get_system_date( )
                                 CreatedOn = cl_abap_context_info=>get_system_time( )
                                 %control-Guid = if_abap_behv=>mk-on
                                 %control-SourceObjectType = if_abap_behv=>mk-on
                                 %control-SourceObjectName = if_abap_behv=>mk-on
                                 %control-DefinitionType = if_abap_behv=>mk-on
                                 %control-AccessModifier = if_abap_behv=>mk-on
                                 %control-DefinitionName = if_abap_behv=>mk-on
                                 %control-ReferenceVariable1 = if_abap_behv=>mk-on
                                 %control-ReferenceVariable2 = if_abap_behv=>mk-on
                                 %control-CreatedAt = if_abap_behv=>mk-on
                                 %control-CreatedOn = if_abap_behv=>mk-on ) )
          MAPPED DATA(mapped)
          REPORTED DATA(reported)
          FAILED DATA(failed).
  ENDMETHOD.

  METHOD add_to_rel.
    TRY.
        DATA(guid) = cl_system_uuid=>create_uuid_c32_static( ).
      CATCH cx_uuid_error.
        "won´t ever happen
    ENDTRY.

    MODIFY ENTITIES OF ZEI_I_ObjectRelations
    ENTITY ObjectRelation
          CREATE FROM VALUE #( ( %cid = guid
                                 Guid = guid
                                 SourceObjectType = object_type
                                 SourceObjectName = object_name
                                 TargetObjectType = i_tgt_type
                                 TargetObjectName = i_tgt_name
                                 Relation = i_relation
                                 CreatedAt = cl_abap_context_info=>get_system_date( )
                                 CreatedOn = cl_abap_context_info=>get_system_time( )
                                 %control-Guid = if_abap_behv=>mk-on
                                 %control-SourceObjectType = if_abap_behv=>mk-on
                                 %control-SourceObjectName = if_abap_behv=>mk-on
                                 %control-TargetObjectType = if_abap_behv=>mk-on
                                 %control-TargetObjectName = if_abap_behv=>mk-on
                                 %control-Relation = if_abap_behv=>mk-on
                                 %control-CreatedAt = if_abap_behv=>mk-on
                                 %control-CreatedOn = if_abap_behv=>mk-on ) )
          MAPPED DATA(mapped)
          REPORTED DATA(reported)
          FAILED DATA(failed).
  ENDMETHOD.

ENDCLASS.
