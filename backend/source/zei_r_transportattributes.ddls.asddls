@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reuse View for Transport Attributes'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZEI_R_TransportAttributes
  as select from e070a
{
  key trkorr    as RequestTask,
  key pos       as PositionNumber,
      attribute as Attribute,
      reference as Reference
}
