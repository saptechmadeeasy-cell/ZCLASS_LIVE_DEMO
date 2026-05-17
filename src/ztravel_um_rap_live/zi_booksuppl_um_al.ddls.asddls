@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking supplements'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_BOOKSUPPL_UM_AL as select from zbooksuppl_um_al
association to parent ZI_BOOKING_UM_AL as _Booking on $projection.BookingUuid = _Booking.booking_uuid
association to exact one ZI_TRAVEL_UM_AL as _Travel on $projection.TravelUuid = _Travel.travel_uuid



{
    key booksuppl_uuid as BooksupplUuid,
    travel_uuid as TravelUuid,
    booking_uuid as BookingUuid,
    supplement_id as SupplementId,
    @Semantics.amount.currencyCode: 'CurrencyCode'    
    price as Price,
    currency_code as CurrencyCode,
    local_last_changed_at as LocalLastChangedAt,
    _Booking,
    _Travel
}
