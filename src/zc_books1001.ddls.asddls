@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Library Books'

define root view entity ZC_BOOKS1001
  provider contract transactional_query
  as projection on ZI_BOOKS1001
{
  @UI.hidden: true
  key BookID,

@ObjectModel.text.element: ['AuthorName']
@UI.textArrangement: #TEXT_ONLY
@Consumption.valueHelpDefinition: [{
  entity: {
    name:    'ZVH_AUTHOR001',
    element: 'AuthorID'
  }
}]
@UI.lineItem:        [{ position: 10, label: 'Author' }]
@UI.selectionField:  [{ position: 10 }]
@UI.fieldGroup:      [{ qualifier: 'BookDetails', position: 10, label: 'Author' }]
AuthorID,

      @UI.hidden: true
      _Author.DisplayName  as AuthorName,

      @UI.lineItem:        [{ position: 20, label: 'Title' }]
      @UI.selectionField:  [{ position: 20 }]
      @UI.fieldGroup:      [{ qualifier: 'BookDetails', position: 20, label: 'Title' }]
      Title,

      @UI.lineItem:        [{ position: 30, label: 'ISBN' }]
      @UI.fieldGroup:      [{ qualifier: 'BookDetails', position: 30, label: 'ISBN' }]
      Isbn,

      @UI.lineItem:        [{ position: 40, label: 'Genre' }]
      @UI.selectionField:  [{ position: 30 }]
      @UI.fieldGroup:      [{ qualifier: 'BookDetails', position: 40, label: 'Genre' }]
      Genre,

      @UI.lineItem:        [{ position: 50, label: 'Year' }]
      @UI.fieldGroup:      [{ qualifier: 'BookDetails', position: 50, label: 'Publish Year' }]
      PublishYear,

      @UI.fieldGroup:      [{ qualifier: 'BookDetails', position: 60, label: 'Publisher' }]
      PublisherName,

      @UI.hidden: true
      CreatedBy,

      @UI.hidden: true
      CreatedAt,

      @UI.hidden: true
      LocalLastChangedBy,

      @UI.hidden: true
      LocalLastChangedAt,

      @UI.hidden: true
      LastChangedAt,

      _Author
}
