@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Building Block Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZEI_I_BuildingBlockItem
  as select from ZEI_R_BuildingBlockItem
  association [1..1] to ZEI_I_BuildingBlockHead as _BuildingBlock on  $projection.BuildingBlockGuid = _BuildingBlock.Guid
  association [1..1] to ZEI_I_DevObjects        as _Object        on  $projection.ObjectType = _Object.ABAPObjectType
                                                                  and $projection.ObjectName = _Object.ABAPObject
{
  key BuildingBlockGuid,
  key ObjectType,
  key ObjectName,

      _BuildingBlock,
      _Object
}
