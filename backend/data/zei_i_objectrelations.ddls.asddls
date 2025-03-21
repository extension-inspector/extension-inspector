@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Object Relations'
define root view entity ZEI_I_ObjectRelations
  as select from ZEI_R_ObjectRelations
{
  key Guid,
      SourceObjectType,
      SourceObjectName,
      TargetObjectType,
      TargetObjectName,
      Relation,
      CreatedAt,
      CreatedOn
}
