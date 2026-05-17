@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PROJECTION CDS'
@Metadata.ignorePropagatedAnnotations: false
@VDM.viewType: #CONSUMPTION
@UI.headerInfo: {
    typeName: 'Travel',
    typeNamePlural: 'Travels'
   }
@Search.searchable: true //HANA SEARCH OR TEXT SEARCH or fuzzy search
define view entity ZC_TRAVEL_RO
  as select from ZI_TRAVEL_RO
{

      @UI.facet: [ {
        label: 'General Information for Travel Id',
        id: 'GeneralInfo',
        purpose: #STANDARD,
        position: 10 ,
        type: #IDENTIFICATION_REFERENCE
      } ]

      @EndUserText.label: 'Agency Id by EndUserText'
      @UI.lineItem : [ { position: 10 , label: 'Agency id by UI'} ]
      @UI.identification: [ { position: 10 , label: 'Travel Id' }]
      @UI.selectionField: [{
          position: 10
      }]
  key TravelId,
      @UI.identification: [ { position: 20 , label: 'Agency Id' }]
      @UI.lineItem : [ { position: 20 , label: 'Agency Id' } ]
      @UI.selectionField: [{
       position: 20
      }]
      AgencyId,
      @UI.identification: [ { position: 30 , label: 'Customer Id' }]
      @UI.lineItem : [ { position: 30 , label: 'Customer Id' } ]
      @UI.selectionField: [{
       position: 30
      }]
      CustomerId,
      @UI.identification: [ { position: 40 , label: 'Begin Date' }]
      @UI.lineItem : [ { position: 40 , label: 'Begin Date' } ]
      BeginDate,
      @UI.lineItem : [ { position: 50 , label: 'End Date' } ]
      EndDate,
      @UI.lineItem : [ { position: 60 , label: 'Booking Fee' } ]
      @Semantics.amount.currencyCode: 'CurrencyCode'
      BookingFee,
      @UI.lineItem : [ { position: 70 , label: 'Currency Code' } ]
      CurrencyCode,
      @Search.fuzzinessThreshold: 0.70
      @Search.defaultSearchElement: true
      @UI.lineItem : [ { position: 80 , label: 'Description' } ]
      @UI.selectionField: [{
       position: 40
      }]
      Description,
      @Search.fuzzinessThreshold: 0.80
      @Search.defaultSearchElement: true
      @UI.lineItem : [ { position: 90 , label: 'Status' } ]
      Status
}
