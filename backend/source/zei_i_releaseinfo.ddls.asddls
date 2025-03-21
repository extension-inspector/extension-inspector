@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Release Information'
define root view entity ZEI_I_ReleaseInfo
  as select from ZEI_R_ReleaseInfo
{
  key ABAPObject,
  key ABAPObjectType,
  key ABAPSubObjectType,
  key ABAPSubObjectName,
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
