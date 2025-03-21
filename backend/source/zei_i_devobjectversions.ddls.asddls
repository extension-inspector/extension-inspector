@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Int.  View for Development Object Vers.'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZEI_I_DevObjectVersions
  as select distinct from ZEI_R_DevObjectVersions
{
  key  ABAPObjectType,
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
     end  as ABAPObjectTypeMain,
       //  key VersionNumber,
  key  ABAPObject,
  key  case instr(ABAPObject, ' ')
        when 0 then ABAPObject
        else left(ABAPObject, instr(ABAPObject, ' '))
      end as MainObject,
  key  VersionRequestNumber,
       CreatedBy,
       CreatedOn,
       CreatedAt,
       '' as LockedIn
}

union select from ZEI_R_TransportEntries
association [1] to ZEI_R_TransportHeaders as _TransportHeader on _TransportHeader.RequestTask = $projection.VersionRequestNumber
{
  key  ABAPObjectType,
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
   end                            as ABAPObjectTypeMain,
  key  ABAPObject,
  key  case instr(ABAPObject, ' ')
     when 0 then ABAPObject
     else left(ABAPObject, instr(ABAPObject, ' '))
   end                            as MainObject,
  key  RequestTask                as VersionRequestNumber,
       _TransportHeader.Owner     as CreatedBy,
       _TransportHeader.ChangedOn as CreatedOn,
       _TransportHeader.ChangedAt as CreatedAt,
       'X'                        as LockedIn
}
where
  IsLocked = 'X'
