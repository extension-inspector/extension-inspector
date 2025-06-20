CLASS lhc_Actions DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Actions RESULT result.

    METHODS read FOR READ
      IMPORTING keys FOR READ Actions RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK Actions.

    METHODS getDeclarations FOR READ
      IMPORTING keys FOR FUNCTION Actions~getDeclarations RESULT result.

    TYPES: BEGIN OF ty_object,
             object_type TYPE trobjtype,
             object_name TYPE sobj_name,
           END OF ty_object.
    TYPES: tt_objects TYPE STANDARD TABLE OF ty_object WITH NON-UNIQUE DEFAULT KEY.

ENDCLASS.

CLASS lhc_Actions IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD getDeclarations.
    DATA(object_type) = VALUE #( keys[ 1 ]-%param-ObjectType ).
    DATA(object_name) = VALUE #( keys[ 1 ]-%param-ObjectName ).
    DATA(levels) = VALUE #( keys[ 1 ]-%param-Levels ).

    DATA(objects) = VALUE tt_objects( ( object_type = object_type object_name = object_name ) ).
    DATA(objects_temp) = VALUE tt_objects( ( object_type = object_type object_name = object_name ) ).

    DO levels TIMES.
      IF objects_temp IS NOT INITIAL.
        SELECT * FROM zei_r_objectrelations
        FOR ALL ENTRIES IN @objects_temp
        WHERE ( ( SourceObjectType = @objects_temp-object_type
                    AND SourceObjectName = @objects_temp-object_name )
               OR ( TargetObjectType = @objects_temp-object_type
                    AND TargetObjectName = @objects_temp-object_name ) )
               AND Relation <> 'LNK_DASHED'
        INTO TABLE @DATA(relations).

        objects_temp = VALUE #( ).

        LOOP AT relations ASSIGNING FIELD-SYMBOL(<relation>).
          APPEND VALUE ty_object( object_type = <relation>-SourceObjectType object_name = <relation>-SourceObjectName ) TO objects.
          APPEND VALUE ty_object( object_type = <relation>-TargetObjectType object_name = <relation>-TargetObjectName ) TO objects.
          APPEND VALUE ty_object( object_type = <relation>-SourceObjectType object_name = <relation>-SourceObjectName ) TO objects_temp.
          APPEND VALUE ty_object( object_type = <relation>-TargetObjectType object_name = <relation>-TargetObjectName ) TO objects_temp.
        ENDLOOP.
      ENDIF.
    ENDDO.

    SORT: objects BY object_type object_name.
    DELETE ADJACENT DUPLICATES FROM objects COMPARING ALL FIELDS.

*    SELECT * FROM zei_r_objectrelations
*        FOR ALL ENTRIES IN @objects
*        WHERE SourceObjectType = @objects-object_type
*          AND SourceObjectName = @objects-object_name
*        INTO TABLE @relations.

    SELECT * FROM zei_r_objectdefinitions
        FOR ALL ENTRIES IN @relations
        WHERE ( SourceObjectType = @relations-SourceObjectType
          AND SourceObjectName = @relations-SourceObjectName )
           OR ( SourceObjectType = @relations-TargetObjectType
          AND SourceObjectName = @relations-TargetObjectName )
        INTO TABLE @DATA(definitions).

    result = VALUE #( ( %cid = VALUE #( keys[ 1 ]-%cid OPTIONAL )
                        %param = VALUE #( _Relations = VALUE #( FOR relation IN relations ( CORRESPONDING #( relation ) ) )
                                          _Definitions = VALUE #( FOR definition IN definitions ( CORRESPONDING #( definition ) ) ) ) ) ).
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZEI_I_ACTIONSDUMMY DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZEI_I_ACTIONSDUMMY IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
