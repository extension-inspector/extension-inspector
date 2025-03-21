sap.ui.define([
    "sap/fe/core/PageController",
    "sap/ui/core/Fragment",
    "sap/ui/model/json/JSONModel",
    "com/extension-inspector/extension-inspector/model/customFunctions"
], function (PageController, Fragment, JSONModel, customFunctions) {
    "use strict";

    return PageController.extend("com.extension-inspector.extension-inspector.controller.Cockpit", {
        customFunctions: customFunctions,

        onInit: function () {
            PageController.prototype.onInit.apply(this)
        },

        createGroupHeader(oGroup) {
            return new sap.m.GroupHeaderListItem({
                "title": this.getText(oGroup.key)
            })
        },

        getText: function (sI18nKey, aPlaceholderValues) {
            const oResourceBundle = this.getOwnerComponent().getModel("i18n").getResourceBundle()
            return oResourceBundle.getText(sI18nKey, aPlaceholderValues)
        },

        async onGridListItemBeforeRendering(oEvent) {
            const oGrid = oEvent.getSource()
            let aItems = oGrid.getItems().filter(oItem => !oItem.isGroupHeader())

            aItems.forEach(async oItem => {
                const oObject = oItem.getBindingContext("cockpitDashboard").getObject()
                const oFragment = await Fragment.load({ id: oObject.fragment, name: oObject.fragment, controller: this }).then(eval(oObject.callback))
                oItem.addContent(oFragment)
            })
        }
    });
});
