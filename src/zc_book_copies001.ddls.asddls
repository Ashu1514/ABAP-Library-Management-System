@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: 'Book Copies'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZBOOK_COPIES001'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_BOOK_COPIES001
  provider contract transactional_query
  as projection on ZR_BOOK_COPIES001
  association [1..1] to ZR_BOOK_COPIES001 as _BaseEntity on $projection.CopyID = _BaseEntity.CopyID
{
  key CopyID,
  @ObjectModel.text.element: ['BookTitle'] 
  @UI.textArrangement: #TEXT_ONLY 
   @Consumption.valueHelpDefinition: [{
  entity: {
    name:    'ZVH_BOOKS001',
    element: 'BookID'
  }
}]
@UI.lineItem:   [{ position: 10, label: 'Book Title' }]
@UI.fieldGroup: [{ qualifier: 'CopyDetails', position: 10, label: 'Book' }]
BookID,


@UI.hidden: true
_Book.Title   as BookTitle,
  IsAvailable,
  @Semantics: {
    user.createdBy: true
  }
  CreatedBy,
  @Semantics: {
    systemDateTime.createdAt: true
  }
  CreatedAt,
  @Semantics: {
    user.localInstanceLastChangedBy: true
  }
  LocalLastChangedBy,
  @Semantics: {
    systemDateTime.localInstanceLastChangedAt: true
  }
  LocalLastChangedAt,
  @Semantics: {
    systemDateTime.lastChangedAt: true
  }
  LastChangedAt,
  _Book : redirected to ZC_BOOKS1001,
  _BaseEntity
}
