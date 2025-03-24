sap.ui.define(
  [
    "sap/fe/core/PageController",
    "com/extension-inspector/extension-inspector/model/formatter",
    "sap/ui/model/json/JSONModel",
    "sap/m/Label",
    "sap/ui/model/Filter",
    "sap/ui/model/FilterOperator",
    "sap/ui/comp/smartvariants/PersonalizableInfo",
  ],
  function (PageController, formatter, JSONModel, Label, Filter, FilterOperator, PersonalizableInfo) {
    "use strict"

    return PageController.extend("com.extension-inspector.extension-inspector.controller.developers.List", {
      formatter: formatter,
      
      onInit: function () {
        PageController.prototype.onInit.apply(this)

        this.oRouter = this.getAppComponent().getRouter()
        this.oRouter.getRoute("developersListView").attachMatched(this._onRouteMatched, this)
      },

      onAfterRendering() {
        const oFilterBar = this.getView().byId("FilterBar")
        oFilterBar.triggerSearch()
      },

      onObjectsTableRowSelectionChange: function (oEvent) {
        const oPressedObject = oEvent.getParameter("rowContext").getObject()
        this.getRouter().navTo("objectsDetailView", {
          program: encodeURIComponent(oPressedObject.ProgramId),
          type: encodeURIComponent(oPressedObject.ABAPObjectType),
          name: encodeURIComponent(oPressedObject.ABAPObject),
        })
      },

      onRowPress(oEvent) {
        const oObject = oEvent.getParameter("bindingContext").getObject()
        const sName = encodeURIComponent(oObject.Developer)

        this.getAppComponent().getRouter().navTo("developersDetailView", { name: sName })
      },

      _onRouteMatched: function (oEvent) {
        const oSideModel = this.getOwnerComponent().getModel("side")
        oSideModel.setProperty("/selectedKey", "developersListView")
      }
    })
  },
)
