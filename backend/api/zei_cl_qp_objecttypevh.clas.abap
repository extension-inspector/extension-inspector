"! <p class="shorttext synchronized" lang="en">Query Provider for ZEI_I_ObjectTypeVH</p>
CLASS zei_cl_qp_objecttypevh DEFINITION PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES:
      if_rap_query_provider.

  PROTECTED SECTION.

  PRIVATE SECTION.
    TYPES:
        ty_abapobjecttypes TYPE STANDARD TABLE OF zei_i_objecttypevh WITH DEFAULT KEY.

ENDCLASS.

CLASS zei_cl_qp_objecttypevh IMPLEMENTATION.

  METHOD if_rap_query_provider~select.
    DATA abapobjecttypes TYPE ty_abapobjecttypes.

    DATA(skip) = zei_cl_qp_helper=>get_skip( io_request ).
    DATA(top) = zei_cl_qp_helper=>get_top( io_request ).
    DATA(sort_string)  = zei_cl_qp_helper=>get_sort_string( request = io_request
                                                              fallback_field_to_filter = |ObjectType| ).

    TRY.
        DATA(filter_string) = io_request->get_filter( )->get_as_sql_string( ).

        abapobjecttypes = zei_cl_co_utils=>get_abap_object_types( ).

        SELECT * FROM @abapobjecttypes AS co
            WHERE (filter_string)
            ORDER BY (sort_string)
            INTO CORRESPONDING FIELDS OF TABLE @abapobjecttypes
            OFFSET @skip UP TO @top ROWS.

        IF io_request->is_total_numb_of_rec_requested( ).
          io_response->set_total_number_of_records( lines( abapobjecttypes ) ).
        ENDIF.

        IF io_request->is_data_requested( ).
          io_response->set_data( abapobjecttypes ).
        ENDIF.
      CATCH cx_root INTO DATA(exception).
        DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
