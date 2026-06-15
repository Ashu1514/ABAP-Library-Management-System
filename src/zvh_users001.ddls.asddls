@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View help for users'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZVH_USERS001 as select from zlibrary_users
{
    @EndUserText.label: 'User'
  key user_id    as UserId,
  
  @Search.defaultSearchElement: true
      full_name   as FullName,
      email    as Email
}

