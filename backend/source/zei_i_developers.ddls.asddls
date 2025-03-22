@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Developers'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZEI_I_Developers
  as select from ZEI_R_Developers

  association [0..*] to ZEI_I_TransportHeaders as _TransportHeaders on _TransportHeaders.Owner = $projection.Developer
{
  key Developer,
      Firstname,
      Lastname,
      concat_with_space(Firstname, Lastname, 1) as Fullname,

      _TransportHeaders
}
