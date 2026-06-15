@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@Endusertext: {
  Label: '###GENERATED Core Data Service Entity'
}
@Objectmodel: {
  Sapobjectnodetype.Name: 'ZRESERVATION001'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_RESERVATION001
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_RESERVATION001
  association [1..1] to ZR_RESERVATION001 as _BaseEntity on $projection.RESERVATIONID = _BaseEntity.RESERVATIONID
{
  key ReservationID,
  CopyID,
  UserID,
  ReservationDate,
  ExpiryDate,
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
