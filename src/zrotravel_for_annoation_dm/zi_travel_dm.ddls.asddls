@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Base Travel CDS View'
@Metadata.ignorePropagatedAnnotations: true
@VDM.viewType:#BASIC
define view entity ZI_TRAVEL_DM
  as select from /dmo/travel
{
  key travel_id     as TravelId,
  @EndUserText.label:'Agency Id by Enduser Text'
      agency_id     as AgencyId,
      customer_id   as CustomerId,
      begin_date    as BeginDate,
      end_date      as EndDate,
      @Semantics.amount.currencyCode:'CurrencyCode'
      booking_fee   as BookingFee,
      @Semantics.amount.currencyCode:'CurrencyCode'
      total_price   as TotalPrice,
      currency_code as CurrencyCode,
      description   as Description,
      status        as Status,
      createdby     as Createdby,
      createdat     as Createdat,
      lastchangedby as Lastchangedby,
      lastchangedat as Lastchangedat
}
