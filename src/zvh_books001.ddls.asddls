@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help - Books'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true

define view entity ZVH_BOOKS001
  as select from zbooks1
{
  key book_id                           as BookID,

      @Search.defaultSearchElement: true
      title                             as Title,

      isbn                              as Isbn,
      genre                             as Genre,
      publisher_name                    as PublisherName
}
