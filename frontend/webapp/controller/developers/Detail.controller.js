sap.ui.define(["sap/fe/core/PageController", "com/extension-inspector/extension-inspector/model/formatter"], function (PageController, formatter) {
  "use strict"

  return PageController.extend("com.extension-inspector.extension-inspector.controller.developers.Detail", {
    formatter: formatter,
    
    onInit: function () {
      PageController.prototype.onInit.apply(this)

      this.oRouter = this.getAppComponent().getRouter()
      this.oRouter.getRoute("developersDetailView").attachMatched(this._onRouteMatched, this)
    },

    onRowPressTransportTable: function(oEvent) {
      const sContext = oEvent.getParameter("bindingContext")
      const sTransport = encodeURIComponent(sContext.getProperty("RequestTask"))

      this.getAppComponent().getRouter().navTo("transportsDetailView", { transport: sTransport })
    },

    _onRouteMatched: function (oEvent) {
      const oSideModel = this.getOwnerComponent().getModel("side")
      oSideModel.setProperty("/selectedKey", "developersListView")

      const oArgs = oEvent.getParameter("arguments")
      const oView = this.getView()
      const sPath = `/Developers(Developer='${oArgs.name}')`

      oView.bindElement({
        path: sPath,
        events: {
          dataRequested: function (oEvent) {
            oView.setBusy(true)
          },
          dataReceived: function (oEvent) {
            oView.setBusy(false)

            if (!oView.getBindingContext().getObject()) {
              this.oRouter.getTargets().display("developerNotFoundView")
            }
          }.bind(this),
        },
      })
    },
  })
})
