@EndUserText.label: 'Projection View for Transports'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Search.searchable: true
@UI.headerInfo: {
    typeName: 'Transport',
    typeNamePlural: 'Transports'
}

@UI.presentationVariant: [{
    sortOrder: [{
        by: 'ChangedOn'
    }],
    visualizations: [{
        type: #AS_LINEITEM
    }]}]

define root view entity ZEI_C_Transports
  as projection on ZEI_I_TransportHeaders
{
      @UI.lineItem: [{hidden: true}]
      @UI.selectionField: [{  position: 10 }]
      @Search.defaultSearchElement: true
  key RequestTask,

      @UI.lineItem: [{hidden: true}]
      @Search.defaultSearchElement: true
      Description,

      @UI.lineItem: [{ position: 30 }]
      @UI.selectionField: [{  position: 40 }]
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZEI_I_RequestTaskTypeVH', element: 'Value' } }]
      @ObjectModel.text.element: [ 'TypeText' ]
      @UI.textArrangement: #TEXT_ONLY
      Type,

      @UI.hidden: true
      TypeText,

      @UI.lineItem: [{ position: 35 }]
      @UI.selectionField: [{  position: 35 }]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZEI_I_TransportStatusVH', element: 'Value' } }]
      @ObjectModel.text.element: [ 'StatusText' ]
      @UI.textArrangement: #TEXT_ONLY
      Status,

      @UI.hidden: true
      StatusText,
      TransportTarget,
      Category,

      @UI.lineItem: [{hidden: true}]
      @UI.selectionField: [{  position: 30 }]
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZEI_C_Developers', element: 'Developer' } }]
      @ObjectModel.text.element: [ 'OwnerFullname' ]
      Owner,

      @UI.hidden: true
      OwnerFullname,

      @UI.lineItem: [{ position: 50 }]
      @UI.selectionField: [{  position: 50 }]
      @Search.defaultSearchElement: true
      @Consumption.filter.selectionType: #INTERVAL
      ChangedOn,
      ChangedAt,
      ParentRequest,

      /* Associations */
      _Attributes,
      _Entries       : redirected to ZEI_C_TransportEntries,
      _Owner,
      _Tasks         : redirected to ZEI_C_Transports,
      _ParentRequest : redirected to ZEI_C_Transports
}
