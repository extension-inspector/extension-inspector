@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Object Definitions'
define root view entity ZEI_I_ObjectDefinitions
  as select from ZEI_R_ObjectDefinitions
{
  key Guid,
      SourceObjectType,
      SourceObjectName,
      DefinitionType,
      AccessModifier,
      DefinitionName,
      ReferenceVariable1,
      ReferenceVariable2,
      CreatedAt,
      CreatedOn
}
