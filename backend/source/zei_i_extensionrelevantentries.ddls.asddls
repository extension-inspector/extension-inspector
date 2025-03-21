@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Int. View for Ext. Rel. T. Sys. Entries'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZEI_I_ExtensionRelevantEntries
  as select from    ZEI_I_TransportEntries as _Base
    left outer join ZEI_I_GetSysId         as _SysId on _SysId.BaseFilter = 'HEAD'
{
  key _Base.RequestTask,
  key _Base.As4Pos,
      _Base.ProgramId,
      _Base.ABAPObjectType,
      _Base.ABAPObject,
      left(_Base.RequestTask, 3) as RequestTaskStart,
      _SysId.SystemId
}
