@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reuse View for Development Objects'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZEI_R_DevObjects
  as select from tadir
{
  key pgmid      as ProgramId,
  key object     as ABAPObjectType,
  key obj_name   as ABAPObject,
      korrnum    as RequestTaskUpToRelease3,
      srcsystem  as OriginalSystem,
      author     as PersonResponsible,
      srcdep     as RepairFlag,
      devclass   as ABAPPackage,
      genflag    as IsGeneratedFlag,
      edtflag    as OnlyEditableInSpecialEditor,
      //      cproject   as Cproject,
      masterlang as OriginalLanguage,
      //      versid     as VersionId,
      paknocheck as PackageCheckExceptionIndicator,
      objstablty as DeploymentTarget,
      component  as SoftwareComponent,
      crelease   as SAPRelease,
      delflag    as IsDeleted,
      translttxt as TranslateTechnicalTextFlag,
      created_on as CreatedOn,
      check_date as CheckedOn,
      check_cfg  as CheckConfigurationIndicator
}
