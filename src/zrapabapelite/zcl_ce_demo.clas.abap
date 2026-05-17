CLASS zcl_ce_demo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_rap_query_provider.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CE_DEMO IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    DATA: lt_reviews TYPE TABLE OF zce_agency_review.
*    "implement this method:
*    IF io_request->is_data_requested( ) .
**        DATA(lt_filters) = io_request->get_filter( )->get_as_ranges( ).
*
*      " 1. Acknowledge the Paging Request (Mandatory for OData V4!)
*      DATA(lo_paging) = io_request->get_paging( ).
*      DATA(lv_offset) = lo_paging->get_offset( ).
*      DATA(lv_top)    = lo_paging->get_page_size( ).
*
*      " 2. Extract the AgencyID Filter (Mandatory so you fetch the right data!)
*      " You need to uncomment and use this block!
*      DATA(lt_filters) = io_request->get_filter( )->get_as_ranges( ).
*      IF lt_filters IS NOT INITIAL.
*        DATA(range) = VALUE #( lt_filters[ 1 ]-range OPTIONAL ).
*      ENDIF.
*      "custom logic
*
*      lt_reviews = VALUE #(
*                             ( AgencyId = '70001'
*                             ReviewScore = 5
*                             ReviewText = 'Good'
*                             LastUpdated = cl_abap_context_info=>get_system_date( )
*                             )
*
*                             ( AgencyId = '70002'
*                             ReviewScore = 4
*                             ReviewText = 'Average'
*                             LastUpdated = cl_abap_context_info=>get_system_date( )
*                             )
*
*                             ( AgencyId = '70003'
*                             ReviewScore = 3
*                             ReviewText = 'Average'
*                             LastUpdated = cl_abap_context_info=>get_system_date( )
*                             )
*                             ).

*    ENDIF.
*
**    DELETE lt_reviews WHERE agencyid NOT IN range.
*
*    io_response->set_data(  lt_reviews ).
*          IF io_request->is_total_numb_of_rec_requested( ).
*        DATA(total_rl) = CONV int8( lines(  lt_reviews ) ).
*        TRY.
*            io_response->set_total_number_of_records( iv_total_number_of_records = total_rl ).
*          CATCH cx_rap_query_response_set_twic.
*
*        ENDTRY.
*        endif.

    IF io_request->is_data_requested( ) .
      DATA(lt_filters) = io_request->get_filter( )->get_as_ranges( ).

      " 1. Acknowledge the Paging Request (Mandatory for OData V4!)
      DATA(lo_paging) = io_request->get_paging( ).
      DATA(lv_offset) = lo_paging->get_offset( ).
      DATA(lv_top)    = lo_paging->get_page_size( ).
      IF lt_filters IS NOT INITIAL.
        DATA(range) = VALUE #( lt_filters[ 1 ]-range OPTIONAL ).
      ENDIF.
    ELSE.
      EXIT.
    ENDIF.

    READ TABLE range INTO DATA(ls_range) INDEX 1.
    DATA(lv_agency_id) = 1."ls_range-low. "hard coded becaue api don't have many values
    " 1. Hardcode the Target URL (Using a free, open mock API!)
    " We will pass the AgencyID to get 'comments' (reviews) specifically for that agency
    DATA(lv_url) = |https://jsonplaceholder.typicode.com/comments?postId={ lv_agency_id }|.

    TRY.
        " 2. Create the HTTP Client directly from the URL
        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination(
                                 cl_http_destination_provider=>create_by_url( lv_url )
                               ).
        " 3. Prepare and Execute the GET Request (No API Keys needed!)
        DATA(lo_request)  = lo_http_client->get_http_request( ).
        DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>get ).

        " 4. Extract the JSON
        IF lo_response->get_status( )-code = 200. " 200 means 'Success'
          DATA(lv_json_string) = lo_response->get_text( ).
        ELSE.
          " If the API is down, we just return an empty string
          lv_json_string = ''.
        ENDIF.
      CATCH cx_root INTO DATA(lx_error).
        " Handle connection exceptions gracefully
    ENDTRY.
    " 1. Create a temporary structure that matches the exact names in the JSON
    TYPES: BEGIN OF ty_json_comment,
             postId TYPE string,
             id     TYPE i,
             name   TYPE string,
             email  TYPE string,
             body   TYPE string, " This holds the actual review text!
           END OF ty_json_comment.

    DATA: lt_json_comments TYPE TABLE OF ty_json_comment.

    " 2. The Magic Translator: Deserialize the JSON string into the ABAP table
    /ui2/cl_json=>deserialize(
      EXPORTING
        json = lv_json_string
      CHANGING
        data = lt_json_comments
    ).
    DATA(lv_id) = 1.
    " 3. Loop through the translated data and fill your official RAP table
    LOOP AT lt_json_comments INTO DATA(ls_comment).
      lv_id += 1.  "LV_ID = LV_ID + 1.
      APPEND VALUE #(
        AgencyID    = ls_range-low"lv_agency_id          " From your RAP filter
        reviewid = lv_id
        ReviewScore = 10 / lv_id                     " Mocking a 4-star score for the demo
        ReviewText  = ls_comment-body       " The comment from the API
        LastUpdated = cl_abap_context_info=>get_system_date( )
      ) TO lt_reviews.
*      exit.
    ENDLOOP.
    TRY.
        io_response->set_data( it_data = lt_reviews ).
      CATCH cx_rap_query_response_set_twic INTO DATA(lo_resp).
        DATA(error_text) = lo_resp->get_text( ).
    ENDTRY.
    IF io_request->is_total_numb_of_rec_requested( ).
      DATA(total_rl) = CONV int8( lines(  lt_reviews ) ).
      TRY.
          io_response->set_total_number_of_records( iv_total_number_of_records = total_rl ).
        CATCH cx_rap_query_response_set_twic.
      ENDTRY.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
