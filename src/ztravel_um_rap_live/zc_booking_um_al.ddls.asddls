@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Projection'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZC_BOOKING_UM_AL
  as projection on ZI_BOOKING_UM_AL
{
      // This creates the "Form" layout when you click 'Create' or 'Edit' on a Booking
      @UI.facet: [ { id: 'BookingDetails',
                     type: #IDENTIFICATION_REFERENCE,
                     label: 'Booking Info',
                     position: 10 },
                     
                      { id: 'BookingSupplTab', type: #LINEITEM_REFERENCE, label: 'Booking Supplements', 
                      position: 20, targetElement: '_Booksuppl' } ]

      @UI.lineItem: [{ position: 2, label: 'Booking UUID' }]        // Shows as Column 1 in the Table
      @UI.identification: [{ position: 2, label: 'Booking UUID' }] // Shows in the Create/Edit form

  key booking_uuid,

      //    @UI.hidden: true
      @UI.lineItem: [{ position: 5 , label: 'travel UUID'}]        // Shows as Column 1 in the Table
      @UI.identification: [{ position: 5 , label: 'travel UUID' }]  // Shows in the Create/Edit form
      parent_uuid,

      @UI.lineItem: [{ position: 10 , label: 'Boooking ID'}]        // Shows as Column 1 in the Table
      @UI.identification: [{ position: 10 , label: 'Boooking ID'}]  // Shows in the Create/Edit form
      booking_id,

      @UI.lineItem: [{ position: 20, label: 'Local Last changed At' }]        // Shows as Column 2
      @UI.identification: [{ position: 20, label: 'Local Last changed At' }]
      local_last_changed_at,

      @UI.hidden: true
      last_changed_at,

      @UI.lineItem: [{ position: 30, label: 'Customer Id' }]        // Shows as Column 2
      @UI.identification: [{ position: 30, label: 'Customer ID' }]
      customer_id,

      /* Associations */
      _Travel : redirected to parent ZC_TRAVEL_UM_AL,
      _Booksuppl : redirected to composition child ZC_BOOKSUPPL_UM_AL
      
}
