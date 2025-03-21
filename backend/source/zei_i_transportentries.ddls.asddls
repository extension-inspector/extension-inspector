@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Transport Entries'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZEI_I_TransportEntries
  as select from ZEI_R_TransportEntries

  association [1]    to ZEI_I_TransportHeaders as _RequestTask on  _RequestTask.RequestTask = $projection.RequestTask
  association [0..1] to ZEI_I_DevObjects       as _DevObject   on  _DevObject.ProgramId      = $projection.ProgramId
                                                               and _DevObject.ABAPObjectType = $projection.ABAPObjectType
                                                               and _DevObject.ABAPObject     = $projection.ABAPObject
  association [1]    to I_Language             as _Language    on  _Language.Language = $projection.Language
{
  key RequestTask,
  key As4Pos,
      ProgramId,
      ABAPObjectType,
      ABAPObject,
      ObjectFunction,
      IsLocked,
      Gennum,
      Language,
      Activity,

      _DevObject.PersonResponsible,
      _DevObject.PersonResponsibleFullname,
      _DevObject.IsDeleted,
      _DevObject.ParentABAPPackage,

      _RequestTask,
      _DevObject,
      _Language
}
