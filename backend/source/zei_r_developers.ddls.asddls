@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reuse View for Developers'
define view entity ZEI_R_Developers
  as select from    devaccess as _Developer
    left outer join usr21     as _Assignment on _Developer.uname = _Assignment.bname
    left outer join adrp      as _Adress     on _Assignment.persnumber = _Adress.persnumber
{
  key _Developer.uname   as Developer,
      _Adress.name_first as Firstname,
      _Adress.name_last  as Lastname
}
