CLASS zei_cl_apj_refresh_objectcache DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_apj_dt_exec_object.
    INTERFACES if_apj_rt_exec_object.

    DATA patterns TYPE RANGE OF char50.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zei_cl_apj_refresh_objectcache IMPLEMENTATION.


  METHOD if_apj_dt_exec_object~get_parameters.
    et_parameter_def = VALUE #( ( selname = 'PATTERNS' kind = if_apj_dt_exec_object=>select_option datatype = 'C' length = 50 param_text = 'Patterns' ) ).
  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.
    DATA objects TYPE sxco_t_ar_objects.

    TRY.
        DATA(log) = cl_bali_log=>create_with_header( cl_bali_header_setter=>create( object = 'ZEI_LOG' subobject = 'ZEI_LOG_APJ' ) ).

        LOOP AT it_parameters ASSIGNING FIELD-SYMBOL(<parameter>).
          DATA(name_filter) = xco_abap_repository=>object_name->get_filter( xco_abap_sql=>constraint->contains_pattern( <parameter>-low ) ).
          APPEND LINES OF xco_abap_repository=>objects->where( VALUE #( ( name_filter ) ) )->in( xco_abap=>repository )->get( ) TO objects.
        ENDLOOP.


        LOOP AT objects ASSIGNING FIELD-SYMBOL(<object>).
          DATA(type) = <object>->type->value.
          DATA(name) = <object>->name->value.

          TRY.
              zei_cl_cachefactory=>get_cache_object_for( i_object_type = type i_object_name = name )->cache( ).
            CATCH cx_root INTO DATA(exception).
              log->add_item( cl_bali_exception_setter=>create( severity = if_bali_constants=>c_severity_error
                                                               exception = exception ) ).
          ENDTRY.
        ENDLOOP.

        DELETE FROM zei_object_rel.
        DELETE FROM zei_object_def.

        cl_bali_log_db=>get_instance( )->save_log( log = log
                                                   assign_to_current_appl_job = abap_true ).

        COMMIT ENTITIES.
      CATCH cx_bali_runtime INTO DATA(bali_runtime_exception).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
