CLASS zei_cl_refresh_ext_cache DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      tt_types       TYPE STANDARD TABLE OF trobjtype,
      tt_baseobjects TYPE STANDARD TABLE OF zei_i_extensionbaseobjects WITH EMPTY KEY,
      tt_relations   TYPE STANDARD TABLE OF zei_r_objectrelations WITH EMPTY KEY.

    TYPES: BEGIN OF ty_object,
             object_type TYPE trobjtype,
             object_name TYPE sobj_name,
           END OF ty_object.
    TYPES: tt_objects TYPE STANDARD TABLE OF ty_object WITH NON-UNIQUE DEFAULT KEY.

    DATA:
      objects               TYPE tt_baseobjects,
      objects_to_be_handled TYPE tt_baseobjects,
      last_bb_uuid          TYPE sysuuid_c32,
      bb_heads              TYPE TABLE FOR CREATE ZEI_I_BuildingBlockHead,
      bb_items              TYPE TABLE FOR CREATE zei_i_buildingblockitem.

    METHODS:
      _get_references
        IMPORTING
          i_type              TYPE trobjtype
          i_name              TYPE sobj_name
          i_reference_types   TYPE tt_types
        RETURNING
          VALUE(r_references) TYPE tt_relations,
      _add_to_head
        IMPORTING
          i_type TYPE  zei_bbtype
          i_name TYPE sobj_name,
      _add_to_items
        IMPORTING
          i_type        TYPE  zei_bbtype
          i_object_type TYPE trobjtype
          i_object_name TYPE sobj_name
          i_items       TYPE tt_relations,
      _remove_from_to_be_handled
        IMPORTING
          i_rows TYPE  tt_relations,
      _handle_abap
        IMPORTING
          i_object TYPE zei_i_extensionbaseobjects,
      _handle_odata_rap
        IMPORTING
          i_object TYPE zei_i_extensionbaseobjects,
      _handle_busconf
        IMPORTING
          i_object TYPE zei_i_extensionbaseobjects,
      _handle_custabl
        IMPORTING
          i_object TYPE zei_i_extensionbaseobjects.
ENDCLASS.



CLASS zei_cl_refresh_ext_cache IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    " Clear tables
    DELETE FROM zei_bb_head.
    DELETE FROM zei_bb_items.

    " Select base
    SELECT *
        FROM zei_i_extensionbaseobjects
        INTO TABLE @me->objects.

    me->objects_to_be_handled = me->objects.

    " ------------------------------------------------------------------------
    " work through all objects and create building blocks
    " add development object items

    LOOP AT me->objects ASSIGNING FIELD-SYMBOL(<base_object>).
      IF NOT line_exists( me->objects_to_be_handled[ ABAPObjectType = <base_object>-ABAPObjectType
                                                     ABAPObject = <base_object>-ABAPObject ] ).
        CONTINUE.
      ENDIF.

      CASE <base_object>-ABAPObjectType.
        WHEN 'CLAS' OR 'INTF'.
          _handle_abap( <base_object> ).
        WHEN 'SRVB'.
          _handle_odata_rap( <base_object> ).
        WHEN 'SMBC'.
          _handle_busconf( <base_object> ).
        WHEN 'TABL'.
          _handle_custabl( <base_object> ).
        WHEN '???'.
          " Enhancement based on Business Add-In
      ENDCASE.


    ENDLOOP.

    " ------------------------------------------------------------------------
    " work through all building blocks
    " add add building blocks to items (if an building block encapsulates another building block)

    " loop over created building blocks and add referenced building blocks as items

    LOOP AT me->bb_heads ASSIGNING FIELD-SYMBOL(<bb_head>).

      CASE <bb_head>-Type.
        WHEN 'BUSCONF'.
          " Get SMBC of BUSCONF
          SELECT SINGLE ObjectType, ObjectName
            FROM @me->bb_items AS items
            WHERE items~BuildingBlockGuid = @<bb_head>-Guid
              AND items~ObjectType = 'SMBC'
            INTO @DATA(item).

          " Get SRVB of SMBC
          SELECT SINGLE *
            FROM zei_r_objectrelations
            WHERE SourceObjectType = @item-ObjectType
              AND SourceObjectName = @item-ObjectName
            INTO @DATA(relation).

          " Get BB Guid of SMBC
          SELECT SINGLE BuildingBlockGuid
            FROM @me->bb_items AS items
            WHERE items~ObjectType = @relation-TargetObjectType
              AND items~ObjectName = @relation-TargetObjectName
            INTO @DATA(child_guid).

          " Get BB of Guid
          READ TABLE me->bb_heads ASSIGNING FIELD-SYMBOL(<bb_head_child>) WITH KEY Guid = child_guid.
          <bb_head_child>-ParentBBGuid = <bb_head>-Guid.
      ENDCASE.


    ENDLOOP.


    " ------------------------------------------------------------------------
    " create and commit

    MODIFY ENTITIES OF ZEI_I_BuildingBlockHead
        ENTITY BuildingBlockHead
        CREATE FROM me->bb_heads
        MAPPED DATA(mapped_head)
        REPORTED DATA(reported_head)
        FAILED DATA(failed_head).


    MODIFY ENTITIES OF ZEI_I_BuildingBlockItem
        ENTITY BuildingBlockItem
        CREATE FROM me->bb_items
        MAPPED DATA(mapped_item)
        REPORTED DATA(reported_item)
        FAILED DATA(failed_item).

    COMMIT ENTITIES.

    out->write( |{ lines( me->objects ) - lines( me->objects_to_be_handled ) }/{ lines( me->objects ) }| ).
  ENDMETHOD.

  METHOD _add_to_head.
    DATA: head_create TYPE TABLE FOR CREATE ZEI_I_BuildingBlockHead.

    me->last_bb_uuid = cl_system_uuid=>create_uuid_c32_static( ).
    APPEND VALUE #( Guid = me->last_bb_uuid
                    Type = i_type
                    Name = i_name
                    %control-Guid = if_abap_behv=>mk-on
                    %control-Type = if_abap_behv=>mk-on
                    %control-Name = if_abap_behv=>mk-on
                    %control-ParentBBGuid = if_abap_behv=>mk-on ) TO me->bb_heads.
  ENDMETHOD.

  METHOD _add_to_items.
    DATA: item_create TYPE TABLE FOR CREATE ZEI_I_BuildingBlockItem.

    " get unique objects from relations
    DATA: unique_objects TYPE tt_objects.
    LOOP AT i_items ASSIGNING FIELD-SYMBOL(<item>).
      DATA(source_object) = VALUE ty_object( object_type = <item>-SourceObjectType object_name = <item>-SourceObjectName ).
      IF NOT line_exists( unique_objects[ object_type = source_object-object_type object_name = source_object-object_name ] )
        AND source_object-object_type IS NOT INITIAL AND source_object-object_name IS NOT INITIAL.
        APPEND source_object TO unique_objects.
      ENDIF.

      DATA(target_object) = VALUE ty_object( object_type = <item>-TargetObjectType object_name = <item>-TargetObjectName ).
      IF NOT line_exists( unique_objects[ object_type = target_object-object_type object_name = target_object-object_name ] )
        AND target_object-object_type IS NOT INITIAL AND target_object-object_name IS NOT INITIAL.
        APPEND target_object TO unique_objects.
      ENDIF.
    ENDLOOP.

    " append building block source item to make sure the all items are added here
    APPEND VALUE #( object_type = i_object_type object_name = i_object_name ) TO unique_objects.

    SORT unique_objects BY object_type object_name.
    DELETE ADJACENT DUPLICATES FROM unique_objects.

    item_create = VALUE #( FOR item IN unique_objects ( BuildingBlockGuid = me->last_bb_uuid
                                                        ObjectType = item-object_type
                                                        ObjectName = item-object_name
                                                        %control-BuildingBlockGuid = if_abap_behv=>mk-on
                                                        %control-ObjectType = if_abap_behv=>mk-on
                                                        %control-ObjectName = if_abap_behv=>mk-on ) ).

    APPEND LINES OF item_create TO me->bb_items.
  ENDMETHOD.

  METHOD _get_references.
    DATA: objects TYPE STANDARD TABLE OF zei_r_objectrelations.
    DATA(objects_temp) = VALUE tt_objects( ( object_type = i_type object_name = i_name ) ).

    DATA: references_range TYPE RANGE OF trobjtype.
    references_range = VALUE #( FOR reference IN i_reference_types ( sign = 'I' option = 'EQ' low = reference ) ).

    DO.
      IF objects_temp IS INITIAL.
        EXIT.
      ENDIF.

      SELECT * FROM zei_r_objectrelations
          FOR ALL ENTRIES IN @objects_temp
          WHERE ( SourceObjectType = @objects_temp-object_type
                  AND SourceObjectName = @objects_temp-object_name )
             OR ( TargetObjectType = @objects_temp-object_type
                  AND TargetObjectName = @objects_temp-object_name )
          INTO TABLE @DATA(relations).

      objects_temp = VALUE #( ).

      LOOP AT relations ASSIGNING FIELD-SYMBOL(<relation>) WHERE SourceObjectType IN references_range AND TargetObjectType IN references_range.
        IF NOT line_exists( objects[ Guid = <relation>-Guid ] ).
          APPEND <relation> TO objects.

          DATA(source_start) = <relation>-SourceObjectName+0(1).
          DATA(target_start) = <relation>-TargetObjectName+0(1).

          DATA(source_is_custom) = xsdbool( source_start = 'Z' OR source_start = 'Y' ).
          DATA(target_is_custom) = xsdbool( target_start = 'Z' OR target_start = 'Y' ).

          IF source_is_custom = abap_true.
            APPEND VALUE ty_object( object_type = <relation>-SourceObjectType object_name = <relation>-SourceObjectName ) TO objects_temp.
          ENDIF.

          IF target_is_custom = abap_true.
            APPEND VALUE ty_object( object_type = <relation>-TargetObjectType object_name = <relation>-TargetObjectName ) TO objects_temp.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDDO.

    LOOP AT objects ASSIGNING FIELD-SYMBOL(<object>).
      source_start = <object>-SourceObjectName+0(1).
      target_start = <object>-TargetObjectName+0(1).

      source_is_custom = xsdbool( source_start = 'Z' OR source_start = 'Y' ).
      target_is_custom = xsdbool( target_start = 'Z' OR target_start = 'Y' ).

      IF source_is_custom = abap_false OR target_is_custom = abap_false.
        DELETE objects WHERE Guid = <object>-Guid.
      ENDIF.
    ENDLOOP.

    r_references = objects.
  ENDMETHOD.

  METHOD _remove_from_to_be_handled.
    LOOP AT i_rows ASSIGNING FIELD-SYMBOL(<reference>).
      IF line_exists( me->objects_to_be_handled[ ABAPObjectType = <reference>-SourceObjectType
                                             ABAPObject = <reference>-SourceObjectName ] ).
        DELETE me->objects_to_be_handled WHERE ABAPObjectType = <reference>-SourceObjectType
                                       AND ABAPObject = <reference>-SourceObjectName.
      ENDIF.

      IF line_exists( me->objects_to_be_handled[ ABAPObjectType = <reference>-TargetObjectType
                                            ABAPObject = <reference>-TargetObjectName ] ).
        DELETE me->objects_to_be_handled WHERE ABAPObjectType = <reference>-TargetObjectType
                                       AND ABAPObject = <reference>-TargetObjectName.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD _handle_abap.
    _add_to_head( i_type = 'ABAP'
                    i_name = CONV #( i_object-ABAPObject ) ).

    DATA(references) = _get_references( i_type = i_object-ABAPObjectType
                                        i_name = CONV #( i_object-ABAPObject )
                                        i_reference_types = VALUE #( ( 'CLAS' ) ( 'INTF' ) ) ).

    _add_to_items( i_type = 'ABAP' i_object_type = i_object-ABAPObjectType
                                        i_object_name = CONV #( i_object-ABAPObject )
                                        i_items = references ).

    DELETE me->objects_to_be_handled WHERE ABAPObjectType = i_object-ABAPObjectType
                                   AND ABAPObject = i_object-ABAPObject.
    _remove_from_to_be_handled( references ).
  ENDMETHOD.

  METHOD _handle_odata_rap.
    _add_to_head( i_type = 'ODATARAP'
                    i_name = CONV #( i_object-ABAPObject ) ).

    DATA(references) = _get_references( i_type = i_object-ABAPObjectType
                                        i_name = CONV #( i_object-ABAPObject )
                                        i_reference_types = VALUE #( ( 'SRVB' ) ( 'SRVD' ) ) ).

    _add_to_items( i_type = 'ODATARAP' i_object_type = i_object-ABAPObjectType
                                        i_object_name = CONV #( i_object-ABAPObject )
                                        i_items = references ).

    DELETE me->objects_to_be_handled WHERE ABAPObjectType = i_object-ABAPObjectType
                                   AND ABAPObject = i_object-ABAPObject.
    _remove_from_to_be_handled( references ).
  ENDMETHOD.

  METHOD _handle_busconf.
    _add_to_head( i_type = 'BUSCONF'
                        i_name = CONV #( i_object-ABAPObject ) ).

    DATA(references) = _get_references( i_type = i_object-ABAPObjectType
                                        i_name = CONV #( i_object-ABAPObject )
                                        i_reference_types = VALUE #( ( 'SMBC' ) ) ).

    _add_to_items( i_type = 'BUSCONF' i_object_type = i_object-ABAPObjectType
                                        i_object_name = CONV #( i_object-ABAPObject )
                                        i_items = references ).

    DELETE me->objects_to_be_handled WHERE ABAPObjectType = i_object-ABAPObjectType
                                   AND ABAPObject = i_object-ABAPObject.
    _remove_from_to_be_handled( references ).
  ENDMETHOD.

  METHOD _handle_custabl.
    _add_to_head( i_type = 'CUSTABL'
                        i_name = CONV #( i_object-ABAPObject ) ).

    _add_to_items( i_type = 'BUSCONF' i_object_type = i_object-ABAPObjectType
                                        i_object_name = CONV #( i_object-ABAPObject )
                                        i_items = VALUE #( ( SourceObjectType = i_object-ABAPObjectType
                                                             SourceObjectName = i_object-ABAPObject ) ) ).

    DELETE me->objects_to_be_handled WHERE ABAPObjectType = i_object-ABAPObjectType
                                   AND ABAPObject = i_object-ABAPObject.
  ENDMETHOD.

ENDCLASS.
