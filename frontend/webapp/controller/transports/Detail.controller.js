sap.ui.define(
  [
    "sap/fe/core/PageController",
    "com/extension-inspector/extension-inspector/model/formatter"
  ],
  function (PageController, formatter) {
    "use strict";

    return PageController.extend("com.extension-inspector.extension-inspector.controller.transports.Detail", {
      formatter: formatter,

      onInit: function () {
        PageController.prototype.onInit.apply(this)

        this.oRouter = this.getAppComponent().getRouter()
        this.oRouter.getRoute("transportsDetailView").attachMatched(this._onRouteMatched, this)
      },

      onTaskRowPress(oEvent) {
        const oObject = oEvent.getParameter("bindingContext").getObject()
        const sTransport = encodeURIComponent(oObject.RequestTask)

        this.getAppComponent().getRouter().navTo("transportsDetailView", { "transport": sTransport })
      },

      onEntryRowPress(oEvent) {
        const oObject = oEvent.getParameter("bindingContext").getObject()
        const sType = encodeURIComponent(oObject.ABAPObjectType)
        const sName = encodeURIComponent(oObject.ABAPObject)

        this.getAppComponent().getRouter().navTo("objectsDetailView", { "type": sType, "name": sName })
      },

      onPressParentRequest(oEvent) {
        const sParentRequest = this.getView().getBindingContext().getObject().ParentRequest
        this.oRouter.navTo("transportsDetailView", { "transport": sParentRequest })
      },

      _onRouteMatched: function (oEvent) {
        const oArgs = oEvent.getParameter("arguments")
        const oView = this.getView()
        const sPath = `/Transports(RequestTask='${oArgs.transport}')`

        oView.bindElement({
          path: sPath,
          parameters: {
            $expand: "_Tasks"
          },
          events: {
            dataRequested: function (oEvent) {
              oView.setBusy(true)
            },
            dataReceived: function (oEvent) {
              oView.setBusy(false)

              if (!oView.getBindingContext().getObject()) {
                this.oRouter.getTargets().display("transportNotFoundView")
              }
            }.bind(this)
          }
        })
      }
    });
  }
);
