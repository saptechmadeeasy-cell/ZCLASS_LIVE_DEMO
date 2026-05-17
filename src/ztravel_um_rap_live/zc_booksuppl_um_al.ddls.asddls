@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection for Booksuppl'
@Metadata.ignorePropagatedAnnotations: false
@UI.headerInfo: {
    typeName: 'Booking Supplement',
    typeNamePlural: 'Booking Supplements'   
  
}

define view entity ZC_BOOKSUPPL_UM_AL
  as projection on ZI_BOOKSUPPL_UM_AL
{

      @UI.facet: [ { id: 'BookingSupplementsDetails',
                     type: #IDENTIFICATION_REFERENCE,
                     label: 'Booking Supplements Details',
                     position: 10 } ]



      //@UI.hidden: true
      @UI.identification: [{ position: 5 , label: 'Booking suppl UUID' }]  // Shows in the Create/Edit form
      @UI.lineItem: [{ position: 5 , label: 'Booking suppl UUID' }] // Shows in the Create/Edit form
  key BooksupplUuid,
      @UI.identification: [{ position: 10 , label: 'travel UUID' }]
      @UI.lineItem: [{ position: 10 , label: 'travel UUID' }]
      TravelUuid,
      @UI.identification: [{ position: 20 , label: 'Booking Uuid' }]
      @UI.lineItem: [{ position: 20 , label: 'Booking Uuid' }]
      BookingUuid,

      @UI.identification: [{ position: 30 , label: 'Supplement Id' }]
      @UI.lineItem: [{ position: 30 , label: 'Supplement Id' }]
      SupplementId,

      @UI.identification: [{ position: 40 , label: 'Price' }]
      @UI.lineItem: [{ position: 40 , label: 'Price' }]
      Price,
      @UI.identification: [{ position: 50 , label: 'CurrencyCode' }]
      @UI.lineItem: [{ position: 50 , label: 'CurrencyCode' }]
      CurrencyCode,

      LocalLastChangedAt,
      /* Associations */
      _Booking : redirected to parent ZC_BOOKING_UM_AL,
      _Travel  : redirected to ZC_TRAVEL_UM_AL
}
