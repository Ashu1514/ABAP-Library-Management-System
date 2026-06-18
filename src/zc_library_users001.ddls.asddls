@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: 'Library Users'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZLIBRARY_USERS001'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_LIBRARY_USERS001
  provider contract transactional_query
  as projection on ZR_LIBRARY_USERS001
  association [1..1] to ZR_LIBRARY_USERS001 as _BaseEntity on $projection.UserID = _BaseEntity.UserID
{
  key UserID,
  FullName,
  Email,
  Phone,
  Address,
  MembershipStatus,
  MembershipEndDate,
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
  _BaseEntity
}
