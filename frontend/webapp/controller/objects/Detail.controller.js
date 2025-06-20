sap.ui.define(
  ["sap/fe/core/PageController", "com/extension-inspector/extension-inspector/model/formatter"],
  function (PageController, formatter) {
    "use strict"

    return PageController.extend("com.extension-inspector.extension-inspector.controller.objects.Detail", {
      formatter: formatter,

      onInit() {
        PageController.prototype.onInit.apply(this)

        this.oRouter = this.getAppComponent().getRouter()
        this.oRouter.getRoute("objectsDetailView").attachMatched(this._onRouteMatched, this)
      },

      onParentPackageLinkPress: function (oEvent) {
        const sParentPackage = this.getView().getBindingContext().getObject().ParentABAPPackage
        this.oRouter.navTo("objectsDetailView", {
          program: "R3TR",
          type: "DEVC",
          name: sParentPackage,
        })
      },

      onPressCreatedBy(oEvent) {
        const oObject = oEvent.getSource().getBindingContext().getObject()
        const sName = encodeURIComponent(oObject.PersonResponsible)

        this.getAppComponent().getRouter().navTo("developersDetailView", { name: sName })
      },

      onSuccessorObjectLinkPress: function (oEvent) {
        const sSuccessorType = this.getView().getBindingContext().getObject().SuccessorABAPObjectType
        const sSuccessorObject = this.getView().getBindingContext().getObject().SuccessorABAPObject
        this.oRouter.navTo("objectsDetailView", {
          program: "R3TR",
          type: sSuccessorType,
          name: sSuccessorObject,
        })
      },

      onPressPersonResponsible(oEvent) {
        const oObject = oEvent.getSource().getBindingContext().getObject()
        const sName = encodeURIComponent(oObject.PersonResponsible)

        this.getAppComponent().getRouter().navTo("developersDetailView", { name: sName })
      },

      onPressCurrentlyLockedTag: function (oEvent) {
        const sLockedInTransport = this.getView().getBindingContext().getObject().LockedInTransport
        this.oRouter.navTo("transportsDetailView", {
          transport: sLockedInTransport,
        })
      },

      onPressAccessedObjectsRow(oEvent) {
        const oObject = oEvent.getParameter("bindingContext").getObject()
        const sType = encodeURIComponent(oObject.TargetObjectType)
        const sName = encodeURIComponent(oObject.TargetObjectName)

        this.getAppComponent().getRouter().navTo("objectsDetailView", { program: "R3TR", type: sType, name: sName })
      },

      onPressTransportTimelineItem(oEvent) {
        const oObject = oEvent.getSource().getBindingContext().getObject()
        const sRequest = encodeURIComponent(oObject?.VersionRequestNumber)

        this.getAppComponent().getRouter().navTo("transportsDetailView", { transport: sRequest })
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
        const oSideModel = this.getOwnerComponent().getModel("side")
        oSideModel.setProperty("/selectedKey", "objectsListView")

        const oArgs = oEvent.getParameter("arguments")
        const oView = this.getView()
        const sPath = `/Objects(ProgramId='${oArgs.program}',ABAPObjectType='${oArgs.type}',ABAPObject='${oArgs.name}')`

        this.ABAPObjectType = oArgs.type
        this.ABAPObject = oArgs.name

        oView.bindElement({
          path: sPath,
          events: {
            dataRequested: function (oEvent) {
              oView.setBusy(true)
            },
            dataReceived: function (oEvent) {
              oView.setBusy(false)

              if (!oView.getBindingContext().getObject()) {
                this.oRouter.getTargets().display("objectNotFoundView")
              }
            }.bind(this),
          },
        })
      },
    })
  },
)
