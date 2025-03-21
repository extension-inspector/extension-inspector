@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reuse View for Release Information'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZEI_R_ReleaseInfo
  as select from ars_w_api_state
{
  key cast( object_id as sobj_name )                   as ABAPObject,
  key cast( object_type as trobjtype preserving type ) as ABAPObjectType,
  key sub_object_type                                  as ABAPSubObjectType,
  key sub_object_name                                  as ABAPSubObjectName,
  key compatibility_contract                           as CompatibilityContract,
      object_name                                      as ObjectName,
      release_state                                    as ReleaseState,
      use_in_key_user_apps                             as UseInKeyUserApps,
      use_in_sap_cloud_platform                        as UseInSapCloudPlatform,
      software_release_name                            as SoftwareReleaseName,
      feature_toggle_id                                as FeatureToggleId,
      successor_classification                         as SuccessorClassification,
      successor_object_type                            as SuccessorObjectType,
      successor_object_name                            as SuccessorObjectName,
      successor_sub_object_type                        as SuccessorSubObjectType,
      successor_sub_object_name                        as SuccessorSubObjectName,
      successor_concept_name                           as SuccessorConceptName,
      origin                                           as Origin,
      created_at                                       as CreatedAt,
      created_by                                       as CreatedBy,
      last_changed_at                                  as LastChangedAt,
      last_changed_by                                  as LastChangedBy
}
