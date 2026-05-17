CLASS zcl_eml_demo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_EML_DEMO IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.



********************************begin  of update**************************************************

    DATA: lv_uuid_c36  TYPE sysuuid_c36 .

    DATA lv_uuid_raw TYPE sysuuid_x16.
    lv_uuid_c36 = '167a3418-9355-1fd1-8bfa-23487d36cf8f'.

    lv_uuid_c36  = to_upper(  lv_uuid_c36 ).

    TRY.
        cl_system_uuid=>convert_uuid_c36_static(
        EXPORTING
        uuid = lv_uuid_c36
        IMPORTING
        uuid_x16 = DATA(lv_uuid_x16) ).

      CATCH cx_uuid_error INTO DATA(lx_uuid).
        out->write( lx_uuid->get_text( ) ).
        RETURN.
    ENDTRY.
*

      DATA: lv_Buuid_c36  TYPE sysuuid_c36 .


    lv_Buuid_c36 = '167a3418-9355-1fd1-8bfa-23487d370f8f'.

    lv_Buuid_c36  = to_upper(  lv_Buuid_c36 ).

    TRY.
        cl_system_uuid=>convert_uuid_c36_static(
        EXPORTING
        uuid = lv_Buuid_c36
        IMPORTING
        uuid_x16 = DATA(lv_Buuid_x16) ).

      CATCH cx_uuid_error INTO DATA(lx_uuid1).
        out->write( lx_uuid1->get_text( ) ).
        RETURN.
    ENDTRY.







*    lv_uuid_raw = lv_uuid_x16.
*    lv_uuid_raw = to_upper(  '167a341893551fd18bfa23487d36cf8f' ).

*    lv_uuid_raw = '167A341893551FD18BFA23487D36CF8F'.
*    167A341893551FD18BFA23487D36CF8F





    MODIFY ENTITIES OF ZR_Travel_AL
      ENTITY travel
      UPDATE SET FIELDS WITH VALUE #( (
           TravelUuid = lv_uuid_x16
           TravelId = '200'
           Description = 'Test test test'
            %is_draft     = if_abap_behv=>mk-off "active

        ) )

      ENTITY
      Booking
        UPDATE SET FIELDS WITH VALUE #( (
*           ParentUuid = lv_uuid_raw
           BookingUuid =  lv_Buuid_x16 "'167A341893551FD18BFA23487D36CF8F'
            %is_draft     = if_abap_behv=>mk-off "active
           CustomerId = '200'
        ) )
      MAPPED   DATA(ls_mapped)
      FAILED   DATA(ls_failed)
      REPORTED DATA(ls_reported).

    " Check if creation worked before committing
    IF ls_failed IS INITIAL.
      COMMIT ENTITIES.
      out->write( ' Records updated Successfully' ).
    ELSE.
      out->write( 'Failed to update records' ).
    ENDIF.

    COMMIT ENTITIES.


*UPDATING CHILD
*
*FOR UPDATING CHILD – YOU CAN USE BELOW SYNTAX:
*
*DATA lv_uuid_x16 TYPE sysuuid_x16.
*lv_uuid_x16 = '167A341893551FD18BB5C4C3B03A8F8C'.
*
*    MODIFY ENTITIES OF ZR_Travel_AL
*      ENTITY Booking
*        update SET FIELDS WITH VALUE #( (
*           BookingUuid = lv_uuid_x16
*            %is_draft     = if_abap_behv=>mk-off "active
**            travelid     = '00111'
*            CustomerId   = '120'
*        ) )
*
*      MAPPED   DATA(ls_mapped)
*      FAILED   DATA(ls_failed)
*      REPORTED DATA(ls_reported).
*
*    " Check if creation worked before committing
*    IF ls_failed IS INITIAL.
*      COMMIT ENTITIES.
*      out->write( ' Records Created Successfully' ).
*    ELSE.
*      out->write( 'Failed to create records' ).
*    ENDIF.
*    COMMIT ENTITIES.
*
*
*UPDATING PARENT AND CHILD TOGETHER
*    DATA lv_uuid_raw_P TYPE sysuuid_x16.
*    DATA lv_uuid_raw_C TYPE sysuuid_x16.
*
*    lv_uuid_raw_P = '167A341893551FD18BB761B0D485CF8C'.
*    lv_uuid_raw_C  = '167A341893551FD18BB761B0D485EF8C'.
*
*    MODIFY ENTITIES OF ZR_Travel_AL
*      ENTITY Travel
*        UPDATE SET FIELDS WITH VALUE #( (
*           TravelUuid = lv_uuid_raw_P
*            %is_draft     = if_abap_behv=>mk-off "active
*           Description   = 'mumbai to goa BY FLIGHT'
*        ) )
*
*        ENTITY Booking
*           UPDATE SET FIELDS WITH VALUE #( (
*           BookingUuid = lv_uuid_raw_C
*            %is_draft     = if_abap_behv=>mk-off "active
*            CustomerId   = '115'
*        ) )
*
*      MAPPED   DATA(ls_mapped)
*      FAILED   DATA(ls_failed)
*      REPORTED DATA(ls_reported).
*
*    " Check if creation worked before committing
*    IF ls_failed IS INITIAL.
*      COMMIT ENTITIES.
*      out->write( ' Records Created Successfully' ).
*    ELSE.
*      out->write( 'Failed to create records' ).
*    ENDIF.

********************************end of update**************************************************









    "

** DEEP CREATE(NEW SYNTAX – 1ST VARIANT)
*    MODIFY ENTITIES OF zr_travel_al
*      ENTITY Travel
*        CREATE FIELDS ( TravelId description )
*          WITH VALUE #( ( %cid        = 'MyPARENT_1'
*                          travelid   = '00000100'
*                          description = 'Trip to Pune from Patna' ) )
*
*        CREATE BY \_Booking FIELDS ( bookingid CustomerId   )
*          WITH VALUE #(
*            " First Item
*            ( %cid_ref  = 'MyPARENT_1'
*              %target   = VALUE #( ( %cid        = 'MyITEM_1'
*                                     bookingid  = '0001'
*                                     CustomerId = '110'
*                                      )
*            " Second Item
*                                   ( %cid        = 'MyITEM_2'
*                                     bookingid  = '0002'
*                                     CustomerId = '120'
*                                      ) ) )
*          )
*      MAPPED   DATA(ls_mapped)
*      FAILED   DATA(ls_failed)
*      REPORTED DATA(ls_reported).    " CRITICAL: For persistent tables, you must commit the work
*
*
*    IF VALUE #( ls_failed-travel[ 1 ]-%fail-cause OPTIONAL ) IS INITIAL.
*      COMMIT ENTITIES.
*      out->write( 'Travel and Bookings got suucessfully created'
*      ).
*    ENDIF.




**DEEP CREATE(NEW SYNTAX – 2ND VARIANT)
*    MODIFY ENTITIES OF zr_travel_al
*      ENTITY Travel
*        CREATE SET FIELDS WITH VALUE #( (
*            %cid          = 'MyROOT_1'
*            %is_draft     = if_abap_behv=>mk-off " Draft Parent
*            travelid     = '00000140'
*            description   = 'Trip to Pune from bangalore'
*        ) )
*
*        CREATE BY \_Booking SET FIELDS WITH VALUE #( (
*            %cid_ref      = 'MyROOT_1'
*            %is_draft     = if_abap_behv=>mk-off " Must match parent
*            %target       = VALUE #( (
*                %cid      = 'Item1'
*                %is_draft = if_abap_behv=>mk-off " Explicitly set for child
*                bookingid = '01'
*                CustomerId = '140' )
*
*                (
*                %cid      = 'Item2'
*                %is_draft = if_abap_behv=>mk-off " Explicitly set for child
*                bookingid = '02'
*                CustomerId = '150' )
*            )
*        ) )
*      MAPPED   DATA(ls_mapped)
*      FAILED   DATA(ls_failed)
*      REPORTED DATA(ls_reported).
*
*    " Check if creation worked before committing
*    IF ls_failed IS INITIAL.
*    out->write( 'success' ).
*      COMMIT ENTITIES.
*
*      endif.







*    DATA lv_uuid_c36 TYPE sysuuid_c36.
*    DATA lv_uuid_x16 TYPE sysuuid_x16.
*
*    lv_uuid_c36 =  to_upper( '167a3418-9355-1Fd1-8BB5-C4C3B03A6F8C' ).
*
*    TRY.
*        cl_system_uuid=>convert_uuid_c36_static(
*          EXPORTING
*            uuid     = lv_uuid_c36
*          IMPORTING
*            uuid_x16 = lv_uuid_x16 ).
*
*      CATCH cx_uuid_error INTO DATA(lx_uuid).
*        out->write( lx_uuid->get_text( ) ).
*        RETURN.
*    ENDTRY.
*
*    out->write( lv_uuid_x16 ).

*
*    DATA lv_uuid_raw_P TYPE sysuuid_x16.
*    DATA lv_uuid_raw_C TYPE sysuuid_x16.
*
*    lv_uuid_raw_P = '167A341893551FD18BB761B0D485CF8C'.
*    lv_uuid_raw_C  = '167A341893551FD18BB761B0D485EF8C'.
*
*    MODIFY ENTITIES OF ZR_Travel_AL
*      ENTITY Travel
*        UPDATE SET FIELDS WITH VALUE #( (
*           TravelUuid = lv_uuid_raw_P
*            %is_draft     = if_abap_behv=>mk-off "active
*           Description   = 'mumbai to goa BY FLIGHT'
*        ) )
*
*        ENTITY Booking
*           UPDATE SET FIELDS WITH VALUE #( (
*           BookingUuid = lv_uuid_raw_C
*            %is_draft     = if_abap_behv=>mk-off "active
*            CustomerId   = '115'
*        ) )
*
*      MAPPED   DATA(ls_mapped)
*      FAILED   DATA(ls_failed)
*      REPORTED DATA(ls_reported).
*
*    " Check if creation worked before committing
*    IF ls_failed IS INITIAL.
*      COMMIT ENTITIES.
*      out->write( ' Records Created Successfully' ).
*    ELSE.
*      out->write( 'Failed to create records' ).
*    ENDIF.

*    COMMIT ENTITIES.



*      MODIFY ENTITIES OF ZR_Travel_AL
*      ENTITY Travel
*        CREATE FIELDS ( TravelId description )
*          WITH VALUE #( ( %cid        = 'MyROOT_1'
*                          travelid   = '00000101'
*                          description = 'Trip to Pune' ) )
*
*        CREATE BY \_Booking FIELDS ( bookingid  )
*          WITH VALUE #(
*            " First Item
*            ( %cid_ref  = 'MyROOT_1'
*              %target   = VALUE #( ( %cid        = 'MyITEM_1'
*                                     bookingid  = '0001'
*                                      )
*            " Second Item
*                                   ( %cid        = 'MyITEM_2'
*                                     bookingid  = '0002'
*                                      ) ) )
*          )
*      MAPPED   DATA(ls_mapped)
*      FAILED   DATA(ls_failed)
*      REPORTED DATA(ls_reported).    " CRITICAL: For persistent tables, you must commit the work
*    IF value #( ls_failed-travel[ 1 ]-%fail-cause optIONAL ) IS INITIAL.
*      COMMIT ENTITIES.
*  ENDIF.




*  DELETING ACTIVE RECORD
*  " 1. Identify the record to delete
*MODIFY ENTITIES OF zr_RAP_PK_TRAVEL
*  ENTITY zr_rap_pk_travel
*    DELETE FROM VALUE #( ( %is_draft   = if_abap_behv=>mk-on " Delete from Active table
*                           travelId = '2' )
**                           ( %is_draft   = if_abap_behv=>mk-off " Delete from Active table
**                           travelId = '1007' )
**                           ( %is_draft   = if_abap_behv=>mk-off " Delete from Active table
**                           travelId = '1008' )
**                           ( %is_draft   = if_abap_behv=>mk-off " Delete from Active table
**                           travelId = '1002' )
*)
*  FAILED DATA(lt_failed)
*  REPORTED DATA(lt_reported).
*
*" 2. Finalize the deletion
*IF lt_failed IS INITIAL.
*    COMMIT ENTITIES.
*    out->write( 'Record Deleted Successfully!' ).
*ELSE.
*    out->write( 'Delete Failed!' ).
*    " Show the reason (e.g., record already locked by another user)
*    out->write( lt_failed-zr_rap_pk_travel[ 1 ]-%fail-cause ).
*ENDIF.
*
**DISCARDING THE DRAFT
**YOU CAN NOT DELETE THE DRAFT VALUE BUT YOU CAN DISCARD.
*  MODIFY ENTITIES OF zr_RAP_PK_TRAVEL
*  ENTITY zr_RAP_PK_TRAVEL
*    EXECUTE Discard FROM VALUE #( (
*                                    travelId  = '2' ) )
*  FAILED DATA(lt_failed_discard)
*  REPORTED DATA(lt_reported_discard).
*
*  IF lt_failed_discard IS INITIAL.
*    COMMIT ENTITIES.
*    out->write( 'Record Deleted Successfully!' ).
*ELSE.
*    out->write( 'Delete Failed!' ).
*    " Show the reason (e.g., record already locked by another user)
*    out->write( VALUE #( lt_failed_discard-zr_rap_pk_travel[ 1 ]-%fail-cause  OPTIONAL ) ).
*ENDIF.




*  MODIFY ENTITIES OF ZR_rap_pk_travel
*  ENTITY zr_rap_pk_travel
*    UPDATE FIELDS (
*
*             AgencyID
*             CustomerID
*             Description
*             OverallStatus
*           )
*    WITH VALUE #( (
**        %cid          = 'abc-001'
*        %is_draft     = if_abap_behv=>mk-off
*        TravelID      = '001006'
*        AgencyID      = '070015'
*        CustomerID    = '000001'
*        Description   = 'First Test Trip'
*        OverallStatus = 'O'
*    )
*       (
*
**       %cid          = 'abc-002'
*        %is_draft     = if_abap_behv=>mk-off
*        TravelID      = '001007'
*        AgencyID      = '070015'
*        CustomerID    = '000001'
*        Description   = '2ND UPDATE VARIANT'
*        OverallStatus = 'O'
*    )
*    )
*  MAPPED   DATA(lt_mapped)
*  FAILED   DATA(lt_failed_info)
*  REPORTED DATA(lt_reported).
*
*
*COMMIT ENTITIES.
*  EML UPDATE – 3ND VARIANT

*MODIFY ENTITIES OF zr_rap_pk_travel
*  ENTITY zr_rap_pk_travel
*    UPDATE SET FIELDS WITH VALUE #( (
*        TravelID      = '1001'
*        %is_draft     = if_abap_behv=>mk-off
*        AgencyID      = '070015'
*        CustomerID    = '000001'
*        Description   = 'First Test Trip'
*        OverallStatus = 'O'
*    ) )
*  MAPPED   DATA(lt_mapped)
*  FAILED   DATA(lt_failed_info)
*  REPORTED DATA(lt_reported).
*
*     IF lt_failed_info-zr_rap_pk_travel IS NOT INITIAL.
*        out->write( 'record could not BE UPDATED ' ).
*        out->write( lt_failed_info-zr_rap_pk_travel[ 1 ]-%fail ).
*
*    ELSE .
*    COMMIT ENTITIES.
*      out->write( 'SUCCESSFULLY  UPDATE'  ).
*      .
*    ENDIF.



*  EML: UPDATE(1ST VARIANT)
*" 1. Prepare the Update Table
*" Note: You need the HEX UUIDs of the records you created earlier
*TYPES: TT_UPDATE TYPE TABLE FOR UPDATE zr_rap_pk_travel\\zr_rap_pk_travel.
*DATA(lt_update_data) = VALUE TT_UPDATE( (
*    %is_draft     = if_abap_behv=>mk-off
*    TravelID  = '1003'
*    Description   = 'Updated Description via EML'
*    OverallStatus = 'A'
*    %control = VALUE #(
*      Description   = if_abap_behv=>mk-on
*      OverallStatus = if_abap_behv=>mk-on
*    )
*) ).
*
*" 2. Execute the MODIFY
*MODIFY ENTITIES OF zr_rap_pk_travel
*  ENTITY zr_rap_pk_travel
*    UPDATE FROM lt_update_data
*  FAILED DATA(lt_failed)
*  REPORTED DATA(lt_reported).
*
*" 3. Check and Commit
*IF lt_failed IS INITIAL.
*    COMMIT ENTITIES.
*    out->write( 'Update Successful!' ).
*ELSE.
*    out->write( 'Update Failed!' ).
*    LOOP AT lt_reported-zr_rap_pk_travel INTO DATA(ls_reported).
*        out->write( cl_message_helper=>get_text_for_message( ls_reported-%msg ) ).
*    ENDLOOP.
*ENDIF.



*
*    MODIFY ENTITIES OF zr_rap_pk_travel
*    ENTITY zr_rap_pk_travel
*
**  CREATE FROM
** CREATE FIELDS WITH VALUE
*      CREATE SET FIELDS WITH VALUE #( (
*          %cid          = 'abc-001'
*          %is_draft     = if_abap_behv=>mk-off
*          TravelID      = '001008'
*          AgencyID      = '070015'
*          CustomerID    = '000001'
*          Description   = 'First Test Trip'
*          OverallStatus = 'O'
*      ) )
*    MAPPED   DATA(lt_mapped)
*    FAILED   DATA(lt_failed_info)
*    REPORTED DATA(lt_reported).
*
*    IF lt_failed_info-zr_rap_pk_travel IS NOT INITIAL.
*      out->write( 'record could not created' ).
*      out->write( lt_failed_info-zr_rap_pk_travel[ 1 ]-%fail ).
*
*    ELSE .
*      COMMIT ENTITIES.
*      out->write( 'SUCCESSFULLY CREATED' ).
*      .
*    ENDIF.



*  EML: CREATE(2ND VARIANT)" Execute the CREATE using the FIELDS ( Variation 2 ) syntax

*MODIFY ENTITIES OF ZR_rap_pk_travel
*  ENTITY zr_rap_pk_travel
*    CREATE FIELDS (
*             TravelID
*             AgencyID
*             CustomerID
*             Description
*             OverallStatus
*           )
*    WITH VALUE #( (
*        %cid          = 'abc-001'
*        %is_draft     = if_abap_behv=>mk-off
*        TravelID      = '001006'
*        AgencyID      = '070015'
*        CustomerID    = '000001'
*        Description   = 'First Test Trip'
*        OverallStatus = 'O'
*    )
*       (  %cid          = 'abc-002'
*        %is_draft     = if_abap_behv=>mk-off
*        TravelID      = '001007'
*        AgencyID      = '070015'
*        CustomerID    = '000001'
*        Description   = 'First Test Trip'
*        OverallStatus = 'O'
*    )
*    )
*  MAPPED   DATA(lt_mapped)
*  FAILED   DATA(lt_failed_info)
*  REPORTED DATA(lt_reported).
    " Handling the response
*IF lt_failed_info-zr_rap_pk_travel IS NOT INITIAL.
*    out->write( 'Record could not be created' ).
*    " Accessing the failure reason
*    out->write( lt_failed_info-zr_rap_pk_travel[ 1 ]-%fail ).
*ELSE.
*    COMMIT ENTITIES.
*    out->write( 'SUCCESSFULLY CREATED' ).
*ENDIF.











    "creating the record with EML


**  EML: CREATING RECORDS(1st Variant)
**Define Derive type
*    TYPES:  tt_create TYPE TABLE FOR CREATE zr_rap_pk_travel\\zr_rap_pk_travel.
*
*    " 1. Prepare the Data for Multiple Records

*    DATA(lt_create_data) = VALUE tt_create( (
*        %cid = 'abc-001' "MANDATORY TO PASS
*        %is_draft = if_abap_behv=>mk-off        " Direct to Active Table
*        TravelID  = '001001'                  " Manually providing ID
*        AgencyID  = '070015'
*        CustomerID = '000001'
*        Description = 'First Test Trip'
*        OverallStatus = 'O'                    " Open
*        %control-TravelID      = if_abap_behv=>mk-on
*        %control-AgencyID      = if_abap_behv=>mk-on
*        %control-CustomerID    = if_abap_behv=>mk-on
*        %control-Description   = if_abap_behv=>mk-on
*        %control-OverallStatus = if_abap_behv=>mk-on
*      ) (
*        %is_draft = if_abap_behv=>mk-off
*          %cid = 'abc-002' "MANDATORY TO PASS
*        TravelID  = '001002'
*        AgencyID  = '070016'
*        CustomerID = '000002'
*        Description = 'Second Test Trip'
*        OverallStatus = 'A'                    " Accepted
*        %control-TravelID      = if_abap_behv=>mk-on
*        %control-AgencyID      = if_abap_behv=>mk-on
*        %control-CustomerID    = if_abap_behv=>mk-on
*        %control-Description   = if_abap_behv=>mk-on
*        %control-OverallStatus = if_abap_behv=>mk-on
*    ) ).

*    " 2. Execute the CREATE
*    MODIFY ENTITIES OF zr_rap_pk_travel
*      ENTITY zr_rap_pk_travel
*        CREATE FROM
*
*       VALUE #( (
*        %cid = 'abc-001' "MANDATORY TO PASS
*        %is_draft = if_abap_behv=>mk-off        " Direct to Active Table
*        TravelID  = '001003'                  " Manually providing ID
*        AgencyID  = '070015'
*        CustomerID = '000001'
*        Description = 'from pune to Delhi'
*        OverallStatus = 'O'                    " Open
*        %control-TravelID      = if_abap_behv=>mk-on
*        %control-AgencyID      = if_abap_behv=>mk-on
*        %control-CustomerID    = if_abap_behv=>mk-on
*        %control-Description   = if_abap_behv=>mk-on
*        %control-OverallStatus = if_abap_behv=>mk-on
*      ) (
*        %is_draft = if_abap_behv=>mk-off
*          %cid = 'abc-002' "MANDATORY TO PASS
*        TravelID  = '001004'
*        AgencyID  = '070016'
*        CustomerID = '000002'
*        Description =  'from pune to Bangalore'
*        OverallStatus = 'A'                    " Accepted
*        %control-TravelID      = if_abap_behv=>mk-on
*        %control-AgencyID      = if_abap_behv=>mk-on
*        %control-CustomerID    = if_abap_behv=>mk-on
*        %control-Description   = if_abap_behv=>mk-on
*        %control-OverallStatus = if_abap_behv=>mk-on
*    ) )
*
*
*      MAPPED DATA(lt_mapped) "MAPPED
*      FAILED DATA(lt_failed)
*      REPORTED DATA(lt_reported).
*
*
*    IF lt_failed-zr_rap_pk_travel IS INITIAL.
*      COMMIT ENTITIES.
*      ELSE.
*      LOOP AT lt_reported-zr_rap_pk_travel INTO DATA(LS_MSG).
*            OUT->WRITE( LS_MSG-%msg ).
*      ENDLOOP.
*    ENDIF.







    " 3. Check for Errors and Commit
*    IF lt_failed IS INITIAL.
*      COMMIT ENTITIES.
*      out->write( 'Records Created Successfully!' ).
*      " Show the Generated UUIDs from the MAPPED structure
*      out->write( lt_mapped-zrrappktravel ).
*    ELSE.
*      out->write( 'Creation Failed!' ).
*      LOOP AT lt_reported-zrrappktravel INTO DATA(ls_reported).
*        out->write( cl_message_helper=>get_text_for_message( ls_reported-%msg ) ).
*      ENDLOOP.
*    ENDIF.
**
*WITHOUT CREATING DERIVED TYPE WE CAN USE LIKE BELOW –
*  " 2. Execute the CREATE
*    MODIFY ENTITIES OF zr_rap_pk_travel
*      ENTITY ZrRapPkTravel
*        CREATE FROM
*        VALUE #( (
*        %cid = 'abc-001'
*        %is_draft = if_abap_behv=>mk-off        " Direct to Active Table
*        TravelID  = '001003'                  " Manually providing ID
*        AgencyID  = '070015'
*        CustomerID = '000001'
*        Description = 'First Test Trip'
*        OverallStatus = 'O'                    " Open
*        %control-TravelID      = if_abap_behv=>mk-on
*        %control-AgencyID      = if_abap_behv=>mk-on
*        %control-CustomerID    = if_abap_behv=>mk-on
*        %control-Description   = if_abap_behv=>mk-on
*        %control-OverallStatus = if_abap_behv=>mk-on
*      ) (
*        %is_draft = if_abap_behv=>mk-off
*          %cid = 'abc-002'
*        TravelID  = '001004'
*        AgencyID  = '070016'
*        CustomerID = '000002'
*        Description = 'Second Test Trip'
*        OverallStatus = 'A'                    " Accepted
*        %control-TravelID      = if_abap_behv=>mk-on
*        %control-AgencyID      = if_abap_behv=>mk-on
*        %control-CustomerID    = if_abap_behv=>mk-on
*        %control-Description   = if_abap_behv=>mk-on
*        %control-OverallStatus = if_abap_behv=>mk-on
*    ) )
*
**        lt_create_data
*      MAPPED DATA(lt_mapped)
*      FAILED DATA(lt_failed)
*      REPORTED DATA(lt_reported).
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*


*  "READ OPERATION
*  "READING THE DATA FROM TABLE WITH THE HELP OF BO
*
**  EML: READ RECORDS FROM RAP BO/TABLE
*
**READING THE DATA FROM ACTIVE TABLE
*
*data: lv_default type string.
*
*
*    READ ENTITIES OF ZR_RAP_PK_TRAVEL "BO
*      ENTITY zr_rap_pk_travel  "ENTITY
*        FIELDS ( AgencyID CustomerID  Description  FileName ) "WHICH FIELDS
*        WITH VALUE #( ( TravelID = '1'  %is_draft = if_abap_behv=>mk-on  ) ) " Non-existent Key
*        RESULT DATA(lt_travel_data). "YOUR DATA WILL COME HERE
*        FAILED DATA(lt_failed_info) "IF NO DATA FOUND THEN IT'LL SHOW HERE
*        REPORTED DATA(lt_reported_msg). "ERROR MESSAGE
*
*
*
*  IF LT_TRAVEL_DATA IS NOT INITIAL.
*
*  OUT->write( LT_TRAVEL_DATA
*
*  ).
*  ELSE.
*
*   OUT->WRITE( lt_reported_msg-zr_rap_pk_travel ).
*
*  OUT->WRITE( VALUE #( lt_reported_msg-zr_rap_pk_travel[ 1 ]-%msg  optional ) ).
*
*  ENDIF.
*
*
*
*
*      READ ENTITIES OF ZR_RAP_PK_TRAVEL "BO
*      ENTITY zr_rap_pk_travel  "ENTITY
*        FIELDS ( AgencyID CustomerID  Description  FileName ) "WHICH FIELDS
*        WITH VALUE #( ( TravelID = '2'  %is_draft = if_abap_behv=>mk-on  ) ) " Non-existent Key
*        RESULT lt_travel_data "YOUR DATA WILL COME HERE
*        FAILED lt_failed_info "IF NO DATA FOUND THEN IT'LL SHOW HERE
*        REPORTED lt_reported_msg. "ERROR MESSAGE
*
*          IF LT_TRAVEL_DATA IS NOT INITIAL.
*
*  OUT->write( LT_TRAVEL_DATA
*
*  ).
*  ELSE.
*
*   OUT->WRITE( lt_reported_msg-zr_rap_pk_travel ).
*
*  OUT->WRITE( VALUE #( lt_reported_msg-zr_rap_pk_travel[ 1 ]-%msg  optional ) ).
*
*  ENDIF.




*    " CHECKING THE IMPACT:
*    IF lt_failed_info-zrtravelmpk IS NOT INITIAL.
*      " 1. lt_travel_data will be EMPTY (Size = 0)
*      " 2. lt_failed_info-travel will have 1 row (Size = 1) containing Key '999'
*
*      out->write( |Read Failed for ID: { lt_failed_info-zrtravelmpk[ 1 ]-travelId  } | ).
*      out->write( lt_failed_info ).
*      out->write( lt_failed_info-zrtravelmpk[ 1 ]-travelId ) .
*      out->write( lt_travel_data ).
*
*    ELSE .
*      out->write( 'DATA FOUND' ).
*      .
*    ENDIF.


  ENDMETHOD.
ENDCLASS.
