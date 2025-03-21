@EndUserText.label: 'Projection View for Object Relations'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Search.searchable: true
@UI.headerInfo: {
    typeName: 'Accessed Object',
    typeNamePlural: 'Accessed Objects'
}

define root view entity ZEI_C_ObjectRelations
  as projection on ZEI_I_ObjectRelations
{

  key Guid,
      @Search.defaultSearchElement: true
      SourceObjectType,
      @Search.defaultSearchElement: true
      SourceObjectName,
      @Search.defaultSearchElement: true
      TargetObjectType,
      @Search.defaultSearchElement: true
      TargetObjectName,
      Relation,
      CreatedAt,
      @UI.lineItem:[{ position: 10, hidden: true }]
      CreatedOn
}
