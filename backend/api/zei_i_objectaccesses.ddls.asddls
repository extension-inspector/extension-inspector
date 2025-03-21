@EndUserText.label: 'Custom Entity for Object Type VH'
@ObjectModel.query.implementedBy : 'ABAP:ZEI_CL_QP_OBJECTACCESSES'

@Search.searchable: true
@UI.headerInfo: {
    typeName: 'Object',
    typeNamePlural: 'Objects'
}

define custom entity ZEI_I_ObjectAccesses
{
      @UI.lineItem:[{ position: 10 }]
      @Search.defaultSearchElement: true
      @ObjectModel.text.element: [ 'TypeName' ]
      @UI.textArrangement: #TEXT_LAST
  key Type       : seu_obj;
  key encl_obj   : sobj_name;
      @UI.lineItem:[{ position: 20 }]
      @Search.defaultSearchElement: true
  key Object     : seu_objkey;
  key Counter    : xline;
      @UI.lineItem:[{ position: 30 }]
      ObjectText : char80;
      TypeName   : shvalue_d;
      devclass   : devclass;
      call_obj   : sobj_name;
      call_type  : seu_obj;
      call_devcl : devclass;
      pgmid      : trobjtype;
      encl_num   : xline;
      int_type   : char1;
      done       : char1;
      tadir      : char1;
      forgn_app  : char1;
      genflag    : genflag;
      no_cust    : tpclass;
      appl       : uffunction;
}
