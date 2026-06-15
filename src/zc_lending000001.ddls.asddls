@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZLENDING000001'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_LENDING000001
  provider contract transactional_query
  as projection on ZR_LENDING000001
  association [1..1] to ZR_LENDING000001 as _BaseEntity on $projection.LendingID = _BaseEntity.LendingID
{
    key LendingID,
    @ObjectModel.text.element: ['UserName']
    @UI.textArrangement: #TEXT_ONLY
    @Consumption.valueHelpDefinition: [{
      entity: {
        name:    'ZVH_USERS001',
        element: 'UserId'
      }
    }]
    @UI.identification: [{ hidden: true }]
    @UI.lineItem:        [{ position: 10, label: 'User' }]
    @UI.fieldGroup:      [{ qualifier: 'UserDetails', position: 10, label: 'User' }]
    UserID,
    
     @UI.identification: [{ hidden: true }]
    @UI.lineItem:        [{ position: 15, label: 'User Name' }]
    @UI.fieldGroup:      [{ qualifier: 'UserDetails', position: 15, label: 'User Name' }]
    _User.FullName  as UserName,
      
       @UI.identification: [{ hidden: true }]
    @UI.lineItem:        [{ position: 20, label: 'User Email' }]
    @UI.fieldGroup:      [{ qualifier: 'UserDetails', position: 20, label: 'User Email' }]
    _User.Email  as UserEmail,
  
    @ObjectModel.text.element: ['BookTitle']
    @UI.textArrangement: #TEXT_ONLY
    @Consumption.valueHelpDefinition: [{
      entity: {
        name:    'ZVH_BOOKCOPY',
        element: 'CopyId'
      }
    }]
    @UI.lineItem:        [{ position: 10, label: 'Book Title' }]
    @UI.fieldGroup:      [{ qualifier: 'UserDetails', position: 10, label: 'Book Title' }]
    CopyID,
    
    @UI.lineItem:        [{ position: 25, label: 'Book Title' }]
    @UI.fieldGroup:      [{ qualifier: 'BookCopyDetail', position: 25, label: 'Book Title' }]
    _Copies._Book.Title  as BookTitle,
      
    @UI.lineItem:        [{ position: 30, label: 'Book ISBN' }]
    @UI.fieldGroup:      [{ qualifier: 'BookCopyDetail', position: 30, label: 'Book ISBN' }]
    _Copies._Book.Isbn  as BookIsbn,
      BorrowDate,
      DueDate,
      ReturnDate,
      @Semantics: {
        amount.currencyCode: 'Currency'
      }
      LateFee,
      @Consumption: {
        valueHelpDefinition: [ {
          entity.element: 'Currency', 
          entity.name: 'I_CurrencyStdVH', 
          useForValidation: true
        } ]
      }
      Currency,
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
      _User : redirected to ZC_LIBRARY_USERS001,
      _Copies: redirected to ZC_BOOK_COPIES001,
      _BaseEntity
}
