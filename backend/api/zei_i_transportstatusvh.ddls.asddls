@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'VH for the Type of a Request/Task'
@ObjectModel.resultSet.sizeCategory: #XS
define root view entity ZEI_I_TransportStatusVH
  as select from dd07t
{
       @ObjectModel.text.element: [ 'Text' ]
  key  dd07t.domvalue_l as Value,
       @Semantics.text: true
       dd07t.ddtext     as Text
}
where
      dd07t.as4local   = 'A'
  and dd07t.domname    = 'TRSTATUS'
  and dd07t.ddlanguage = $session.system_language
