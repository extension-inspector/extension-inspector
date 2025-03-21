@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface for KPI Most Accessed Objects'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZEI_C_KPI_MostAccessedObjects
  as select from ZEI_I_ObjectRelations
{
  key TargetObjectType,
  key TargetObjectName,
      count(*) as Accesses
}
where
  Relation = 'LNK_DASHED'
group by
  TargetObjectType,
  TargetObjectName
