CLASS lhc_zi_booksuppl_um_al DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_booksuppl_um_al.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zi_booksuppl_um_al.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_booksuppl_um_al RESULT result.

    METHODS rba_Booking FOR READ
      IMPORTING keys_rba FOR READ zi_booksuppl_um_al\_Booking FULL result_requested RESULT result LINK association_links.

    METHODS rba_Travel FOR READ
      IMPORTING keys_rba FOR READ zi_booksuppl_um_al\_Travel FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_zi_booksuppl_um_al IMPLEMENTATION.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Booking.
  ENDMETHOD.

  METHOD rba_Travel.
  ENDMETHOD.

ENDCLASS.

CLASS cl_buffer DEFINITION.

  PUBLIC SECTION.
    CLASS-DATA: gt_create_travel TYPE TABLE OF ztravel_um_al.
    CLASS-DATA : gt_booking_create TYPE TABLE OF zbooking_um_al.


    CLASS-DATA: gt_update_travel TYPE TABLE OF ztravel_um_al.
    CLASS-DATA: gt_update_booking TYPE TABLE OF zbooking_um_al.


    CLASS-DATA: gt_travel_del TYPE TABLE OF ztravel_um_al.
    CLASS-DATA: gt_booking_del TYPE TABLE OF zbooking_um_al.

    CLASS-DATA: gt_bs_cba TYPE TABLE OF zbooksuppl_um_al.




ENDCLASS.


CLASS lhc_ZI_TRAVEL_UM_AL DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR travel_uml RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR travel_uml RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE travel_uml.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE travel_uml.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE travel_uml.

    METHODS read FOR READ
      IMPORTING keys FOR READ travel_uml RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK travel_uml.

    METHODS rba_Booking FOR READ
      IMPORTING keys_rba FOR READ travel_uml\_Booking FULL result_requested RESULT result LINK association_links.

    METHODS cba_Booking FOR MODIFY
      IMPORTING entities_cba FOR CREATE travel_uml\_Booking.
    METHODS formatDescription FOR DETERMINE ON MODIFY
      IMPORTING keys FOR travel_uml~formatDescription.

ENDCLASS.

CLASS lhc_ZI_TRAVEL_UM_AL IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
    IF requested_authorizations-%create IS NOT INITIAL.
      result-%create = if_abap_behv=>auth-allowed.
    ENDIF.

  ENDMETHOD.

  METHOD create.
*
*    TYPES: tt_travel_um  TYPE TABLE FOR MAPPED EARLY zi_travel_um_al.
*    DATA: lt_travel_um TYPE tt_travel_um.
*    DATA: ls_travel_um LIKE LINE OF lt_travel_um.
    GET TIME STAMP FIELD DATA(lv_ts).

*    data: lt_create_travel type table of ztravel_um_al.
    DATA: ls_create_travel TYPE ztravel_um_al.

    LOOP AT entities INTO DATA(ls_entity) WHERE %cid IS NOT INITIAL.

*    ls_create_travel-client = sy-mandt.
*    ls_create_travel-description = ls_entity-description.
*    ls_create_travel-travel_id = ls_entity-travel_id.


      ls_create_travel = CORRESPONDING #( ls_entity  ).
      ls_create_travel-last_changed_at = lv_ts.
      ls_create_travel-local_last_changed_at = lv_ts.

*    append ls_create_travel to lt_create_travel.
      APPEND ls_create_travel TO cl_buffer=>gt_create_travel.

*    insert ztravel_um_al from table @lt_create_travel. "

    ENDLOOP.



*    ls_travel_um-%cid = 'Create_Travel1'.
*    ls_travel_um-%is_draft = if_abap_behv=>mk-on.
*
*    TRY.
*        ls_travel_um-travel_uuid = cl_system_uuid=>create_uuid_x16_static( ).
*      CATCH   cx_uuid_error .
*    ENDTRY.
*
*    APPEND ls_travel_um TO lt_travel_um.
*
*
*    mapped-zi_travel_um_al = lt_travel_um.

  ENDMETHOD.

  METHOD update.


*  GOAL IS TO UPDAT THE travel TABLE

    DATA: lt_travel_update TYPE TABLE OF ztravel_um_al.
    DATA: ls_travel TYPE ztravel_um_al.

    "get the existing data
    SELECT * FROM   zi_travel_um_al
    FOR ALL ENTRIES IN  @entities WHERE travel_uuid =  @entities-travel_uuid
    INTO TABLE @DATA(lt_original).

    LOOP AT entities  INTO DATA(ls_entity).

      ls_travel-travel_uuid = ls_entity-travel_uuid.



      IF ls_entity-%control-description = if_abap_behv=>mk-on.

        ls_travel-description = ls_entity-description.

      ELSE.

        ls_travel-description =

        VALUE #( lt_original[ travel_uuid = ls_entity-travel_uuid ]-description OPTIONAL ) .

      ENDIF.


      IF ls_entity-%control-travel_id = if_abap_behv=>mk-on.

        ls_travel-travel_id = ls_entity-travel_id.

      ELSE.

        ls_travel-travel_id =

        VALUE #( lt_original[ travel_uuid = ls_entity-travel_uuid ]-travel_id OPTIONAL ) .

      ENDIF.





      GET TIME STAMP FIELD DATA(lv_ts).
      ls_travel-last_changed_at  = lv_ts.
      ls_travel-local_last_changed_at = lv_ts.

      APPEND ls_travel TO lt_travel_update.
    ENDLOOP..


    IF lt_travel_update IS NOT INITIAL.
      "populate buffer
      cl_buffer=>gt_update_travel = lt_travel_update.



    ENDIF.

  ENDMETHOD.

  METHOD delete.
    DATA lt_travel_del TYPE TABLE OF ztravel_um_al.

    LOOP AT keys INTO DATA(wa_key).

      APPEND VALUE #( travel_uuid = wa_key-travel_uuid   )

      TO lt_travel_del.

    ENDLOOP.

    IF lt_travel_del IS NOT INITIAL.

      cl_buffer=>gt_travel_del = lt_travel_del.

    ENDIF.


  ENDMETHOD.

  METHOD read.


    DATA: lt_result TYPE  TABLE FOR READ RESULT zi_travel_um_al.
    DATA: ls_result LIKE LINE OF lt_result.

    "select the data from the draft table when you click on edit button
    SELECT * FROM ztravel_um_al FOR ALL ENTRIES IN @keys WHERE travel_uuid = @keys-travel_uuid
    INTO TABLE @DATA(lt_draft_data).

    LOOP AT lt_draft_data INTO DATA(ls_draft_data).
      ls_result = CORRESPONDING #( ls_draft_data  ).
      ls_result-%is_draft = if_abap_behv=>mk-on.
      APPEND ls_result TO lt_result.
    ENDLOOP.

    result = lt_result.

  ENDMETHOD.

  METHOD lock.
    "create lock object

*name of the lock object: EZ_TRAVEL_L

*Implementation steps

    TRY.

        cl_abap_lock_object_factory=>get_instance(
          EXPORTING
            iv_name        = 'EZ_TRAVEL_L'
          RECEIVING
            ro_lock_object = DATA(lo_lock)
        ).


        LOOP AT keys INTO DATA(wa_key).
          lo_lock->enqueue(
*  it_table_mode =
            it_parameter  = VALUE #( ( name = 'TRAVEL_UUID' value = REF #( wa_key-travel_uuid ) )  )
*  _scope        =
*  _wait         =
          ).
        ENDLOOP.
      CATCH cx_abap_foreign_lock INTO DATA(lx_fl).
      CATCH cx_abap_lock_failure.


        APPEND VALUE #( travel_uuid = wa_key-travel_uuid

        %msg =  new_message_with_text(   severity = if_abap_behv_message=>severity-error
                                         text =   | record locked by { lx_fl->user_name } |     )                  )

        TO reported-travel_uml.

    ENDTRY.



  ENDMETHOD.

  METHOD rba_Booking.
    DATA(lv_test) = abap_true.
  ENDMETHOD.

  METHOD cba_Booking.

    "write the code to save the data into booking table ZBOOKING_UM_AL


    DATA: lt_booking_cr TYPE TABLE OF zbooking_um_al.

    DATA: ls_booking_cr TYPE zbooking_um_al.

    GET TIME STAMP FIELD DATA(lv_ts).

    "POPULATE THE DATA IN LT_BOOKING_CR WHICH YOU WANT TO SAVE

    LOOP AT   entities_cba INTO DATA(wa_cba).

      ls_booking_cr-parent_uuid = wa_cba-travel_uuid.

      LOOP AT wa_cba-%target INTO DATA(wa_target).
*        TRY.
*            ls_booking_cr-booking_uuid = cl_system_uuid=>create_uuid_x16_static( ).
*
*          CATCH   cx_uuid_error .
*
*        ENDTRY.

        ls_booking_cr-booking_uuid = wa_target-booking_uuid.

        ls_booking_cr-client = sy-mandt.

        ls_booking_cr-customer_id = wa_target-customer_id.

        ls_booking_cr-last_changed_at = lv_ts.

        ls_booking_cr-booking_id = wa_target-booking_id.

        ls_booking_cr-local_last_changed_at = lv_ts.

        APPEND ls_booking_cr TO lt_booking_cr.


      ENDLOOP.
    ENDLOOP.

    IF  lt_booking_cr IS NOT INITIAL.

      cl_buffer=>gt_booking_create = lt_booking_cr.

    ENDIF.
  ENDMETHOD.

  METHOD formatDescription.


    " 1. Read the user's input from the Draft table
    READ ENTITIES OF zi_travel_um_al IN LOCAL MODE
      ENTITY travel_uml
        FIELDS ( travel_id description )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_travel).




    DATA lt_update TYPE TABLE FOR UPDATE zi_travel_um_al.
    " 2. Apply the Business Logic
    LOOP AT lt_travel INTO DATA(ls_travel).
      " Only execute if a Travel ID was actually entered
      CHECK ls_travel-travel_id IS NOT INITIAL.
      " Create the prefix, e.g., "Trip #1 - "
      DATA(lv_prefix) = |Trip #{ ls_travel-travel_id } |.
      " If the description doesn't already have this prefix, add it!
      IF ls_travel-description NS lv_prefix.
        APPEND VALUE #(
          %tky        = ls_travel-%tky
          description = lv_prefix "&& ls_travel-description
        ) TO lt_update.

      ENDIF.
    ENDLOOP.
    " 3. Update the Draft table with the new formatted description
    IF lt_update IS NOT INITIAL.
      MODIFY ENTITIES OF zi_travel_um_al IN LOCAL MODE
        ENTITY travel_uml
          UPDATE FIELDS ( description )
          WITH lt_update.
    ENDIF.



  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZI_BOOKING_UM_AL DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_booking_um_al.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zi_booking_um_al.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_booking_um_al RESULT result.

    METHODS rba_Travel FOR READ
      IMPORTING keys_rba FOR READ zi_booking_um_al\_Travel FULL result_requested RESULT result LINK association_links.
    METHODS rba_Booksuppl FOR READ
      IMPORTING keys_rba FOR READ zi_booking_um_al\_Booksuppl FULL result_requested RESULT result LINK association_links.

    METHODS cba_Booksuppl FOR MODIFY
      IMPORTING entities_cba FOR CREATE zi_booking_um_al\_Booksuppl.

ENDCLASS.

CLASS lhc_ZI_BOOKING_UM_AL IMPLEMENTATION.

  METHOD update.

*  GOAL IS TO UPDAT THE BOOKING TABLE

    DATA: lt_booking_update TYPE TABLE OF zbooking_um_al.
    DATA: ls_booking TYPE zbooking_um_al.

    "get the existing data
    SELECT * FROM   zi_booking_um_al
    FOR ALL ENTRIES IN  @entities WHERE booking_uuid =  @entities-booking_uuid
    INTO TABLE @DATA(lt_original).

    LOOP AT entities  INTO DATA(ls_entity).

      ls_booking-booking_uuid = ls_entity-booking_uuid.



      IF ls_entity-%control-customer_id = if_abap_behv=>mk-on.

        ls_booking-customer_id = ls_entity-customer_id.

      ELSE.

        ls_booking-customer_id =

        VALUE #( lt_original[ booking_uuid = ls_entity-booking_uuid ]-customer_id OPTIONAL ) .

      ENDIF.


      IF ls_entity-%control-parent_uuid = if_abap_behv=>mk-on.

        ls_booking-parent_uuid = ls_entity-parent_uuid.

      ELSE.

        ls_booking-parent_uuid =

        VALUE #( lt_original[ booking_uuid = ls_entity-booking_uuid ]-parent_uuid OPTIONAL ) .

      ENDIF.




      IF ls_entity-%control-booking_id = if_abap_behv=>mk-on.

        ls_booking-booking_id = ls_entity-booking_id.

      ELSE.

        ls_booking-booking_id =

        VALUE #( lt_original[ booking_uuid = ls_entity-booking_uuid ]-booking_id OPTIONAL ) .

      ENDIF.



      GET TIME STAMP FIELD DATA(lv_ts).
      ls_booking-last_changed_at = lv_ts.
      ls_booking-local_last_changed_at = lv_ts.


      APPEND ls_booking TO lt_booking_update.

    ENDLOOP.

    IF lt_booking_update IS NOT INITIAL.
      cl_buffer=>gt_update_booking = lt_booking_update.

    ENDIF.





*importing&nbsp;parameter entities type table for update zi_booking_um_al
*Components  Mand. Update    Mand. Save  Readonly    Dynamic
*%cid_ref    type abp_behv_cid
*%is_draft   type abp_behv_flag
*booking_uuid    type sysuuid_x16
*parent_uuid type sysuuid_x16
*booking_id  type /dmo/booking_id
*local_last_changed_at   type timestampl
*customer_id type /dmo/customer_id
*last_changed_at type timestampl
*%control    [ control structure... ]

  ENDMETHOD.

  METHOD delete.

    DATA lt_booking_del TYPE TABLE OF zbooking_um_al.

    LOOP AT keys INTO DATA(wa_key).

      APPEND VALUE #( booking_uuid = wa_key-booking_uuid   )

      TO lt_booking_del.

    ENDLOOP.

    IF lt_booking_del IS NOT INITIAL.

      cl_buffer=>gt_booking_del = lt_booking_del.

    ENDIF.


  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Travel.
  ENDMETHOD.

  METHOD rba_Booksuppl.
  ENDMETHOD.

  METHOD cba_Booksuppl.
*    importing   entities_cba    type table for create zi_booking_um_al\_booksuppl   [ derived type... ]
*changing    mapped  type response for mapped early zi_travel_um_al  [ derived type... ]
*failed  type response for failed early zi_travel_um_al  [ derived type... ]
*reported    type response for reported early zi_travel_um_al    [ derived type... ]
    DATA: lt_bs TYPE TABLE OF zbooksuppl_um_al.
    DATA: ls_bs TYPE zbooksuppl_um_al.

    DATA: lt_mapp_bs  TYPE TABLE FOR MAPPED EARLY zi_booksuppl_um_al.
    DATA: ls_mapp_bs LIKE LINE OF lt_mapp_bs.

    LOOP AT entities_cba INTO DATA(wa_cba).

*    ls_bs-booking_uuid = wa_cba-booking_uuid.

      LOOP AT wa_cba-%target INTO DATA(wa_target).

        ls_bs = CORRESPONDING #( wa_target MAPPING FROM ENTITY ).


*      ls_bs-travel_uuid = VALUE #( lcl_buffer=>mt_booking_buffer[ booking_uuid = wa-booking_uuid ]-parent_uuid OPTIONAL ).
*
*      " 2. If it's blank, check the Active Database (The Warehouse)
*      IF ls_bs-travel_uuid IS INITIAL.
*        SELECT SINGLE parent_uuid FROM zbooking_um_a
*               WHERE booking_uuid = @wa-booking_uuid
*               INTO @ls_bs-travel_uuid.
*      ENDIF.
*
*      " 3. If it's STILL blank, it must be an unsaved Draft! Check the Draft Database
*      IF ls_bs-travel_uuid IS INITIAL.
*        SELECT SINGLE parent_uuid FROM zbooking_um_ad
*               WHERE booking_uuid = @wa-booking_uuid
*               INTO @ls_bs-travel_uuid.
*      ENDIF.

        APPEND ls_bs TO lt_bs.

        ls_mapp_bs-%cid = wa_cba-%cid_ref.
        ls_mapp_bs-%is_draft = wa_cba-%is_draft.
        ls_mapp_bs-%key = wa_target-%key.
        APPEND ls_mapp_bs TO lt_mapp_bs.

      ENDLOOP.



    ENDLOOP.

    IF lt_mapp_bs IS NOT INITIAL.
      APPEND LINES OF lt_mapp_bs TO mapped-zi_booksuppl_um_al.

    ENDIF.

    IF lt_bs IS NOT INITIAL.

      APPEND LINES OF lt_bs TO cl_buffer=>gt_bs_cba.

    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_TRAVEL_UM_AL DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_TRAVEL_UM_AL IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
    IF cl_buffer=>gt_create_travel IS NOT INITIAL.
      INSERT ztravel_um_al FROM TABLE @cl_buffer=>gt_create_travel..
    ENDIF.

    IF cl_buffer=>gt_booking_create IS NOT INITIAL.
      INSERT  zbooking_um_al FROM TABLE @cl_buffer=>gt_booking_create.
    ENDIF.

    IF cl_buffer=>gt_update_booking IS NOT INITIAL.
      UPDATE zbooking_um_al FROM TABLE @cl_buffer=>gt_update_booking.

    ENDIF.

    IF cl_buffer=>gt_update_travel IS NOT INITIAL.
      UPDATE ztravel_um_al FROM TABLE @cl_buffer=>gt_update_travel.
    ENDIF.

    IF cl_buffer=>gt_travel_del IS NOT INITIAL.
      DELETE ztravel_um_al FROM TABLE @cl_buffer=>gt_travel_del.

    ENDIF.

    IF cl_buffer=>gt_booking_del IS NOT INITIAL.
      DELETE zbooking_um_al FROM TABLE @cl_buffer=>gt_booking_del.

    ENDIF.


    IF cl_buffer=>gt_bs_cba IS NOT INITIAL.

      INSERT zbooksuppl_um_al FROM TABLE  @cl_buffer=>gt_bs_cba.

    ENDIF.



  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
