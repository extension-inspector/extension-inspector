@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Developers and Owners'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZEI_I_DevelopersOwners
  as select from ZEI_I_Developers
{

  key Developer,
      Firstname,
      Lastname,
      Fullname,
      cast('X' as boole_d) as IsDevelopmentUser,

      _TransportHeaders
}

union select from ZEI_I_TransportUsers as _TransportUser
  left outer join ZEI_I_Developers     as _Developer on _TransportUser.Owner = _Developer.Developer

association [0..*] to ZEI_I_TransportHeaders as _TransportHeaders on _TransportHeaders.Owner = $projection.Developer
{
  key _TransportUser.Owner          as Developer,
      _TransportUser.OwnerFirstName as Firstname,
      _TransportUser.OwnerLastName  as Lastname,
      _TransportUser.OwnerFullname  as Fullname,
      cast('' as boole_d)           as IsDevelopmentUser,

      _TransportHeaders
}

where
  _Developer.Developer is null
