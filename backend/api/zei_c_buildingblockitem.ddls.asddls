@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View for Building Block Items'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZEI_C_BuildingBlockItem
  as projection on ZEI_I_BuildingBlockItem
{
  key BuildingBlockGuid,
      @UI.lineItem: [{ position: 10 }]
  key ObjectType,
      @UI.lineItem: [{ position: 20 }]
  key ObjectName,
      /* Associations */
      _BuildingBlock,
      _Object
}
