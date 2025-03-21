@EndUserText.label: 'P. V. for Cnsldt Dev. Object Versions'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZEI_C_DevObjectVersionCnsldt
  as projection on ZEI_I_DevObjectVersionsCnsldt
{
  key ABAPObjectType,
  key MainObject,
  key VersionRequestNumber,
      CreatedBy,
      CreatedOn,
      CreatedAt,
      LockedIn

}
