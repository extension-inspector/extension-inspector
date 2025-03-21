@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View for Custom Objects'

@Search.searchable: true
@UI.headerInfo: {
    typeName: 'Object',
    typeNamePlural: 'Objects'
}

define root view entity ZEI_C_OBJECTS
  as projection on ZEI_I_DevObjects
{
  key     ProgramId,

          @UI.lineItem: [{hidden: true}]
          @UI.selectionField: [{  position: 10 }]
          @Search.defaultSearchElement: true
          @ObjectModel.text.element: [ 'ABAPObjectTypeName' ]
          @UI.textArrangement: #TEXT_LAST
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZEI_I_OBJECTTYPEVH', element: 'ObjectType' } }]
  key     ABAPObjectType,

          @UI.lineItem: [{hidden: true}]
          @UI.selectionField: [{  position: 20 }]
          @Search.defaultSearchElement: true
  key     ABAPObject,

          @UI.lineItem: [{hidden: true}]
          @Consumption.filter.hidden: true
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZEI_CL_CALC_C_OBJECTS'
  virtual ABAPObjectDescription : char80,

          @Consumption.filter.hidden: true
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZEI_CL_CALC_C_OBJECTS'
  virtual ABAPObjectTypeName    : shvalue_d,

          @Consumption.filter.hidden: true
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZEI_CL_CALC_C_OBJECTS'
  virtual HasRelations          : boole_d,

          OriginalSystem,

          @UI.selectionField: [{  position: 40 }]
          @ObjectModel.text.element: [ 'PersonResponsibleFullname' ]
          @Search.defaultSearchElement: true
          @UI.lineItem: [{hidden: true}]
          PersonResponsible,

          PersonResponsibleFullname,

          @UI.hidden: true
          @Consumption.filter.hidden: true
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZEI_CL_CALC_C_OBJECTS'
  virtual ADTLink               : abap.char(256),

          @UI.hidden: true
          @Consumption.filter.hidden: true
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZEI_CL_CALC_C_OBJECTS'
  virtual WebLink               : abap.char(256),

          @Consumption.filter.hidden: true
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZEI_CL_CALC_C_OBJECTS'
  virtual LockedInTransport     : trkorr,

          ABAPPackage,

          @UI.selectionField: [{  position: 30 }]
          @UI.lineItem: [{hidden: true}]
          ParentABAPPackage,
          IsGeneratedFlag,
          OnlyEditableInSpecialEditor,

          OriginalLanguage,
          OriginalLanguageName,

          PackageCheckExceptionIndicator,
          DeploymentTarget,
          SoftwareComponent,
          SAPRelease,

          @UI.selectionField: [{  position: 50 }]
          @UI.lineItem: [{hidden: true}]
          @Consumption.filter.defaultValue: ''
          IsDeleted,
          TranslateTechnicalTextFlag,

          @UI.lineItem: [{ position: 60 }]
          @UI.selectionField: [{  position: 60 }]
          @Consumption.filter.selectionType: #INTERVAL
          CreatedOn,
          CheckedOn,
          CheckConfigurationIndicator,

          ReleasedForCloudDevelopment,
          ReleasedForKeyUserApps,
          SuccessorABAPObject,
          SuccessorABAPObjectType,

          /* Associations */
          _ABAPPackage,
          _OriginalLanguage,
          _ParentABAPPackage,
          _PersonResponsible,
          _TransportEntries,
          _AccessTo       : redirected to ZEI_C_ObjectRelations,
          _AccessFrom     : redirected to ZEI_C_ObjectRelations,
          _CnsldtVersions : redirected to ZEI_C_DevObjectVersionCnsldt,
          _ReleaseInfo    : redirected to ZEI_C_ReleaseInfo

}
