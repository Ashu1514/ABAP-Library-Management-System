@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'Value Help - Authors'
@Search.searchable: true

define view entity ZVH_AUTHOR001
  as select from zauthors1
{
  @EndUserText.label: 'Author'
  key author_id    as AuthorID,

      @Search.defaultSearchElement: true
      first_name   as FirstName,

      last_name    as LastName,
      display_name as DisplayName
}

