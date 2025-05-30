sap.ui.define(
  ["sap/ui/core/mvc/Controller", "com/extension-inspector/extension-inspector/model/formatter"],
  function (Controller, formatter) {
    "use strict"

    return Controller.extend("com.extension-inspector.extension-inspector.controller.App", {
      formatter: formatter,

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
      },
    })
  },
)
