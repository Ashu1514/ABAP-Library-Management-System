@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZBOOKS1001'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZI_BOOKS1001
  as select from zbooks1
  
  association [0..1] to ZI_AUTHORS1001 as _Author
    on $projection.AuthorID = _Author.AuthorID
{
  key book_id as BookID,
  author_id as AuthorID,
  isbn as Isbn,
  title as Title,
  genre as Genre,
  publish_year as PublishYear,
  publisher_name as PublisherName,
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
  
  _Author
}
