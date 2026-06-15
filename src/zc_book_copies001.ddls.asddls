@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
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
   @Consumption.valueHelpDefinition: [
    {
      entity: {
        name: 'ZC_BOOKS1001',
        element: 'BookID'
      }
    }
  ]
  BookID,
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
