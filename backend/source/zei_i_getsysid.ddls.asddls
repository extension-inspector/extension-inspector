@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for System Id'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZEI_I_GetSysId
  as select from ZEI_R_DevObjects
{
  key ProgramId      as BaseFilter,
      OriginalSystem as SystemId
}
where
      ProgramId      = 'HEAD'
  and ABAPObjectType = 'SYST'
