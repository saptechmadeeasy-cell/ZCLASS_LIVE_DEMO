@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZC_TRAVEL_AL'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_TRAVEL_AL provider contract transactional_query
as projection on ZR_TRAVEL_AL
{
//  @UI.facet: [ {
//    label: 'General Information', 
//    id: 'GeneralInfo', 
//    purpose: #STANDARD, 
//    position: 10 , 
//    type: #IDENTIFICATION_REFERENCE
//  },
//    {
//    label: 'Lineitem_infor', 
//    id: 'LineitemInfo', 
//    purpose: #STANDARD, 
//    position: 20 , 
//    type: #LINEITEM_REFERENCE,
//    targetElement: '_BOOKING'
//  } 
//  ]

 //@UI.identification: [{ position: 5 }] // Shows in the Object Page
   @UI.lineItem: [{ position: 10 ,label : 'Travel UUID' }] // Shows in the List Report
    key TravelUuid,
//    @UI.lineItem: [{ position: 10 }] // Shows in the List Report
//    @UI.identification: [{ position: 20 }] // Shows in the Object Page
//    @UI.lineItem: [{ position: 20 ,label : 'Travel UUID' }] // Shows in the List Report
    TravelId,
//    @UI.identification: [{ position: 30 }] // Shows in the Object Page
//    @UI.lineItem: [{ position: 30 ,label : 'Travel UUID' }] // Shows in the List Report
    Description,
//    @UI.identification: [{ position: 40 }] // Shows in the Object Page
//    @UI.lineItem: [{ position: 40 ,label : 'Travel UUID' }] // Shows in the List Report
    OverallStatus,
//    @UI.identification: [{ position: 50 }] // Shows in the Object Page
    LocalLastChangedAt,
    LastChangedAt,
    /* Associations */
    _BOOKING : redirected to composition child ZC_BOOKING_AL

}
