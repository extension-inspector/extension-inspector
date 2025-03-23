sap.ui.define(
  ["sap/base/util/ObjectPath", "sap/ushell/Container", "sap/ushell/services/Container"],
  function (ObjectPath, Container) {
    "use strict"

    // define ushell config
    ObjectPath.set(["sap-ushell-config"], {
      defaultRenderer: "fiori2",
      bootstrapPlugins: {
        RuntimeAuthoringPlugin: {
          component: "sap.ushell.plugins.rta",
          config: {
            validateAppVersion: false,
          },
        },
        PersonalizePlugin: {
          component: "sap.ushell.plugins.rta-personalize",
          config: {
            validateAppVersion: false,
          },
        },
      },
      renderers: {
        fiori2: {
          componentData: {
            config: {
              enableSearch: false,
              rootIntent: "Shell-home",
            },
          },
        },
      },
      services: {
        LaunchPage: {
          adapter: {
            config: {
              groups: [
                {
                  tiles: [
                    {
                      tileType: "sap.ushell.ui.tile.StaticTile",
                      properties: {
                        title: "S/4HANA Extension Inspector",
                        targetURL: "#extensioninspector-display",
                      },
                    },
                  ],
                },
              ],
            },
          },
        },
        ClientSideTargetResolution: {
          adapter: {
            config: {
              inbounds: {
                "extensioninspector-display": {
                  semanticObject: "extensioninspector",
                  action: "display",
                  description: "An SAP Fiori application.",
                  title: "S/4HANA Extension Inspector",
                  signature: {
                    parameters: {},
                  },
                  resolutionResult: {
                    applicationType: "SAPUI5",
                    additionalInformation: "SAPUI5.Component=com.extension-inspector.extension-inspector",
                    url: sap.ui.require.toUrl("com/extension-inspector/extension-inspector"),
                  },
                },
              },
            },
          },
        },
        NavTargetResolution: {
          config: {
            enableClientSideTargetResolution: true,
          },
        },
      },
    })

    var oFlpSandbox = {
      init: function () {
        /**
         * Initializes the FLP sandbox
         * @returns {Promise} a promise that is resolved when the sandbox bootstrap has finshed
         */

        // sandbox is a singleton, so we can start it only once
        if (!this._oBootstrapFinished) {
          this._oBootstrapFinished = sap.ushell.bootstrap("local")
          this._oBootstrapFinished.then(function () {
            Container.createRenderer().placeAt("content")
          })
        }

        return this._oBootstrapFinished
      },
    }

    return oFlpSandbox
  },
)
