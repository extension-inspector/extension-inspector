"! <p class="shorttext synchronized" lang="en">Query Provider for ZEI_I_ObjectAccesses</p>
CLASS zei_cl_qp_objectaccesses DEFINITION PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES:
      if_rap_query_provider.

  PROTECTED SECTION.

  PRIVATE SECTION.
    TYPES:
        ty_objectaccesses TYPE STANDARD TABLE OF zei_i_objectaccesses WITH DEFAULT KEY.

ENDCLASS.

CLASS zei_cl_qp_objectaccesses IMPLEMENTATION.

  METHOD if_rap_query_provider~select.
    DATA objectaccesses TYPE ty_objectaccesses.

    DATA(skip) = zei_cl_qp_helper=>get_skip( io_request ).
    DATA(top) = zei_cl_qp_helper=>get_top( io_request ).
    DATA(sort_string)  = zei_cl_qp_helper=>get_sort_string( request = io_request
                                                              fallback_field_to_filter = |Object| ).

    TRY.
        DATA(filter_ranges) = io_request->get_filter( )->get_as_ranges( ).
        DATA(object_type) = CONV seu_obj( VALUE #( filter_ranges[ name = 'TYPE' ]-range[ 1 ]-low OPTIONAL ) ).
        DATA(object_name) = CONV sobj_name( VALUE #( filter_ranges[ name = 'ENCL_OBJ' ]-range[ 1 ]-low OPTIONAL ) ).

        DATA: environment_table TYPE TABLE OF senvi.
        CALL FUNCTION 'REPOSITORY_ENVIRONMENT_SET'
          EXPORTING
            obj_type    = object_type
            object_name = object_name
          TABLES
            environment = environment_table.

        LOOP AT environment_table ASSIGNING FIELD-SYMBOL(<environment>) WHERE type = 'CLAS' OR type = 'BDEF' OR type = 'INCL'.
          APPEND CORRESPONDING #( <environment> ) TO objectaccesses.
        ENDLOOP.

        DATA(scts_objects) = zs4ei_cl_co_utils=>get_abap_object_types( ).

        LOOP AT objectaccesses ASSIGNING FIELD-SYMBOL(<objectaccess>).
          <objectaccess>-TypeName = VALUE #( scts_objects[ objecttype = <objectaccess>-Type ]-objecttypetext OPTIONAL ).

          <objectaccess>-ObjectText = zei_cl_co_utils=>get_object_description( i_type = CONV #( <objectaccess>-Type ) i_object = CONV #( <objectaccess>-Object ) ).
        ENDLOOP.

        SELECT * FROM @objectaccesses AS co
           ORDER BY (sort_string)
           INTO CORRESPONDING FIELDS OF TABLE @objectaccesses
           OFFSET @skip UP TO @top ROWS.

        IF io_request->is_total_numb_of_rec_requested( ).
          io_response->set_total_number_of_records( lines( objectaccesses ) ).
        ENDIF.

        IF io_request->is_data_requested( ).
          io_response->set_data( objectaccesses ).
        ENDIF.
      CATCH cx_root INTO DATA(exception).
        DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
