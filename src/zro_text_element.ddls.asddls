@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZRO_TEXT_ELEMENT'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true

define view entity ZRO_TEXT_ELEMENT
  as select from /dmo/travel association [1..*] to 
  ZI_DMO_AGENCY_M_PK as _travel_desc on $projection.AgencyId = _travel_desc.AgencyId
{
      @ObjectModel.text.association: '_travel_desc'
      @UI.lineItem: [{ label: 'Travel Id ' , position:  10 }]
  key travel_id     as TravelId,
      agency_id     as AgencyId,
      @UI.lineItem: [{ label: 'Customer id' , position:  20 }]
      customer_id   as CustomerId,
      begin_date    as BeginDate,
      end_date      as EndDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      booking_fee   as BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      total_price   as TotalPrice,
      currency_code as CurrencyCode,
//      @Search.fuzzinessThreshold: 0.70
      @Search.defaultSearchElement: true
      @UI.lineItem: [{ label: 'Description' , position:  30 }]
      description   as Description,
      status        as Status,
      createdby     as Createdby,
      createdat     as Createdat,
      lastchangedby as Lastchangedby,
      lastchangedat as Lastchangedat,
      
      @Search.defaultSearchElement: true
      _travel_desc
}
