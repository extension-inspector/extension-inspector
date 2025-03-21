sap.ui.define(
  [
    "sap/fe/core/PageController"
  ],
  function (PageController) {
    "use strict";

    return PageController.extend("com.extension-inspector.extension-inspector.controller.developers.Detail", {
      onInit: function () {
        PageController.prototype.onInit.apply(this)

        this.oRouter = this.getAppComponent().getRouter()
        this.oRouter.getRoute("developersDetailView").attachMatched(this._onRouteMatched, this)
      },

      _onRouteMatched: function (oEvent) {
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
            }.bind(this)
          }
        })
      }
    });
  }
);
