sap.ui.define([
    "sap/ui/core/Control",
    "com/extension-inspector/extension-inspector/thirdparty/mermaid"
], (Control, mermaidjs) => {
    "use strict";

    return Control.extend("com.extension-inspector.extension-inspector.control.ClassDiagram", {

        sDiagramSyntax: "",

        NEW_LINE: "\n \ ",

        panzoomInstance: undefined,

        metadata: {
            properties: {
                type: { type: "string" },
                object: { type: "string" },
                layers: { type: "string" },
                zoom: { type: "string" }
            }
        },

        init() { },

        setLayers: function (sLayers) {
            this.setProperty("layers", Number(sLayers), false)

            if (!sLayers) {
                return this
            }

            this._getRelevantDeclarations()

            return this
        },

        setZoom: function (sZoom) {
            this.setProperty("zoom", Number(sZoom), true)

            if (!sZoom) {
                return this
            }

            if (!this.panzoomInstance) {
                return this
            }

            this.panzoomInstance.zoom(Number(sZoom), { animate: true })

            return this
        },

        onAfterRendering: function () {
            mermaid.run({
                querySelector: '.mermaid',
                postRenderCallback: (id) => {
                    const container = document.getElementById("diagram-container-class");
                    const svgElement = container.querySelector("svg");

                    // Initialize Panzoom
                    this.panzoomInstance = Panzoom(svgElement, {
                        maxScale: 5,
                        minScale: 0.5,
                        step: 0.1,
                    });

                    // Add mouse wheel zoom
                    /*container.addEventListener("wheel", (event) => {
                        panzoomInstance.zoomWithWheel(event);
                    });*/
                }
            });
        },

        setObject: function (sClass) {
            this.setProperty("object", sClass?.toUpperCase(), false)

            if (!sClass) {
                return this
            }

            this._getRelevantDeclarations()

            return this
        },

        setType: function (sType) {
            this.setProperty("type", sType?.toUpperCase(), false)

            if (!sType) {
                return this
            }

            this._getRelevantDeclarations()

            return this
        },

        reset() {
            this.setObject()
            this.setType()
        },

        renderer(oRm, oControl) {
            oRm.openStart('div', oControl)
            oRm.openEnd();
            oRm.write(`<style>svg { cursor: grab; }</style><div id="diagram-container-class" style="width:100%; height:50vh; overflow:hidden;"><pre class="mermaid" style="height: 100% !important;">${oControl.sDiagramSyntax}</pre></div>`);
            oRm.close("div");
        },

        async _getRelevantDeclarations() {
            const oModel = this.getModel()

            if (!this.getType() || !this.getObject()) {
                return
            }

            const oAction = oModel.bindContext("/Actions/com.sap.gateway.srvd.zei_ui.v0001.getDeclarations(...)")
            oAction.setParameter("ObjectType", this.getType())
            oAction.setParameter("ObjectName", this.getObject())
            oAction.setParameter("Levels", this.getLayers())

            await oAction.execute()

            this._generateDiagramSyntax(oAction.getBoundContext().getObject())
        },

        _generateDiagramSyntax(oDeclarations) {
            const sClass = this.getObject()

            let sDiagramSyntax = `classDiagram ${this.NEW_LINE}`

            const aDefinitions = oDeclarations._Definitions
            let aRelations = oDeclarations._Relations

            aRelations = aRelations.filter(oRelation => oRelation.Relation !== 'LNK_DASHED')

            for (const oRelation of aRelations) {
                sDiagramSyntax += this._getRelationSyntax(oRelation)
            }

            /*const aUniqueObjects = aDefinitions.reduce((acc, obj) => {
                if (!acc.some(item => item.SourceObjectType === obj.SourceObjectType || item.SourceObjectName === obj.SourceObjectName)) {
                    acc.push({ SourceObjectType: obj.SourceObjectType, SourceObjectName: obj.SourceObjectName });
                }
                return acc;
            }, [])*/

            const aUniqueObjectsSet = new Set();

            // Collect the Source and Target pairs in a Set (to ensure uniqueness)
            aRelations.forEach(item => {
                aUniqueObjectsSet.add(`${item.SourceObjectType}|${item.SourceObjectName}`);
                aUniqueObjectsSet.add(`${item.TargetObjectType}|${item.TargetObjectName}`);
            });

            // Convert the Set back to an array of objects
            const aUniqueObjects = Array.from(aUniqueObjectsSet).map(pairString => {
                const [objectType, objectName] = pairString.split('|');
                return { SourceObjectType: objectType, SourceObjectName: objectName };
            });

            for (const oUniqueObject of aUniqueObjects) {
                sDiagramSyntax += this._getDefinitionSyntax(oUniqueObject, aDefinitions)
            }

            if (aUniqueObjects.length === 0) {
                sDiagramSyntax += this._getDefinitionSyntax({ SourceObjectType: this.getType(), SourceObjectName: this.getObject() }, aDefinitions)
            }

            // Lowlight non-main objects
            sDiagramSyntax += `classDef lowlight fill:#eeeeee,stroke:#868686${this.NEW_LINE}`

            sDiagramSyntax = sDiagramSyntax.replaceAll("/", "-")

            this.sDiagramSyntax = sDiagramSyntax

            this.rerender()
        },

        _getDefinitionSyntax(oUniqueObject, aDefinitions) {

            const aRelevantDefinitions = aDefinitions.filter(oDefinition => oDefinition.SourceObjectType === oUniqueObject.SourceObjectType && oDefinition.SourceObjectName === oUniqueObject.SourceObjectName)

            let sObjectSuffix = ""
            if (oUniqueObject.SourceObjectName !== this.getObject()) {
                sObjectSuffix = ":::lowlight"
            }

            let sClassSyntax = `class ${oUniqueObject.SourceObjectName}${sObjectSuffix}`

            let sClassContent = ``

            for (const oDefinition of aRelevantDefinitions) {
                let sLine = ``
                sLine += oDefinition.AccessModifier
                sLine += oDefinition.DefinitionName

                if (oDefinition.DefinitionType === "METHOD") {
                    sLine += `(`
                    if (oDefinition.ReferenceVariable1) sLine += oDefinition.ReferenceVariable1
                    sLine += `)`
                    if (oDefinition.ReferenceVariable2) sLine += ` ${oDefinition.ReferenceVariable2}`
                }
                if (oDefinition.DefinitionType === "DATA") sLine += `: ${oDefinition.ReferenceVariable1}`

                sClassContent += sLine + this.NEW_LINE
            }

            if (sClassContent) {
                sClassSyntax += ` {${this.NEW_LINE}${sClassContent}}`
            }

            sClassSyntax += this.NEW_LINE

            return sClassSyntax
        },

        _getRelationSyntax(oRelation) {
            let sConnector = ``

            switch (oRelation.Relation) {
                case 'INHER':
                    sConnector = `<|--`
                    break
                case 'COMP':
                    sConnector = `*--`
                    break
                case 'AGGR':
                    sConnector = `o--`
                    break
                case 'ASSOC':
                    sConnector = `-->`
                    break
                case 'LNK_SOLID':
                    sConnector = `--`
                    break
                case 'LNK_DASHED':
                    sConnector = `..`
                    break
                case 'DPNDNCY':
                    sConnector = `..>`
                    break
                case 'RLZTN':
                    sConnector = `..|>`
                    break

                default:
                    return ``
            }

            return `${oRelation.TargetObjectName} ${sConnector} ${oRelation.SourceObjectName} ${this.NEW_LINE}`
        },

        _getObjectSyntax(aDeclarations, sObject) {
            const aRelevantComponents = ["DATA", "CLASS-DATA", "CONSTANTS", "METHODS", "CLASS-METHODS", "EVENTS", "CLASS-EVENTS"]
            const aFilteredDeclarations = aDeclarations.filter(oDeclaration => oDeclaration.ObjectName === sObject
                && aRelevantComponents.includes(oDeclaration.DefinitionType))

            let sObjectSuffix = ""
            if (sObject !== this.getObject()) {
                sObjectSuffix = ":::lowlight"
            }

            let sClassSyntax = `class ${sObject}${sObjectSuffix}`

            let sClassContent = ``
            for (const oDeclaration of aFilteredDeclarations) {
                let sLine = ``

                if (oDeclaration.AccessModifier === 'PUBLIC') sLine += `+`
                if (oDeclaration.AccessModifier === 'PROTECTED') sLine += `#`
                if (oDeclaration.AccessModifier === 'PRIVATE') sLine += `-`

                sLine += oDeclaration.Name

                if (oDeclaration.DefinitionType === "METHODS" || oDeclaration.DefinitionType === "CLASS-METHODS") sLine += `()`
                if ((oDeclaration.DefinitionType === "DATA" || oDeclaration.DefinitionType === "CLASS-DATA") && oDeclaration.DefinitionName) sLine += `: ${oDeclaration.Name2}`

                sClassContent += sLine + this.NEW_LINE
            }

            if (sClassContent) {
                sClassSyntax += ` {${this.NEW_LINE}${sClassContent}}`
            }

            sClassSyntax += this.NEW_LINE

            return sClassSyntax
        },

        _getLinkSyntax(aDeclarations) {
            //sDiagramSyntax += 'click ' + sClass + ' href "#/object/clas/' + sClass + '"'
            return ""
        },

        _getConnectionSyntax(aDeclarations) {
            const aRelevantComponents = ["DATA", "CLASS-DATA", "OPTIONS", "INTERFACES"]
            const aFilteredDeclarations = aDeclarations.filter(oDeclaration => aRelevantComponents.includes(oDeclaration.DefinitionType))

            let sClassConnectionSyntax = ``

            for (const oDeclaration of aFilteredDeclarations) {
                let sConnector = ""
                let sConnectionTo = ""

                // Add Inheritance
                if (oDeclaration.DefinitionName === "INHERITING_FROM") {
                    sConnector = `<|--`
                    sConnectionTo = oDeclaration.Name
                }

                // Add Realization
                if (oDeclaration.DefinitionType === "INTERFACES") {
                    sConnector = `<..`
                    sConnectionTo = oDeclaration.Name
                }

                // Add Aggregation
                // Add Association
                // Add Composition
                if ((oDeclaration.DefinitionType === "DATA" || oDeclaration.DefinitionType === "CLASS-DATA")
                    && oDeclaration.DefinitionName === 'REF_TO'
                    && oDeclaration.Name2) {
                    sConnector = `*--`
                    sConnectionTo = oDeclaration.Name2
                }

                // Add Dependencys

                if (sConnector && sConnectionTo) {
                    sClassConnectionSyntax += `${sConnectionTo} ${sConnector} ${oDeclaration.ObjectName} ${this.NEW_LINE}`
                }
            }
            return sClassConnectionSyntax
        }
    });
});