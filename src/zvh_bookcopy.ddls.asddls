@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Book Copy'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.dataCategory: #VALUE_HELP
@Search.searchable: true
define view entity ZVH_BOOKCOPY
  as select from zbook_copies as Copy

    inner join zbooks1 as Book
      on Copy.book_id = Book.book_id

    left outer join zauthors1 as Author
      on Book.author_id = Author.author_id
      
    left outer join zlending as Lending
      on  Lending.copy_id = Copy.copy_id
      and Lending.return_date = '00000000'

    left outer join zreservation as Reservation
      on  Reservation.copy_id = Copy.copy_id
      and Reservation.expiry_date >= $session.system_date

{
  @EndUserText.label: 'Copy ID'
  key Copy.copy_id as CopyId,

  @EndUserText.label: 'Available'
  Copy.is_available as IsAvailable,

  @EndUserText.label: 'Title'
  @Search.defaultSearchElement: true
  @Search.ranking: #HIGH
  Book.title as Title,

  @EndUserText.label: 'ISBN'
  @Search.defaultSearchElement: true
  @Search.ranking: #HIGH
  Book.isbn as Isbn,

  @EndUserText.label: 'Author Name'
  @Search.defaultSearchElement: true
  @Search.ranking: #MEDIUM
  Author.display_name as AuthorName
}
where Copy.is_available = 'X'
  and Lending.lending_id is null
  and Reservation.reservation_id is null
