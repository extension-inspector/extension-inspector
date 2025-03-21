sap.ui.define(
  [
    "sap/fe/core/PageController",
    "com/extension-inspector/extension-inspector/model/formatter"
  ],
  function (PageController, formatter) {
    "use strict";

    return PageController.extend("com.extension-inspector.extension-inspector.controller.objects.Detail", {
      formatter: formatter,

      onInit() {
        PageController.prototype.onInit.apply(this)

        this.oRouter = this.getAppComponent().getRouter()
        this.oRouter.getRoute("objectsDetailView").attachMatched(this._onRouteMatched, this)
      },

      onParentPackageLinkPress: function (oEvent) {
        const sParentPackage = this.getView().getBindingContext().getObject().ParentABAPPackage
        this.oRouter.navTo("objectsDetailView", { type: 'DEVC', name: sParentPackage })
      },

      onSuccessorObjectLinkPress: function (oEvent) {
        const sSuccessorType = this.getView().getBindingContext().getObject().SuccessorABAPObjectType
        const sSuccessorObject = this.getView().getBindingContext().getObject().SuccessorABAPObject
        this.oRouter.navTo("objectsDetailView", { type: sSuccessorType, name: sSuccessorObject })
      },

      onPressCurrentlyLockedTag: function (oEvent) {
        const sLockedInTransport = this.getView().getBindingContext().getObject().LockedInTransport
        this.oRouter.navTo("transportsDetailView", { transport: sLockedInTransport })
      },

      onPressAccessedObjectsRow(oEvent) {
        const oObject = oEvent.getParameter("bindingContext").getObject()
        const sType = encodeURIComponent(oObject.TargetObjectType)
        const sName = encodeURIComponent(oObject.TargetObjectName)

        this.getAppComponent().getRouter().navTo("objectsDetailView", { "type": sType, "name": sName })
      },

      onRAPDiagramLayersChange: function (oEvent) {
        this.getView().byId("RAPDiagram").setLayers(oEvent.getParameter("value"))
      },

      onRAPDiagramZoomChange: function (oEvent) {
        this.getView().byId("RAPDiagram").setZoom(oEvent.getParameter("value"))
      },

      onClassDiagramLayersChange: function (oEvent) {
        this.getView().byId("ClassDiagram").setLayers(oEvent.getParameter("value"))
      },

      onClassDiagramZoomChange: function (oEvent) {
        this.getView().byId("ClassDiagram").setZoom(oEvent.getParameter("value"))
      },

      _onRouteMatched: function (oEvent) {
        const oArgs = oEvent.getParameter("arguments")
        const oView = this.getView()
        const sPath = `/Objects(ProgramId='R3TR',ABAPObjectType='${oArgs.type}',ABAPObject='${oArgs.name}')`

        this.ABAPObjectType = oArgs.type
        this.ABAPObject = oArgs.name

        oView.bindElement({
          path: sPath,
          events: {
            change: this._onBindingChange.bind(this),
            dataRequested: function (oEvent) {
              oView.setBusy(true);
            },
            dataReceived: function (oEvent) {
              oView.setBusy(false);
            }
          }
        })
      },

      _onBindingChange: function (oEvent) {
        // No data for the binding
        if (!this.getView().getBindingContext()) {
          this.getRouter().getTargets().display("notFound")
        }
      }
    });
  }
);
