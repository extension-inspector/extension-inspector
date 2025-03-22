@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Transport Users'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZEI_I_TransportUsers
  as select distinct from ZEI_I_TransportHeaders
{
  key Owner,
      OwnerFirstName,
      OwnerLastName,
      OwnerFullname
}
