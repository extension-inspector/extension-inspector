@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Int. View for Extension Base Objects'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZEI_I_ExtensionBaseObjects
  as select distinct from ZEI_I_ExtensionRelevantEntries as _Base
  // Make sure objects actually exist on the system and are not deleted
    inner join            ZEI_R_DevObjects               as _SystemObjects on  _Base.ABAPObjectType     = _SystemObjects.ABAPObjectType
                                                                           and _Base.ABAPObject         = _SystemObjects.ABAPObject
                                                                           and _SystemObjects.IsDeleted = ''
  association [1..*] to ZEI_I_TransportEntries as _TransportEntries on  $projection.ABAPObjectType = _TransportEntries.ABAPObjectType
                                                                    and $projection.ABAPObject     = _TransportEntries.ABAPObject

{
  key _Base.ABAPObjectType,
  key _Base.ABAPObject,
      _TransportEntries

}
where
       _Base.RequestTaskStart = _Base.SystemId
  and  _Base.ProgramId        = 'R3TR'
  and(
       _Base.ABAPObjectType   = 'TABL'
    or _Base.ABAPObjectType   = 'CLAS'
    or _Base.ABAPObjectType   = 'DDLS'
    //or _Base.ABAPObjectType   = 'DTEL'
    or _Base.ABAPObjectType   = 'PROG'
    or _Base.ABAPObjectType   = 'REPS'
    or _Base.ABAPObjectType   = 'TTYP'
    or _Base.ABAPObjectType   = 'SFPF'
    or _Base.ABAPObjectType   = 'FUGR'
    or _Base.ABAPObjectType   = 'ENHO'
    or _Base.ABAPObjectType   = 'INTF'
    or _Base.ABAPObjectType   = 'SICF'
    or _Base.ABAPObjectType   = 'IWSG'
    or _Base.ABAPObjectType   = 'IWOM'
    or _Base.ABAPObjectType   = 'TRAN'
    or _Base.ABAPObjectType   = 'SUSH'
    //or _Base.ABAPObjectType   = 'DOMA'
    or _Base.ABAPObjectType   = 'TOBJ'
    or _Base.ABAPObjectType   = 'SFPI'
    or _Base.ABAPObjectType   = 'BDEF'
    or _Base.ABAPObjectType   = 'SUSK'
    or _Base.ABAPObjectType   = 'DDLX'
    or _Base.ABAPObjectType   = 'DCLS'
    or _Base.ABAPObjectType   = 'IWVB'
    or _Base.ABAPObjectType   = 'IWSV'
    or _Base.ABAPObjectType   = 'IWMO'
    or _Base.ABAPObjectType   = 'LRCC'
    or _Base.ABAPObjectType   = 'SRVB'
    or _Base.ABAPObjectType   = 'SRVD'
    or _Base.ABAPObjectType   = 'UIAD'
    or _Base.ABAPObjectType   = 'VIEW'
    or _Base.ABAPObjectType   = 'G4BA'
    or _Base.ABAPObjectType   = 'UIPC'
    or _Base.ABAPObjectType   = 'MSAG'
    or _Base.ABAPObjectType   = 'SMBC'
    or _Base.ABAPObjectType   = 'LRST'
    or _Base.ABAPObjectType   = 'SXCI'
    or _Base.ABAPObjectType   = 'CFDF'
    or _Base.ABAPObjectType   = 'WAPA'
    or _Base.ABAPObjectType   = 'CMOD'
    or _Base.ABAPObjectType   = 'SHLP'
    or _Base.ABAPObjectType   = 'XSLT'
    or _Base.ABAPObjectType   = 'ENBC'
    or _Base.ABAPObjectType   = 'SAJT'
    or _Base.ABAPObjectType   = 'ENQU'
    or _Base.ABAPObjectType   = 'PARA'
    or _Base.ABAPObjectType   = 'SAJC'
    or _Base.ABAPObjectType   = 'SCNT'
    or _Base.ABAPObjectType   = 'FDT0'
    or _Base.ABAPObjectType   = 'ADVD'
    or _Base.ABAPObjectType   = 'UISC'
    or _Base.ABAPObjectType   = 'SUSO'
    or _Base.ABAPObjectType   = 'ENHS'
    or _Base.ABAPObjectType   = 'NROB'
    or _Base.ABAPObjectType   = 'IEXT'
    or _Base.ABAPObjectType   = 'IWPR'
    or _Base.ABAPObjectType   = 'ADVC'
    or _Base.ABAPObjectType   = 'SF02'
    or _Base.ABAPObjectType   = 'EVTB'
    or _Base.ABAPObjectType   = 'SCVI'
    or _Base.ABAPObjectType   = 'SSFO'
    or _Base.ABAPObjectType   = 'UIAC'
    or _Base.ABAPObjectType   = 'CHDO'
    or _Base.ABAPObjectType   = 'SUSC'
    or _Base.ABAPObjectType   = 'SCCV'
    or _Base.ABAPObjectType   = 'IWNG'
    or _Base.ABAPObjectType   = 'FORM'
    or _Base.ABAPObjectType   = 'BOBF'
    or _Base.ABAPObjectType   = 'SUCO'
    or _Base.ABAPObjectType   = 'JOBD'
    or _Base.ABAPObjectType   = 'AUTH'
    or _Base.ABAPObjectType   = 'PINF'
    or _Base.ABAPObjectType   = 'SXSD'
  )
