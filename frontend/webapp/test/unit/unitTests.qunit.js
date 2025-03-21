/* global QUnit */
QUnit.config.autostart = false;

sap.ui.getCore().attachInit(function () {
	"use strict";

	sap.ui.require([
		"comextension-inspector/extension-inspector/test/unit/AllTests"
	], function () {
		QUnit.start();
	});
});
