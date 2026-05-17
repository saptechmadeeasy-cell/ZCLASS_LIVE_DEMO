define view entity ZI_BOOKING_UM_AL
  as select from zbooking_um_al
  association to parent ZI_TRAVEL_UM_AL as _Travel on $projection.parent_uuid = _Travel.travel_uuid
  composition [0..*] of ZI_BOOKSUPPL_UM_AL as _Booksuppl
{
  key booking_uuid,
      parent_uuid,
      booking_id,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at, // <--- Add this to your table and view
      customer_id,          
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at,
      _Travel,
      _Booksuppl // Association to parent
}
