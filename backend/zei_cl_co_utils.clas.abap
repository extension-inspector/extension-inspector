"! <p class="shorttext synchronized" lang="en">Custom Objects Utils Class</p>
CLASS zei_cl_co_utils DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF scts_object,
             ObjectType     TYPE trobjtype,
             ObjectTypeText TYPE shvalue_d,
           END OF scts_object.
    TYPES: scts_object_table TYPE STANDARD TABLE OF scts_object WITH DEFAULT KEY.
    TYPES: BEGIN OF object_desc,
             ObjectType        TYPE trobjtype,
             ObjectName        TYPE sobj_name,
             ObjectDescription TYPE char80,
           END OF object_desc.
    TYPES: object_desc_table TYPE STANDARD TABLE OF object_desc WITH DEFAULT KEY.

    CLASS-METHODS:
      "! <p class="shorttext synchronized" lang="en">Get ABAP Object Types</p>
      "!
      "! @parameter scts_objects | <p class="shorttext synchronized" lang="en">Table containing Object Type and Text</p>
      get_abap_object_types
        RETURNING
          VALUE(scts_objects) TYPE scts_object_table,
      get_object_description
        IMPORTING
          i_type               TYPE trobjtype
          i_object             TYPE sobj_name
        RETURNING
          VALUE(r_description) TYPE char80,
      get_object_descriptions
        IMPORTING
          i_objects        TYPE object_desc_table
        RETURNING
          VALUE(r_objects) TYPE object_desc_table.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zei_cl_co_utils IMPLEMENTATION.
  METHOD get_abap_object_types.
    DATA: searchhelp TYPE shlp_descr.
    DATA: searchhelp_returns TYPE STANDARD TABLE OF ddshretval WITH DEFAULT KEY.

    CALL FUNCTION 'F4IF_GET_SHLP_DESCR'
      EXPORTING
        shlpname = 'SCTSOBJECT'
        shlptype = 'SH'
      IMPORTING
        shlp     = searchhelp.

    searchhelp-intdescr-dialogtype = 'D'.

    CALL FUNCTION 'F4IF_SELECT_VALUES'
      EXPORTING
        shlp           = searchhelp
        call_shlp_exit = abap_true
      TABLES
        return_tab     = searchhelp_returns.

    LOOP AT searchhelp_returns ASSIGNING FIELD-SYMBOL(<searchhelp_return>) WHERE fieldname = 'OBJECT'.
      DATA(text) = VALUE #( searchhelp_returns[ fieldname = 'TEXT'
                                                recordpos = <searchhelp_return>-recordpos ]-fieldval OPTIONAL ).

      INSERT VALUE #( ObjectType = <searchhelp_return>-fieldval
                      ObjectTypeText = text ) INTO TABLE scts_objects.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_object_description.
    DATA: objects TYPE TABLE OF seu_objtxt.
    objects = VALUE #( ( object = i_type obj_name = i_object ) ).

    CALL FUNCTION 'RS_SHORTTEXT_GET'
      EXPORTING
        fallback_language_1 = 'E'
      TABLES
        obj_tab             = objects.

    r_description = VALUE #( objects[ 1 ]-stext OPTIONAL ).
  ENDMETHOD.

  METHOD get_object_descriptions.
    DATA: rs_objects TYPE TABLE OF seu_objtxt.
    rs_objects = VALUE #( FOR object IN i_objects ( object = object-objecttype obj_name = object-objectname ) ).

    CALL FUNCTION 'RS_SHORTTEXT_GET'
      EXPORTING
        fallback_language_1 = 'E'
      TABLES
        obj_tab             = rs_objects.

    r_objects = VALUE #( FOR rs_object IN rs_objects ( objecttype = rs_object-object
                                                       objectname = rs_object-obj_name
                                                       objectdescription = rs_object-stext ) ).
  ENDMETHOD.

ENDCLASS.
