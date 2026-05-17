CLASS zcl_sort_transform_demo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_sadl_exit_sort_transform.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SORT_TRANSFORM_DEMO IMPLEMENTATION.


  METHOD if_sadl_exit_sort_transform~map_element.

    CASE iv_entity.

      WHEN 'ZC_RAP_PK_TRAVEL'.
      IF    iv_element = 'REVIEW_SCORE' .
      "IF REVIEW_SCORE is requested to sort
      "and review score corresponds to any database field then we can use that for sort
      APPEND VALUE #( name = 'CUSTOMERID' REVERSE = ABAP_FALSE  )
                TO et_sort_elements. "when reverse is set to false

     ENDIF .
*     append  value #( name = 'REVIEW_SCORE' ) to et_sort_elements. "++NOT_POSSIBLE

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
