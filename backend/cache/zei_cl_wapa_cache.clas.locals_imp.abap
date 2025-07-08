*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_odata_parser DEFINITION.
  PUBLIC SECTION.
    " --- Types ---
    " Structure to hold the parsed service information.
    TYPES:
      BEGIN OF ty_service_info,
        version      TYPE string, " Holds 'V2', 'V4', or 'Unknown'
        binding_name TYPE string, " Holds the extracted service binding name
        path         TYPE string, " The original path that was analyzed
      END OF ty_service_info.

    "! --- Methods ---
    "! Analyzes the provided OData path string.
    "! @parameter iv_path | The full OData path string
    "! @parameter rs_info | The result structure with version and binding name
    CLASS-METHODS analyze_path
      IMPORTING
        iv_path        TYPE string
      RETURNING
        VALUE(rs_info) TYPE ty_service_info.

  PRIVATE SECTION.
    " Constants for the OData path prefixes to avoid magic strings.
    CONSTANTS:
      BEGIN OF c_path_prefix,
        v4 TYPE string VALUE `/sap/opu/odata4/sap/`,
        v2 TYPE string VALUE `/sap/opu/odata/sap/`,
      END OF c_path_prefix.
ENDCLASS.

" -------------------------------------------------------------------------------------------------
" CLASS lcl_odata_parser IMPLEMENTATION
" -------------------------------------------------------------------------------------------------
CLASS lcl_odata_parser IMPLEMENTATION.
  METHOD analyze_path.
    " Initialize the return structure with the original path for context.
    rs_info-path = iv_path.

    " Use a COND expression for a modern, functional-style conditional assignment.
    rs_info = COND #(
      " Case 1: Path matches the OData V4 pattern
      WHEN contains( val = iv_path sub = c_path_prefix-v4 ) THEN
        VALUE #(
          path    = iv_path
          version = 'V4'
          " 1. Find the position after the V4 prefix.
          " 2. Find the next '/' which terminates the binding name.
          " 3. Extract the substring between these two points.
          binding_name = substring(
            val = iv_path
            off = strlen( c_path_prefix-v4 )
            len = find( val = substring_after( val = iv_path sub = c_path_prefix-v4 ) sub = '/' )
          )
        )

      " Case 2: Path matches the OData V2 pattern
      WHEN contains( val = iv_path sub = c_path_prefix-v2 ) THEN
        VALUE #(
          path    = iv_path
          version = 'V2'
          " Logic is identical to V4, just using the V2 prefix.
          binding_name = substring(
            val = iv_path
            off = strlen( c_path_prefix-v2 )
            len = find( val = substring_after( val = iv_path sub = c_path_prefix-v2 ) sub = '/' )
          )
        )

      " Default Case: Path does not match known OData patterns
      ELSE
        VALUE #(
          path    = iv_path
          version = ''
        )
    ).
  ENDMETHOD.
ENDCLASS.
