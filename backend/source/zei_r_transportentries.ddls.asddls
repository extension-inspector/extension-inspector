@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reuse View for Transport Entries'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZEI_R_TransportEntries
  as select from e071
{
  key trkorr   as RequestTask,
  key as4pos   as As4Pos,
      pgmid    as ProgramId,
      object   as ABAPObjectType,
      obj_name as ABAPObject,
      objfunc  as ObjectFunction,
      lockflag as IsLocked,
      gennum   as Gennum,
      lang     as Language,
      activity as Activity
}
