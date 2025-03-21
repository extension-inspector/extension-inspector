@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reuse View for Object Definitions'
define root view entity ZEI_R_ObjectDefinitions
  as select from zei_object_def
{
  key guid            as Guid,
      src_object_type as SourceObjectType,
      src_object_name as SourceObjectName,
      def_type        as DefinitionType,
      access_modifier as AccessModifier,
      def_name        as DefinitionName,
      ref_var1        as ReferenceVariable1,
      ref_var2        as ReferenceVariable2,
      created_at      as CreatedAt,
      created_on      as CreatedOn
}
