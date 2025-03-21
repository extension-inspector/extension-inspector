sap.ui.define([
    "sap/ui/core/Control"
], (Control) => {
    "use strict";

    return Control.extend("com.extension-inspector.extension-inspector.control.SourceCode", {

        metadata: {
            properties: {
                link: { type: "string" }
            }
        },

        init() { },

        setLink: function (sLink) {
            this.setProperty("link", sLink, false)

            if (!sLink) {
                return this
            }

            this.rerender()
            return this
        },

        reset() {
            this.setLink()
        },

        renderer(oRm, oControl) {
            oRm.openStart('div', oControl)
            oRm.openEnd();
            oRm.write(`<iframe id="sourceCodeIFrame" src="${oControl.getLink()}" width="100%" onload="(function(e){var iFrame = document.getElementById('sourceCodeIFrame'); if (iFrame) { iFrame.height = '500px'; iFrame.height = iFrame.contentWindow.document.body.scrollHeight + 'px';} else { console.log('test123') }})(this)" />`);
            oRm.close("div");
        }
    });
});