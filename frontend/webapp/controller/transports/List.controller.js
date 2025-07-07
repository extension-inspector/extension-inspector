sap.ui.define(
  ["sap/fe/core/PageController", "com/extension-inspector/extension-inspector/model/formatter"],
  function (PageController, formatter) {
    "use strict"

    return PageController.extend("com.extension-inspector.extension-inspector.controller.transports.List", {
      formatter: formatter,

      onInit: function () {
        PageController.prototype.onInit.apply(this)

        this.oRouter = this.getAppComponent().getRouter()
        this.oRouter.getRoute("transportsListView").attachMatched(this._onRouteMatched, this)
      },

      onAfterRendering() {
        const oFilterBar = this.getView().byId("FilterBar")
        oFilterBar.triggerSearch()
      },

      onRowPress(oEvent) {
        const oObject = oEvent.getParameter("bindingContext").getObject()
        const sTransport = encodeURIComponent(oObject.RequestTask)

        this.getAppComponent().getRouter().navTo("transportsDetailView", { transport: sTransport })
      },

      onPressOwner(oEvent) {
        const oObject = oEvent.getSource().getBindingContext().getObject()
        const sName = encodeURIComponent(oObject.Owner)

        this.getAppComponent().getRouter().navTo("developersDetailView", { name: sName })
      },

      _onRouteMatched: function (oEvent) {
        const oSideModel = this.getOwnerComponent().getModel("side")
        oSideModel.setProperty("/selectedKey", "transportsListView")
      },
    })
  },
)
