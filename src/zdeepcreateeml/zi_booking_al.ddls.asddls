@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZI_BOOKING_AL'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_BOOKING_AL 

 as select from zbooking_al association to parent ZR_TRAVEL_AL as  _travel
 on $projection.ParentUuid = _travel.TravelUuid
 
{
    key booking_uuid as BookingUuid,
    parent_uuid as ParentUuid,
    booking_id as BookingId,
    customer_id as CustomerId,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    local_last_changed_at as LocalLastChangedAt,
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at as LastChangedAt,
    _travel
}
