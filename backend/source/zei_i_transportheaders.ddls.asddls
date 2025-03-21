@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Transport Headers'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZEI_I_TransportHeaders
  as select from ZEI_R_TransportHeaders

  association [0..1] to ZEI_I_TransportHeaders    as _ParentRequest on _ParentRequest.RequestTask = $projection.ParentRequest
  association [0..*] to ZEI_I_TransportHeaders    as _Tasks         on _Tasks.ParentRequest = $projection.RequestTask
  association [0..*] to ZEI_I_TransportEntries    as _Entries       on _Entries.RequestTask = $projection.RequestTask
  association [0..1] to ZEI_I_Developers          as _Owner         on _Owner.Developer = $projection.Owner
  association [0..*] to ZEI_I_TransportAttributes as _Attributes    on _Attributes.RequestTask = $projection.RequestTask

  association [0..1] to ZEI_I_RequestTaskTypeVH   as _TypeText      on $projection.Type = _TypeText.Value
  association [0..1] to ZEI_I_TransportStatusVH   as _StatusText    on $projection.Type = _StatusText.Value
{

  key RequestTask,
      Description,
      Type,
      _TypeText.Text   as TypeText,
      Status,
      _StatusText.Text as StatusText,
      TransportTarget,
      Category,
      Owner,
      _Owner.Fullname  as OwnerFullname,
      ChangedOn,
      ChangedAt,
      ParentRequest,

      _ParentRequest,
      _Tasks,
      _Entries,
      _Owner,
      _Attributes
}
