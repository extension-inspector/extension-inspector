@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reuse View for Object Relations'
define root view entity ZEI_R_ObjectRelations
  as select from zei_object_rel
{
  key guid            as Guid,
      src_object_type as SourceObjectType,
      src_object_name as SourceObjectName,
      tgt_object_type as TargetObjectType,
      tgt_object_name as TargetObjectName,
      relation        as Relation,
      created_at      as CreatedAt,
      created_on      as CreatedOn
}
