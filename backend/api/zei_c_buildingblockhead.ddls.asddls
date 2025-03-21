@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View for Building Block Head'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

@UI.headerInfo: {
    typeName: 'Building Block',
    typeNamePlural: 'Building Blocks'
}

define root view entity ZEI_C_BuildingBlockHead
  as projection on ZEI_I_BuildingBlockHead
{
  key Guid,
      @UI.lineItem: [{ position: 10 }]
      Type,
      @UI.lineItem: [{ position: 20 }]
      Name,
      ParentBBGuid,
      /* Associations */
      _Items : redirected to ZEI_C_BuildingBlockItem
}
where
  ParentBBGuid is initial
