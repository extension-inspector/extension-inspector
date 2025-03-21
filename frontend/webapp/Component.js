/**
 * eslint-disable @sap/ui5-jsdocs/no-jsdoc
 */

sap.ui.define([
    "sap/fe/core/AppComponent"
],
    function (AppComponent) {
        "use strict";

        return AppComponent.extend("com.extension-inspector.extension-inspector.Component", {
            metadata: {
                manifest: "json"
            }
        });
    }
);