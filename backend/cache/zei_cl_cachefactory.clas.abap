CLASS zei_cl_cachefactory DEFINITION PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    CLASS-METHODS:
      get_cache_object_for
        IMPORTING
          i_object_type         TYPE trobjtype
          i_object_name         TYPE sobj_name
        RETURNING
          VALUE(r_cache_object) TYPE REF TO zei_cl_cacheobject.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS zei_cl_cachefactory IMPLEMENTATION.

  METHOD get_cache_object_for.

    CASE i_object_type.
      WHEN 'CLAS'.
        r_cache_object = NEW zei_cl_clas_cache( i_object_type = i_object_type i_object_name = i_object_name ).
      WHEN 'INTF'.
        r_cache_object = NEW zei_cl_intf_cache( i_object_type = i_object_type i_object_name = i_object_name ).
      WHEN 'DDLS'.
        r_cache_object = NEW zei_cl_ddls_cache( i_object_type = i_object_type i_object_name = i_object_name ).
      WHEN 'SRVD'.
        r_cache_object = NEW zei_cl_srvd_cache( i_object_type = i_object_type i_object_name = i_object_name ).
      WHEN 'SRVB'.
        r_cache_object = NEW zei_cl_srvb_cache( i_object_type = i_object_type i_object_name = i_object_name ).
      WHEN 'SMBC'.
        r_cache_object = NEW zei_cl_smbc_cache( i_object_type = i_object_type i_object_name = i_object_name ).
      WHEN 'WAPA'.
        r_cache_object = NEW zei_cl_wapa_cache( i_object_type = i_object_type i_object_name = i_object_name ).
      WHEN 'SAJC'.
        r_cache_object = NEW zei_cl_sajc_cache( i_object_type = i_object_type i_object_name = i_object_name ).
      WHEN 'SAJT'.
        r_cache_object = NEW zei_cl_sajt_cache( i_object_type = i_object_type i_object_name = i_object_name ).

      WHEN OTHERS.
        r_cache_object = NEW zei_cl_cacheobject( i_object_type = i_object_type i_object_name = i_object_name ).
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
