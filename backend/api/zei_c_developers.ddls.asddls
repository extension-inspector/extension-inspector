@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View for Developers'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

@Search.searchable: true
@UI.headerInfo: {
    typeName: 'Developer',
    typeNamePlural: 'Developers'
}

define root view entity ZEI_C_Developers
  as projection on ZEI_I_DevelopersOwners
{
      @UI.lineItem: [{hidden: true}]
      @Search.defaultSearchElement: true
  key Developer,

      Firstname,

      Lastname,

      @UI.lineItem: [{hidden: true}]
      @Search.defaultSearchElement: true
      Fullname,

      @UI.selectionField: [{ position: 10 }]
      @UI.lineItem: [{hidden: true}]
      @EndUserText.label: 'Development User'
      IsDevelopmentUser,

      /* Associations */
      _TransportHeaders : redirected to ZEI_C_Transports
}
