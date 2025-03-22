CLASS zei_cl_refresh_object_cache DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS: clear_db.
ENDCLASS.



CLASS zei_cl_refresh_object_cache IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    me->clear_db( ).

    DATA(name_filter) = xco_abap_repository=>object_name->get_filter( xco_abap_sql=>constraint->contains_pattern( 'Z%' ) ).
    DATA(objects) = xco_abap_repository=>objects->where( VALUE #( ( name_filter ) ) )->in( xco_abap=>repository )->get( ).

    name_filter = xco_abap_repository=>object_name->get_filter( xco_abap_sql=>constraint->contains_pattern( 'Y%' ) ).
    APPEND LINES OF xco_abap_repository=>objects->where( VALUE #( ( name_filter ) ) )->in( xco_abap=>repository )->get( ) TO objects.
    TRY.
        LOOP AT objects ASSIGNING FIELD-SYMBOL(<object>).
          DATA(type) = <object>->type->value.
          DATA(name) = <object>->name->value.

          zei_cl_cachefactory=>get_cache_object_for( i_object_type = type i_object_name = name )->cache( ).
        ENDLOOP.
      CATCH cx_root INTO DATA(error).
        DATA(longtext) = error->get_longtext( ).
        DATA(text) = error->get_text( ).
    ENDTRY.

    COMMIT ENTITIES.
  ENDMETHOD.

  METHOD clear_db.
    DELETE FROM zei_object_rel.
    DELETE FROM zei_object_def.
  ENDMETHOD.

ENDCLASS.
