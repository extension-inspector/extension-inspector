sap.ui.define(
  [
    "sap/ui/core/mvc/Controller"
  ],
  function (Controller) {
    "use strict";

    return Controller.extend("com.extension-inspector.extension-inspector.controller.App", {
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

      getLogo: function() {
        return sap.ui.require.toUrl('com/extension-inspector/extension-inspector/images/ei-logo-2.png')
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
