@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Int.  View for Development Object Vers.'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZEI_I_DevObjectVersionsCnsldt
  as select distinct from ZEI_R_DevObjectVersions
{
  key  case ABAPObjectType
       when 'CINC' then 'CLAS'
       when 'CPRI' then 'CLAS'
       when 'CPRO' then 'CLAS'
       when 'CPUB' then 'CLAS'
       when 'CLSD' then 'CLAS'
       when 'METH' then 'CLAS'
       when 'REPT' then 'PROG'
       when 'REPS' then 'PROG'
       when 'VIED' then 'VIEW'
       else ABAPObjectType
     end                            as ABAPObjectType,
       //  key VersionNumber,
  key  case instr(ABAPObject, ' ')
        when 0 then ABAPObject
        else left(ABAPObject, instr(ABAPObject, ' '))
      end                           as MainObject,
  key  VersionRequestNumber,
       CreatedBy,
       CreatedOn,
       CreatedAt,
       ''                           as LockedIn
}

union select from ZEI_R_TransportEntries
association [1] to ZEI_R_TransportHeaders as _TransportHeader on _TransportHeader.RequestTask = $projection.VersionRequestNumber
{
  key  case ABAPObjectType
     when 'CINC' then 'CLAS'
     when 'CPRI' then 'CLAS'
     when 'CPRO' then 'CLAS'
     when 'CPUB' then 'CLAS'
     when 'CLSD' then 'CLAS'
     when 'METH' then 'CLAS'
     when 'REPT' then 'PROG'
     when 'REPS' then 'PROG'
     else ABAPObjectType
   end                              as ABAPObjectType,
  key  case instr(ABAPObject, ' ')
     when 0 then ABAPObject
     else left(ABAPObject, instr(ABAPObject, ' '))
   end                              as MainObject,
  key  RequestTask                  as VersionRequestNumber,
       _TransportHeader.Owner       as CreatedBy,
       _TransportHeader.ChangedOn   as CreatedOn,
       _TransportHeader.ChangedAt   as CreatedAt,
       'X'                          as LockedIn
}
where
  IsLocked = 'X'
