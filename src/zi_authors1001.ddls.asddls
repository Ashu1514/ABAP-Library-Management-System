@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZAUTHORS1001'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZI_AUTHORS1001
  as select from ZAUTHORS1
{
  key author_id as AuthorID,
  first_name as FirstName,
  last_name as LastName,
  display_name as DisplayName,
  birth_year as BirthYear,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt
}
