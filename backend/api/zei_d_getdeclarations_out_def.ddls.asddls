@EndUserText.label: 'Out Parameter for getDeclarationsFor'
define abstract entity ZEI_D_GETDECLARATIONS_OUT_DEF
{
  key DummyKey           : abap.char(1);
  key Guid               : sysuuid_c32;
      SourceObjectType   : trobjtype;
      SourceObjectName   : sobj_name;
      DefinitionType     : abap.char(10);
      AccessModifier     : zei_accessmodifier;
      DefinitionName     : abap.char(64);
      ReferenceVariable1 : abap.char(128);
      ReferenceVariable2 : abap.char(128);
      CreatedAt          : syst_datum;
      CreatedOn          : syst_uzeit;
      _ParameterHeader   : association to parent ZEI_D_GETDECLARATIONS_OUT on $projection.DummyKey = _ParameterHeader.DummyKey;

}
