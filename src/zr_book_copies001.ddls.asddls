@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZBOOK_COPIES001'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_BOOK_COPIES001
  as select from zbook_copies
  association to ZI_BOOKS1001 as _Book on $projection.BookID = _Book.BookID
{
  key copy_id as CopyID,
  book_id as BookID,
  is_available as IsAvailable,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt,
  _Book
}
