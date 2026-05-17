@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZC_BOOKING_AL'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_BOOKING_AL 

as projection on ZI_BOOKING_AL
{



  @UI.facet: [ {
    label: 'Booking Detail', 
    id: 'BookingDetail', 
    purpose: #STANDARD, 
    position: 10 , 
    type: #IDENTIFICATION_REFERENCE
  }]
  




    @UI.lineItem: [{ position: 10 ,label : 'Booking UUID' }]
    key BookingUuid,
    @UI.lineItem: [{ position: 10 ,label : 'Parent Travel UUID' }]
    ParentUuid,
    @UI.lineItem: [{ position: 10 }] // Shows in the List Report
    @UI.identification: [{ position: 10 }] // Shows in the Object Page
    BookingId,
    @UI.lineItem: [{ position: 20 }] // Shows in the List Report
    @UI.identification: [{ position: 20 }] // Shows in the Object Page
    CustomerId,
    LocalLastChangedAt,
    LastChangedAt,
    /* Associations */
    _travel : redirected to parent ZC_TRAVEL_AL
}
