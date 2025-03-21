sap.ui.define(
  [
    "sap/ui/core/mvc/Controller",
    "com/extension-inspector/extension-inspector/model/formatter"
  ],
  function (Controller, formatter) {
    "use strict";

    return Controller.extend("com.extension-inspector.extension-inspector.controller.App", {
      formatter: formatter,
      
      onInit: function () {
        const oSideModel = this.getOwnerComponent().getModel("side")
        const oRouter = this.getOwnerComponent().getRouter()
        const sCurrentHash = oRouter.getHashChanger().getHash()
        const sCurrentRouteName = oRouter.getRouteInfoByHash(sCurrentHash.split("/")[0]).name

        oSideModel.setProperty("/selectedKey", sCurrentRouteName)
      },

      onSideNavItemSelected: function (oEvent) {
        let sKey = oEvent.getSource().getKey()

        this.getOwnerComponent().getRouter().navTo(sKey)
      },

      getText: function (sI18nKey, aPlaceholderValues) {
        const oResourceBundle = this.getOwnerComponent().getModel("i18n").getResourceBundle()

        if (sI18nKey === "-version") {
          return `${oResourceBundle.getText("version")} ${this.getOwnerComponent().getManifestEntry("/sap.app/applicationVersion/version")}`
        }

        return oResourceBundle.getText(sI18nKey, aPlaceholderValues)
      }
    });
  }
);
