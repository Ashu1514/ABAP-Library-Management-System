@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZLENDING000001'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_LENDING000001
  as select from zlending as Lendings
  association to ZR_BOOK_COPIES001 as _Copies on $projection.CopyID = _Copies.CopyID
  association to ZR_LIBRARY_USERS001 as _User on $projection.UserID = _User.UserID
{
  key lending_id as LendingID,
  @Consumption.valueHelpDefinition: [ {
    entity.name: 'ZR_BOOK_COPIES001', 
    useForValidation: true
  } ]
  copy_id as CopyID,
  @Consumption.valueHelpDefinition: [ {
    entity.name: 'ZR_LIBRARY_USERS001', 
    useForValidation: true
  } ]
  user_id as UserID,
  borrow_date as BorrowDate,
  due_date as DueDate,
  return_date as ReturnDate,
  @Semantics.amount.currencyCode: 'Currency'
  late_fee as LateFee,
  @Consumption.valueHelpDefinition: [ {
    entity.name: 'I_CurrencyStdVH', 
    entity.element: 'Currency', 
    useForValidation: true
  } ]
  currency as Currency,
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
  _Copies,
  _User
}
