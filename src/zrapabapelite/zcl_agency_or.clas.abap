CLASS zcl_agency_or DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_AGENCY_OR IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA: lt_travel_data TYPE TABLE OF zc_rap_pk_travel.
    lt_travel_data = CORRESPONDING #( it_original_data ).

    LOOP AT lt_travel_data ASSIGNING FIELD-SYMBOL(<fs_travel_data>).
      <fs_travel_data>-agency_overall_rating = 5.
    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( lt_travel_data ).

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    CASE iv_entity.
      WHEN 'IV_ENTITY'.


    ENDCASE.

  ENDMETHOD.
ENDCLASS.
