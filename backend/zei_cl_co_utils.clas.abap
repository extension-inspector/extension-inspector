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
          VALUE(r_description) TYPE char80.

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
    TRY.
        CASE i_type.
          WHEN 'CLAS'.
            DATA(class) = xco_abap=>class( CONV #( i_object ) ).
            r_description = class->content( )->get_short_description( ).
          WHEN 'INTF'.
            DATA(interface) = xco_abap=>interface( CONV #( i_object ) ).
            r_description = interface->content( )->get_short_description( ).
          WHEN 'BDEF'.
            DATA(behavior_def) = xco_cds=>behavior_definition( CONV #( i_object ) ).
            r_description = behavior_def->content( )->get_short_description( ).
          WHEN 'DDLS'.
            DATA(data_definition) = xco_cds=>data_definition( CONV #( i_object ) ).

            " handle edge case that data definitions of type extend dont support a description (#5)
            DATA(type) = data_definition->get_type( ).
            IF type IS NOT INITIAL AND type->value = 'E'.
              RETURN.
            ENDIF.

            r_description = data_definition->view( )->content( )->get_short_description( ).
          WHEN 'TABL'.
            DATA(table) = xco_abap_dictionary=>table( CONV #( i_object ) ).
            r_description = table->get_database_table( )->content( )->get_short_description( ).
        ENDCASE.

      CATCH cx_root.

    ENDTRY.
  ENDMETHOD.

ENDCLASS.
