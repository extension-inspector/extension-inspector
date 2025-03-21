"! <p class="shorttext synchronized" lang="en">Query Provider Helper Class</p>
CLASS zei_cl_qp_helper DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS:
      "! <p class="shorttext synchronized" lang="en">Get skip/offset value</p>
      "!
      "! @parameter request | <p class="shorttext synchronized" lang="en">Request context</p>
      "! @parameter skip | <p class="shorttext synchronized" lang="en">Skip/offset value</p>
      get_skip
        IMPORTING request     TYPE REF TO if_rap_query_request
        RETURNING VALUE(skip) TYPE int8,

      "! <p class="shorttext synchronized" lang="en">Get top/maximum rows value</p>
      "!
      "! @parameter request | <p class="shorttext synchronized" lang="en">Request context</p>
      "! @parameter top | <p class="shorttext synchronized" lang="en">Top/maximum rows value</p>
      get_top
        IMPORTING request    TYPE REF TO if_rap_query_request
        RETURNING VALUE(top) TYPE int8,

      "! <p class="shorttext synchronized" lang="en">Get sort string</p>
      "!
      "! @parameter request | <p class="shorttext synchronized" lang="en">Request context</p>
      "! @parameter fallback_field_to_filter | <p class="shorttext synchronized" lang="en">Field to fall back on, if no filters can be found</p>
      "! @parameter sort_string | <p class="shorttext synchronized" lang="en">Sort string</p>
      get_sort_string
        IMPORTING request                  TYPE REF TO if_rap_query_request
                  fallback_field_to_filter TYPE string
        RETURNING VALUE(sort_string)       TYPE string,

      "! <p class="shorttext synchronized" lang="en">Get requested elements string</p>
      "!
      "! @parameter request | <p class="shorttext synchronized" lang="en">Request context</p>
      "! @parameter requested_elements_string | <p class="shorttext synchronized" lang="en">Requested elements string</p>
      get_requested_elements_string
        IMPORTING request                          TYPE REF TO if_rap_query_request
        RETURNING VALUE(requested_elements_string) TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zei_cl_qp_helper IMPLEMENTATION.
  METHOD get_skip.
    skip = request->get_paging( )->get_offset( ).
  ENDMETHOD.

  METHOD get_top.
    DATA(max_rows)     = request->get_paging( )->get_page_size( ).
    top = COND #( WHEN max_rows = if_rap_query_paging=>page_size_unlimited
                  THEN 0
                  ELSE max_rows ).
  ENDMETHOD.

  METHOD get_sort_string.
    DATA(sort_criteria) = VALUE string_table( FOR sort_element IN request->get_sort_elements( )
                                                ( sort_element-element_name && COND #( WHEN sort_element-descending = abap_true
                                                                                       THEN ` descending`
                                                                                       ELSE ` ascending` ) ) ).
    sort_string  = COND #( WHEN sort_criteria IS INITIAL
                           THEN fallback_field_to_filter
                           ELSE concat_lines_of( table = sort_criteria sep = `, ` ) ).
  ENDMETHOD.

  METHOD get_requested_elements_string.
    requested_elements_string = concat_lines_of( table = request->get_requested_elements( ) sep = `, ` ).
  ENDMETHOD.

ENDCLASS.
