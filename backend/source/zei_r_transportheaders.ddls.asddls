@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reuse View for Transport Request'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZEI_R_TransportHeaders
  as select from    e070  as _Header
    left outer join usr21 as _Assignment on _Header.as4user = _Assignment.bname
    left outer join adrp  as _Address    on _Assignment.persnumber = _Address.persnumber
    left outer join e07t  as _Text       on  _Header.trkorr = _Text.trkorr
                                         and _Text.langu    = $session.system_language
{
  key _Header.trkorr      as RequestTask,
      _Text.as4text       as Description,
      _Header.trfunction  as Type,
      _Header.trstatus    as Status,
      _Header.tarsystem   as TransportTarget,
      _Header.korrdev     as Category,
      _Header.as4user     as Owner,
      _Address.name_first as OwnerFirstName,
      _Address.name_last  as OwnerLastName,
      _Header.as4date     as ChangedOn,
      _Header.as4time     as ChangedAt,
      _Header.strkorr     as ParentRequest
}
