@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Development Objects'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZEI_I_DevObjects
  as select from ZEI_R_DevObjects

  association [0..*] to ZEI_I_TransportEntries        as _TransportEntries  on  _TransportEntries.ProgramId      = $projection.ProgramId
                                                                            and _TransportEntries.ABAPObjectType = $projection.ABAPObjectType
                                                                            and _TransportEntries.ABAPObject     = $projection.ABAPObject
  association [1]    to ZEI_I_DevPackages             as _ABAPPackage       on  _ABAPPackage.ABAPPackage = $projection.ABAPPackage
  association [1]    to ZEI_I_DevPackages             as _ParentABAPPackage on  _ParentABAPPackage.ABAPPackage = $projection.ParentABAPPackage
  association [1]    to ZEI_I_Developers              as _PersonResponsible on  _PersonResponsible.Developer = $projection.PersonResponsible
  association [1]    to I_Language                    as _OriginalLanguage  on  _OriginalLanguage.Language = $projection.OriginalLanguage
  association [0..*] to ZEI_I_ObjectRelations         as _AccessTo          on  _AccessTo.SourceObjectType = $projection.ABAPObjectType
                                                                            and _AccessTo.SourceObjectName = $projection.ABAPObject
                                                                            and _AccessTo.Relation         = 'LNK_DASHED'
  association [0..*] to ZEI_I_ObjectRelations         as _AccessFrom        on  _AccessFrom.TargetObjectType = $projection.ABAPObjectType
                                                                            and _AccessFrom.TargetObjectName = $projection.ABAPObject
                                                                            and _AccessFrom.Relation         = 'LNK_DASHED'
  association [0..*] to ZEI_I_DevObjectVersionsCnsldt as _CnsldtVersions    on  _CnsldtVersions.ABAPObjectType = $projection.ABAPObjectType
                                                                            and _CnsldtVersions.MainObject     = $projection.ABAPObject
  association [0..*] to ZEI_I_ReleaseInfo             as _ReleaseInfo       on  _ReleaseInfo.ABAPObjectType = $projection.ABAPObjectType
                                                                            and _ReleaseInfo.ABAPObject     = $projection.ABAPObject
  association [0..1] to ZEI_I_ReleaseInfoDistinct     as _ReleaseState      on  _ReleaseState.ABAPObjectType = $projection.ABAPObjectType
                                                                            and _ReleaseState.ABAPObject     = $projection.ABAPObject
                                                                            and _ReleaseState.ReleaseState   = 'RELEASED'
  association [0..1] to ZEI_I_ReleaseInfoDistinct     as _ReleaseSuccessor  on  _ReleaseSuccessor.ABAPObjectType      = $projection.ABAPObjectType
                                                                            and _ReleaseSuccessor.ABAPObject          = $projection.ABAPObject
                                                                            and _ReleaseSuccessor.SuccessorObjectName is not initial
  association [0..*] to ZEI_I_DevObjects              as _PackageSubObjects on  _PackageSubObjects.ParentABAPPackage = $projection.ABAPObject
{
  key ProgramId,
  key ABAPObjectType,
  key ABAPObject,

      RequestTaskUpToRelease3,
      OriginalSystem,
      PersonResponsible,
      _PersonResponsible.Fullname                                                         as PersonResponsibleFullname,
      RepairFlag,
      ABAPPackage,
      case when ABAPObjectType = 'DEVC'
       then _ABAPPackage.SuperPackage
       else ABAPPackage
      end                                                                                 as ParentABAPPackage,
      IsGeneratedFlag,
      OnlyEditableInSpecialEditor,
      OriginalLanguage,
      _OriginalLanguage._Text[ Language = $session.system_language
                               and LanguageCode = $session.system_language ].LanguageName as OriginalLanguageName,
      PackageCheckExceptionIndicator,
      DeploymentTarget,
      SoftwareComponent,
      SAPRelease,
      IsDeleted,
      TranslateTechnicalTextFlag,
      CreatedOn,
      CheckedOn,
      CheckConfigurationIndicator,

      _ReleaseState.UseInSapCloudPlatform                                                 as ReleasedForCloudDevelopment,
      _ReleaseState.UseInKeyUserApps                                                      as ReleasedForKeyUserApps,
      _ReleaseSuccessor.SuccessorObjectType                                               as SuccessorABAPObjectType,
      _ReleaseSuccessor.SuccessorObjectName                                               as SuccessorABAPObject,

      _TransportEntries,
      _ABAPPackage,
      _ParentABAPPackage,
      _PersonResponsible,
      _OriginalLanguage,
      _AccessTo,
      _AccessFrom,
      _CnsldtVersions,
      _ReleaseInfo,
      _PackageSubObjects
}
where
  ABAPObject is not initial
