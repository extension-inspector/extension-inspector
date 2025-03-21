@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reuse View for Building Block Head'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZEI_R_BuildingBlockHead
  as select from zei_bb_head
{
  key bb_guid   as Guid,
      type      as Type,
      name      as Name,
      parent_bb as ParentBBGuid
}
