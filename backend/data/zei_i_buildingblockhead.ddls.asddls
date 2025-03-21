@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Building Block Head'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZEI_I_BuildingBlockHead
  as select from ZEI_R_BuildingBlockHead
  association [1..*] to ZEI_I_BuildingBlockItem as _Items on $projection.Guid = _Items.BuildingBlockGuid
{
  key Guid,
      Type,
      Name,
      ParentBBGuid,

      _Items
}
