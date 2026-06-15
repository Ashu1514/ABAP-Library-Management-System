@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZRESERVATION001'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_RESERVATION001
  as select from ZRESERVATION as Reservations
{
  key reservation_id as ReservationID,
  copy_id as CopyID,
  user_id as UserID,
  reservation_date as ReservationDate,
  expiry_date as ExpiryDate,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt
}
