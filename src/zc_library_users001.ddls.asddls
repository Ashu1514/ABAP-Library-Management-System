@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@Endusertext: {
  Label: '###GENERATED Core Data Service Entity'
}
@Objectmodel: {
  Sapobjectnodetype.Name: 'ZLIBRARY_USERS001'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_LIBRARY_USERS001
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_LIBRARY_USERS001
  association [1..1] to ZR_LIBRARY_USERS001 as _BaseEntity on $projection.USERID = _BaseEntity.USERID
{
  key UserID,
  FullName,
  Email,
  Phone,
  Address,
  MembershipStatus,
  MembershipEndDate,
  @Semantics: {
    User.Createdby: true
  }
  CreatedBy,
  @Semantics: {
    Systemdatetime.Createdat: true
  }
  CreatedAt,
  @Semantics: {
    User.Localinstancelastchangedby: true
  }
  LocalLastChangedBy,
  @Semantics: {
    Systemdatetime.Localinstancelastchangedat: true
  }
  LocalLastChangedAt,
  @Semantics: {
    Systemdatetime.Lastchangedat: true
  }
  LastChangedAt,
  _BaseEntity
}
