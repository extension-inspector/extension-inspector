@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Transport Attributes'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZEI_I_TransportAttributes
  as select from ZEI_R_TransportAttributes

  association [1] to ZEI_I_TransportHeaders as _RequestTask on _RequestTask.RequestTask = $projection.RequestTask
{
  key RequestTask,
  key PositionNumber,
      Attribute,
      Reference,

      _RequestTask
}
