@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Transport System - Object Entries'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZEI_I_TRANSPORTSYSTEMENTRIES
  as select from    e071 as _ObjectEntries
    left outer join e070 as _TransportHeaders    on _ObjectEntries.trkorr = _TransportHeaders.trkorr
    left outer join e07t as _TransportHeaderText on  _ObjectEntries.trkorr      = _TransportHeaderText.trkorr
                                                 and _TransportHeaderText.langu = $session.system_language
{
  key _ObjectEntries.trkorr        as RequestOrTask,
  key _ObjectEntries.as4pos        as As4pos,
      _ObjectEntries.pgmid         as ABAPObjectCategory,
      _ObjectEntries.object        as ABAPObjectType,
      _ObjectEntries.obj_name      as ABAPObject,
      _ObjectEntries.objfunc       as Objfunc,
      _ObjectEntries.lockflag      as IsLocked,
      _ObjectEntries.gennum        as Gennum,
      _ObjectEntries.lang          as Language,
      _ObjectEntries.activity      as Activity,

      _TransportHeaders.strkorr    as ParentRequest,
      _TransportHeaderText.as4text as Description
}
