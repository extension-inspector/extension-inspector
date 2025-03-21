sap.ui.define([
	'sap/m/library'
], function (sapMLib) {
	"use strict";

	return {
		getI18nText: function (sKey) {
			const oRB = this.getView().getModel("i18n").getResourceBundle()
			return oRB.getText(sKey)
		},

		getTextForReleaseContract: function (sContract) {
			const oRB = this.getView().getModel("i18n").getResourceBundle()
			return `${oRB.getText(sContract)} (${sContract})`
		},

		formatIdAndDescription: function (sId, sDescription) {
			if (!sDescription) {
				return sId
			}
			return `${sDescription} (${sId})`
		},

		openURLForContract: function (sContract) {
			let sLink = ""
			switch (sContract) {
				case 'C0':
					sLink = 'https://help.sap.com/docs/abap-cloud/abap-development-tools-user-guide/extend-c0?locale=en-US'
					break
				case 'C1':
					sLink = 'https://help.sap.com/docs/abap-cloud/abap-development-tools-user-guide/use-system-internally-c1?locale=en-US'
					break
				case 'C2':
					sLink = 'https://help.sap.com/docs/abap-cloud/abap-development-tools-user-guide/use-as-remote-api-c2?locale=en-US'
					break
				case 'C3':
					sLink = 'https://help.sap.com/docs/abap-cloud/abap-development-tools-user-guide/manage-configuration-content-c3?locale=en-US'
					break
				case 'C4':
					sLink = 'https://help.sap.com/docs/abap-cloud/abap-development-tools-user-guide/use-in-abap-managed-database-procedures-c4?locale=en-US'
					break
			}
			sapMLib.URLHelper.redirect(sLink, true)
		}
	};
});