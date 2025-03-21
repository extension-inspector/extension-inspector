@EndUserText.label: 'Projection View for Release Information'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI.headerInfo: {
    typeName: 'Release Information',
    typeNamePlural: 'Release Information'
}


define root view entity ZEI_C_ReleaseInfo
  as projection on ZEI_I_ReleaseInfo
{
  key ABAPObject,
  key ABAPObjectType,
  key ABAPSubObjectType,
  key ABAPSubObjectName,
      @UI.lineItem: [{ position: 10 }]
      @UI.hidden: true
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
