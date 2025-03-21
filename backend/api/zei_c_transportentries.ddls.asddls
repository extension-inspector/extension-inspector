@EndUserText.label: 'Projection View for Transport Entries'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Search.searchable: true
@UI.headerInfo: {
    typeName: 'Transport Entry',
    typeNamePlural: 'Transport Entries'
}

define root view entity ZEI_C_TransportEntries
  as projection on ZEI_I_TransportEntries
{
          @UI.lineItem: [{hidden: true}]
          @Search.defaultSearchElement: true
  key     RequestTask,
  key     As4Pos,
          ProgramId,
          ABAPObjectType,
          ABAPObject,
          @Search.defaultSearchElement: true
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZEI_CL_CALC_C_OBJECTS'
  virtual ABAPObjectDescription : char80,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZEI_CL_CALC_C_OBJECTS'
  virtual ABAPObjectTypeName    : shvalue_d,

          @UI.selectionField: [{  position: 40 }]
          @ObjectModel.text.element: [ 'PersonResponsibleFullname' ]
          @Search.defaultSearchElement: true
          @UI.lineItem: [{hidden: true}]
          PersonResponsible,

          PersonResponsibleFullname,

          @UI.selectionField: [{  position: 30 }]
          @UI.lineItem: [{hidden: true}]
          ParentABAPPackage,

          @UI.selectionField: [{  position: 50 }]
          @UI.lineItem: [{hidden: true}]
          IsDeleted,

          ObjectFunction,
          IsLocked,
          Gennum,
          Language,
          Activity,
          /* Associations */
          _DevObject,
          _Language,
          _RequestTask
}
