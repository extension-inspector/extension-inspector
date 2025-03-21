@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Int. View for Dist.  Release Information'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZEI_I_ReleaseInfoDistinct
  as select distinct from ZEI_R_ReleaseInfo
{
  key ABAPObject,
  key ABAPObjectType,
  key CompatibilityContract,
      ObjectName,
      ReleaseState,
      UseInKeyUserApps,
      UseInSapCloudPlatform,
      SoftwareReleaseName,
      FeatureToggleId,
      SuccessorClassification,
      SuccessorObjectType,
      SuccessorObjectName,
      SuccessorSubObjectType,
      SuccessorSubObjectName,
      SuccessorConceptName,
      Origin,
      CreatedAt,
      CreatedBy,
      LastChangedAt,
      LastChangedBy
}
