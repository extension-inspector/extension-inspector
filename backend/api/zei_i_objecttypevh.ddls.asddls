@EndUserText.label: 'Custom Entity for Object Type VH'
@ObjectModel.query.implementedBy : 'ABAP:ZEI_CL_QP_OBJECTTYPEVH'
define custom entity ZEI_I_OBJECTTYPEVH
{
      @ObjectModel.text.element: [ 'ObjectTypeText' ]
  key ObjectType     : trobjtype;

      @Semantics.text: true
      ObjectTypeText : shvalue_d;
}
