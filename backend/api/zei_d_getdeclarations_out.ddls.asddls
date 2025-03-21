@EndUserText.label: 'Out Parameter for getDeclarationsFor'
define root abstract entity ZEI_D_GETDECLARATIONS_OUT
{
  key DummyKey     : abap.char(1);
      _Relations   : composition [0..*] of ZEI_D_GETDECLARATIONS_OUT_REL;
      _Definitions : composition [0..*] of ZEI_D_GETDECLARATIONS_OUT_DEF;
}
