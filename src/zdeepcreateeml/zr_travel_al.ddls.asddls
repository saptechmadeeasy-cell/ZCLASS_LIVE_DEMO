@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZR_TRAVEL_AL'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZR_TRAVEL_AL
  as select from ztravel_al
  composition [1..*] of ZI_BOOKING_AL as _BOOKING
{
  key travel_uuid           as TravelUuid,
      travel_id             as TravelId,
      description           as Description,
      overall_status        as OverallStatus,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      _BOOKING // Make association public
}
