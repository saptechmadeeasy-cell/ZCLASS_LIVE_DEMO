define root view entity ZI_TRAVEL_UM_AL
  as select from ztravel_UM_aL
  composition [0..*] of ZI_Booking_UM_AL as _Booking
{


 @UI.facet: [
        { id: 'TravelDetails', type: #IDENTIFICATION_REFERENCE, label: 'Travel Info', position: 10 },
        { id: 'BookingTab', type: #LINEITEM_REFERENCE, label: 'Bookings', position: 20, targetElement: '_Booking' }
    ]
  key travel_uuid,
  travel_id,
  description,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at, // <--- Add this to your table and view

  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at,
  _Booking // Exposed association
}
