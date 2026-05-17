@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection CDS'
@Metadata.ignorePropagatedAnnotations: true
@VDM.viewType:#CONSUMPTION
@UI.headerInfo: {
typeName: 'Travel',
typeNamePlural:'Travels'
}
@Search.searchable: true
define view entity ZC_TRAVEL_DM
  as select from ZI_TRAVEL_DM
{
      @UI.facet: [  {
      label:' General Information for travel Id' ,
      id:'GeneralInfo',
      purpose:#STANDARD,
      position:10 ,
      type: #IDENTIFICATION_REFERENCE
      } ]
      @UI.selectionField: [{
      position:10 }]
      @UI.lineItem :[ { position:10 , label: 'Travel Id' }]
      @UI.identification: [{ position:10 , label: 'Travel Id' }]
  key TravelId,
      @UI.selectionField: [{
      position:20 }]
      @UI.lineItem :[ { position:20 , label: 'AgencyId' }]
      AgencyId,
      @UI.selectionField: [{
      position:30 }]

      @UI.lineItem :[ { position:30 , label: 'CustomerId' }]
      CustomerId,

      @UI.selectionField: [{
      position:40 }]
      @UI.lineItem :[ { position:40 , label: 'BeginDate' }]
      BeginDate,
      @UI.lineItem :[ { position:50 , label: 'EndDate' }]
      EndDate,
      @UI.lineItem :[ { position:60 , label: 'BookingFee' }]
      @Semantics.amount.currencyCode: 'CurrencyCode'
      BookingFee,
      @UI.lineItem :[ { position:70 , label: 'CurrencyCode' }]
      CurrencyCode,
      @UI.lineItem :[ { position:80 , label: 'Description' }]
      @Search.fuzzinessThreshold: 0.70
      @Search.defaultSearchElement:true
      Description,
      @Search.fuzzinessThreshold: 0.80
      @Search.defaultSearchElement: true
      @UI.lineItem :[ { position:90 , label: 'Status' }]
      Status
}
