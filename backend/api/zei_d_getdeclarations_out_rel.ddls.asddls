@EndUserText.label: 'Out of GetDeclarations Relation Entity'
define abstract entity ZEI_D_GETDECLARATIONS_OUT_REL
{
  key DummyKey         : abap.char(1);
  key Guid             : sysuuid_c32;
      SourceObjectType : trobjtype;
      SourceObjectName : sobj_name;
      TargetObjectType : trobjtype;
      TargetObjectName : sobj_name;
      Relation         : zei_relation;
      CreatedAt        : syst_datum;
      CreatedOn        : syst_uzeit;
      _ParameterHeader : association to parent ZEI_D_GETDECLARATIONS_OUT on $projection.DummyKey = _ParameterHeader.DummyKey;
}
