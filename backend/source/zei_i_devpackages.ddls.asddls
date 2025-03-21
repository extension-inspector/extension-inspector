@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Development Packages'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZEI_I_DevPackages
  as select from ZEI_R_DevPackages

  association [0..1] to ZEI_I_DevPackages as _SuperPackage       on _SuperPackage.ABAPPackage = $projection.SuperPackage
  association [0..*] to ZEI_I_DevObjects  as _DevelopmentObjects on _DevelopmentObjects.ABAPPackage = $projection.ABAPPackage
  association [0..1] to ZEI_I_Developers  as _PersonResponsible  on _PersonResponsible.Developer = $projection.PersonResponsible
  association [0..1] to ZEI_I_Developers  as _CreatedBy          on _CreatedBy.Developer = $projection.CreatedBy
  association [0..1] to ZEI_I_Developers  as _ChangedBy          on _ChangedBy.Developer = $projection.ChangedBy
{
  key ABAPPackage,
      RecordObjectChangesinTransport,
      PersonResponsible,
      TransportLayer,
      SoftwareComponent,
      ApplicationComponent,
      Namespace,
      CustomerDeliveryFlag,
      DeliveryComponent,
      SuperPackage,
      ApplicationArea,
      TargetEnvironment,
      IsRestricted,
      PackageTypeIndicator,
      CreatedBy,
      CreatedOn,
      ChangedBy,
      ChangedOn,
      ProtectionLevel,
      PackageHasDCL,
      EnterpriseExtensionAlias,
      cProProjectGuid,
      ProjectAssignmentPassdown,
      IsEnhanceable,
      ABAPLanguageVersion,
      EnhancedPackage,
      AccessObject,
      PackageInterface,
      AllowClientInterfaceInheriting,
      TechnicalChangeTimestamp,
      OverallTimestamp,
      EncapsulationLevel,
      IsDclEnabled,
      SubKeyForGenerationAppend,
      HasAllowStatic,
      SwitchFrameworkSwitchId,
      CheckRule,

      _SuperPackage,
      _DevelopmentObjects,
      _PersonResponsible,
      _CreatedBy,
      _ChangedBy
}
