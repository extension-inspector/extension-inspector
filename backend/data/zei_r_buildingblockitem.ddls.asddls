@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reuse View for Building Block Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZEI_R_BuildingBlockItem
  as select from zei_bb_items
{
  key bb_guid  as BuildingBlockGuid,
  key obj_type as ObjectType,
  key obj_name as ObjectName
}
