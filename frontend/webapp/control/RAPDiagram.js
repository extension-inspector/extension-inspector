sap.ui.define(
  [
    "sap/ui/core/Control",
    "com/extension-inspector/extension-inspector/thirdparty/mermaid",
    "com/extension-inspector/extension-inspector/thirdparty/panzoom",
  ],
  (Control, mermaidjs, panzoom) => {
    "use strict"

    return Control.extend("com.extension-inspector.extension-inspector.control.RAPDiagram", {
      sDiagramSyntax: "",

      NEW_LINE: "\n \ ",

      panzoomInstance: undefined,

      metadata: {
        properties: {
          type: { type: "string" },
          object: { type: "string" },
          layers: { type: "string" },
          zoom: { type: "string" },
        },
      },

      init() {},

      onAfterRendering: function () {
        if (this.sDiagramSyntax) {
          mermaid.initialize({})
          mermaid.run({
            querySelector: ".mermaid",
            postRenderCallback: (id) => {
              const container = document.getElementById("diagram-container")
              const svgElement = container.querySelector("svg")

              // Initialize Panzoom
              this.panzoomInstance = Panzoom(svgElement, {
                maxScale: 5,
                minScale: 0.5,
                step: 0.1,
              })
            },
          })
        }
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

      setLayers: function (sLayers) {
        this.setProperty("layers", Number(sLayers), false)

        if (!sLayers) {
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
        oRm.openStart("div", oControl)
        oRm.openEnd()
        if (oControl.sDiagramSyntax) {
          oRm.write(
            `<style>svg { cursor: grab; }</style><div id="diagram-container" style="width:100%; max-height:50vh; overflow:hidden;"><pre class="mermaid" style="height: 100% !important;">${oControl.sDiagramSyntax}</pre></div>`,
          )
        } else {
          oRm.write("No diagram available.")
        }
        oRm.close("div")
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
        const sObjectType = this.getType()
        const sObjectName = this.getObject()

        let sDiagramSyntax = `\%\%{init: { "flowchart": { "curve": "stepBefore" } } }\%\%${this.NEW_LINE}graph LR ${this.NEW_LINE}`

        const aDefinitions = oDeclarations._Definitions
        let aRelations = oDeclarations._Relations

        if (aRelations.length === 0) {
          this.sDiagramSyntax = ""
          return
        }

        // Make sure connections with a non-z object between it, are ignored
        aRelations = aRelations.filter((oRelation) =>
          this._isConnectedOnlyZUndirected(
            aRelations,
            oRelation.SourceObjectType,
            oRelation.SourceObjectName, // Start
            sObjectType,
            sObjectName, // Target
          ),
        )

        const aUniqueObjectsSet = new Set()
        aRelations.forEach((item) => {
          /*if (!(item.Relation.startsWith("DDLS") || item.Relation.startsWith("BDEF"))) {
            return
          }*/
          if (item.Relation.startsWith("ACCESSING")) {
            return
          }

          aUniqueObjectsSet.add(`${item.SourceObjectType}|${item.SourceObjectName}`)
          aUniqueObjectsSet.add(`${item.TargetObjectType}|${item.TargetObjectName}`)
        })
        const aUniqueObjects = Array.from(aUniqueObjectsSet).map((pairString) => {
          const [objectType, objectName] = pairString.split("|")
          return {
            SourceObjectType: objectType,
            SourceObjectName: objectName,
          }
        })

        aUniqueObjects.forEach((oUniqueObject) => {
          const sDefinitionName = aDefinitions.find(
            (oDefinition) =>
              oDefinition.SourceObjectType === oUniqueObject.SourceObjectType &&
              oDefinition.SourceObjectName === oUniqueObject.SourceObjectName,
          )?.DefinitionName

          let sObjectType = ""
          let sObjectColor = ""
          if (oUniqueObject.SourceObjectType === "DDLS") {
            sObjectColor = "#B2DFDB"
            switch (sDefinitionName) {
              case "V":
                sObjectType = "DDIC-based view"
                break
              case "E":
                sObjectType = "Extend"
                break
              case "F":
                sObjectType = "Table Function"
                break
              case "T":
                sObjectType = "Table Entity"
                break
              case "A":
                sObjectType = "Abstract Entity"
                break
              case "H":
                sObjectType = "Hierarchy"
                break
              case "Q":
                sObjectType = "Custom Entity"
                break
              case "P":
                sObjectType = "Projection View"
                sObjectColor = "#4DB6AC"
                break
              case "X":
                sObjectType = "Extend"
                break
              case "W":
                sObjectType = "View Entity"
                break
              default:
                sObjectType = "Data Definition"
            }
          } else if (oUniqueObject.SourceObjectType === "TABL") {
            sObjectType = "Table"
            sObjectColor = "#A1887F"
          } else if (oUniqueObject.SourceObjectType === "SRVD") {
            sObjectType = "Service Definition"
            sObjectColor = "#81C784"
          } else if (oUniqueObject.SourceObjectType === "SRVB") {
            sObjectType = "Service Binding"
            sObjectColor = "#BA68C8"
          } else if (oUniqueObject.SourceObjectType === "CLAS") {
            sObjectType = "ABAP Class"
            sObjectColor = "#DCE775"
          } else if (oUniqueObject.SourceObjectType === "DCLS") {
            sObjectType = "Access Control"
            sObjectColor = "#FFE082"
          } else if (oUniqueObject.SourceObjectType === "BDEF") {
            sObjectType = "Behavior Definition"
            sObjectColor = "#9575CD"
          } else if (oUniqueObject.SourceObjectType === "WAPA") {
            sObjectType = "Fiori App"
            sObjectColor = "#4FC3F7"
          } else if (oUniqueObject.SourceObjectType === "DDLX") {
            sObjectType = "Metadata Extension"
            sObjectColor = "#FFD54F"
          }

          let sLink =
            window.location.hash.split("&")[0] +
            "&/objects/R3TR/" +
            oUniqueObject.SourceObjectType +
            "/" +
            oUniqueObject.SourceObjectName

          sDiagramSyntax += `style ${oUniqueObject.SourceObjectType}${oUniqueObject.SourceObjectName} fill:${sObjectColor} ${this.NEW_LINE}`
          sDiagramSyntax += `${oUniqueObject.SourceObjectType}${oUniqueObject.SourceObjectName}[<i>&#8810;${sObjectType}&#8811;</i><br><a href="${sLink}" style="color: inherit;text-decoration: inherit;">${oUniqueObject.SourceObjectName}</a>] ${this.NEW_LINE}`
        })

        // Color main object
        sDiagramSyntax += `style ${sObjectType}${sObjectName} fill:#F44336 ${this.NEW_LINE}`

        aRelations.forEach((oRelation) => {
          /*if (!(oRelation.Relation.startsWith("DDLS") || oRelation.Relation.startsWith("BDEF"))) {
            return
          }*/

          if (oRelation.Relation.startsWith("ACCESSING")) {
            return
          }

          let sRelationType = ""
          let sLink = "--"
          switch (oRelation.Relation) {
            case "DDLS_SELECT":
              sRelationType = "Selection of"
              sLink = "=="
              break
            case "DDLS_PROJ":
              sRelationType = "Projection of"
              break
            case "DDLS_IJOIN":
              sRelationType = "Inner-Join to"
              break
            case "DDLS_LOJOI":
              sRelationType = "Left-Outer-Join to"
              break
            case "DDLS_ROJOI":
              sRelationType = "Right-Outer-Join to"
              break
            case "DDLS_IMPL":
              sRelationType = "Query Implementation in"
              break
            case "DDLS_ASSOC":
              sRelationType = "Association to"
              break
            case "DDLS_COMP":
              sRelationType = "Composition to"
              break
            case "DDLS_EXPO":
              sRelationType = "Exposing"
              break
            case "DDLS_BIND":
              sRelationType = "Binding for"
              break
            case "DDLS_BDEF":
              sRelationType = "has Behavior Definition"
              break
            case "BDEF_IMPL":
              sRelationType = "Behavior Implemented by"
              break
            case "BDEF_EXT":
              sRelationType = "Behavior Extended by"
              break
            case "DDLS_DS":
              sRelationType = "using Data Source"
              break
            case "DCLS_FOR":
              sRelationType = "Access Control for"
              break
            case "DCLS_INH":
              sRelationType = "Inheriting from"
              break
            case "DDLX_EXT":
              sRelationType = "Extending"
              break
              
            default:
              sRelationType = "Unknown"
          }

          sDiagramSyntax += `${oRelation.SourceObjectType}${oRelation.SourceObjectName} ${sLink}>|${sRelationType}| ${oRelation.TargetObjectType}${oRelation.TargetObjectName} ${this.NEW_LINE}`
        })

        this.sDiagramSyntax = sDiagramSyntax

        this.invalidate()
      },

      _isConnectedOnlyZUndirected(relationships, startType, startName, endType, endName) {
        function makeKey(objType, objName) {
          return `${objType}:${objName}`
        }

        function extractName(key) {
          const parts = key.split(":")
          return parts[1] || ""
        }

        const startKey = makeKey(startType, startName)
        const endKey = makeKey(endType, endName)

        const adjacencyList = {}

        for (const entry of relationships) {
          const sourceKey = makeKey(entry.SourceObjectType, entry.SourceObjectName)
          const targetKey = makeKey(entry.TargetObjectType, entry.TargetObjectName)

          if (!adjacencyList[sourceKey]) {
            adjacencyList[sourceKey] = []
          }
          adjacencyList[sourceKey].push(targetKey)

          if (!adjacencyList[targetKey]) {
            adjacencyList[targetKey] = []
          }
          adjacencyList[targetKey].push(sourceKey)
        }

        if (startKey === endKey) {
          return true
        }

        const visited = new Set()
        const queue = [startKey]

        while (queue.length > 0) {
          const current = queue.shift()

          if (current === endKey) {
            return true
          }

          if (!visited.has(current)) {
            visited.add(current)

            const neighbors = adjacencyList[current] || []
            for (const neighbor of neighbors) {
              if (neighbor === endKey) {
                queue.push(neighbor)
                continue
              }

              const neighborName = extractName(neighbor)
              if (neighborName.startsWith("Z")) {
                queue.push(neighbor)
              }
            }
          }
        }

        return false
      },
    })
  },
)
