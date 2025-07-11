sap.ui.define(
  [
    "sap/fe/core/PageController",
    "sap/m/Link",
    "sap/ui/model/Filter",
    "sap/ui/model/FilterOperator",
    "com/extension-inspector/extension-inspector/model/formatter",
  ],
  function (PageController, Link, Filter, FilterOperator, formatter) {
    "use strict"

    return PageController.extend("sap.fe.core.fpmExplorer.guidanceCustomApps.DetailPage", {
      formatter: formatter,
      aFilterBarFilters: [],

      onInit() {
        PageController.prototype.onInit.apply(this)

        this.oRouter = this.getAppComponent().getRouter()
        this.oRouter.getRoute("objectsListView").attachMatched(this._onRouteMatched, this)
      },

      onAfterRendering() {
        const oFilterBar = this.getView().byId("ObjectsListFilterBar")
        oFilterBar.triggerSearch()

        this._setBreadcrumpFilter("")
      },

      onRowPress(oEvent) {
        const oObject = oEvent.getParameter("bindingContext").getObject()
        const sProgram = encodeURIComponent(oObject.ProgramId)
        const sType = encodeURIComponent(oObject.ABAPObjectType)
        const sName = encodeURIComponent(oObject.ABAPObject)

        this.getAppComponent().getRouter().navTo("objectsDetailView", { program: sProgram, type: sType, name: sName })
      },

      onPressParentPackage(oEvent) {
        const oObject = oEvent.getSource().getBindingContext().getObject()
        const sName = encodeURIComponent(oObject.ParentABAPPackage)

        this.getAppComponent().getRouter().navTo("objectsDetailView", { program: "R3TR", type: "DEVC", name: sName })
      },

      onPressCreatedBy(oEvent) {
        const oObject = oEvent.getSource().getBindingContext().getObject()
        const sName = encodeURIComponent(oObject.PersonResponsible)

        this.getAppComponent().getRouter().navTo("developersDetailView", { name: sName })
      },

      onSelectionChangeBreadcrumpRow(oEvent) {
        const listItem = oEvent.getParameter("listItem")
        const oObject = listItem.getBindingContext().getObject()

        if (oObject.ABAPObjectType !== "DEVC") {
          const sProgram = encodeURIComponent(oObject.ProgramId)
          const sType = encodeURIComponent(oObject.ABAPObjectType)
          const sName = encodeURIComponent(oObject.ABAPObject)

          this.getAppComponent().getRouter().navTo("objectsDetailView", { program: sProgram, type: sType, name: sName })
          return
        }

        this._addBreadcrump(oObject.ABAPObject)
        this._setBreadcrumpFilter(oObject.ABAPObject)
      },

      onPressBreadcrump(oEvent) {
        let sSelectedBreadcrump = oEvent.getSource().getText()
        const oResourceBundle = this.getModel("i18n").getResourceBundle()
        const sRootBreadcrump = oResourceBundle.getText("objects.breadcrumplist.root")

        this._resetBreadcrumpTo(sSelectedBreadcrump)

        if (sSelectedBreadcrump === sRootBreadcrump) {
          sSelectedBreadcrump = ""
        }
        this._setBreadcrumpFilter(sSelectedBreadcrump)
      },

      onSearch(oEvent) {
        const aFilters = oEvent.getParameter("filters")
        this.aFilterBarFilters = aFilters

        this._handleBreadcrumpFilter()
      },

      _setBreadcrumpFilter(sNewFilter) {
        const oTable = this.getView().byId("breadcrumpObjectViewTable")
        const oBinding = oTable.getBinding("items")

        let aFilters = this.aFilterBarFilters.slice()
        aFilters.push(new Filter("ParentABAPPackage", FilterOperator.EQ, sNewFilter))

        oBinding.filter([
          new Filter({
            filters: aFilters,
            and: true,
          }),
        ])
        oTable.removeSelections()
      },

      _handleBreadcrumpFilter() {
        const oTable = this.getView().byId("breadcrumpObjectViewTable")
        const oBinding = oTable.getBinding("items")
        const oBreadcrump = this.getView().byId("objectBreadcrumps")
        let sCurrentLocation = oBreadcrump.getCurrentLocationText()
        const oResourceBundle = this.getModel("i18n").getResourceBundle()
        const sRootBreadcrump = oResourceBundle.getText("objects.breadcrumplist.root")

        if (sCurrentLocation === sRootBreadcrump) {
          sCurrentLocation = ""
        }

        let aFilters = this.aFilterBarFilters.slice()
        aFilters.push(new Filter("ParentABAPPackage", FilterOperator.EQ, sCurrentLocation))

        oBinding.filter([
          new Filter({
            filters: aFilters,
            and: true,
          }),
        ])
        oTable.removeSelections()
      },

      _addBreadcrump(sName) {
        const oBreadcrump = this.getView().byId("objectBreadcrumps")
        const sLastLocation = oBreadcrump.getCurrentLocationText()

        oBreadcrump.setCurrentLocationText(sName)

        if (!sLastLocation) return

        var oLink = new Link({
          text: sLastLocation,
          press: this.onPressBreadcrump.bind(this),
        })
        oBreadcrump.addLink(oLink)
      },

      _resetBreadcrumpTo(sName) {
        const oBreadcrump = this.getView().byId("objectBreadcrumps")
        let aLinks = oBreadcrump.getLinks()
        const iIndexOfBreadcrump = aLinks.map((oLink) => oLink.getText()).indexOf(sName)

        aLinks.length = iIndexOfBreadcrump
        oBreadcrump.removeAllLinks()
        for (const oLink of aLinks) {
          oBreadcrump.addLink(oLink)
        }

        oBreadcrump.setCurrentLocationText(sName)
      },

      _onRouteMatched: function (oEvent) {
        const oSideModel = this.getOwnerComponent().getModel("side")
        oSideModel.setProperty("/selectedKey", "objectsListView")
      },
    })
  },
)
