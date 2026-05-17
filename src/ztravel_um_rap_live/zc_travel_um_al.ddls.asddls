@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel Projection'
@Metadata.ignorePropagatedAnnotations: true

// 1. Mandatory for the 'Create' button in the toolbar
@UI.headerInfo: {
    typeName: 'Travel',
    typeNamePlural: 'Travels',
    title: { type: #STANDARD, value: 'travel_id' }
}

define root view entity ZC_TRAVEL_UM_AL
  provider contract transactional_query
  as projection on ZI_TRAVEL_UM_AL
{
      // 2. Facets: This creates the "Tabs" on the Object Page
      @UI.facet: [
          { id: 'TravelDetails', type: #IDENTIFICATION_REFERENCE, label: 'Travel Info', position: 10 },
          { id: 'BookingTab', type: #LINEITEM_REFERENCE, label: 'Bookings', position: 20, targetElement: '_Booking' }
      ]

      @UI.lineItem: [{ position: 05 }] // Shows in the List Report
      @UI.identification: [{ position: 05 }] // Shows in the Object Page
  key travel_uuid,

      @UI.lineItem: [{ position: 10 }] // Shows in the List Report
      @UI.identification: [{ position: 10 }] // Shows in the Object Page
      travel_id,

      @UI.lineItem: [{ position: 20 }]
      @UI.identification: [{ position: 20 }]
      description,

      @UI.hidden: true
      local_last_changed_at,
      @UI.hidden: true
      last_changed_at,

      /* Associations */
      // 3. CRITICAL: Redirect to the CHILD PROJECTION (ZC_), not the base view (ZI_)
      _Booking : redirected to composition child ZC_BOOKING_UM_AL
}
