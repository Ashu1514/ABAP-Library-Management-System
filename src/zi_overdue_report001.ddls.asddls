@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Overdue Lending Report'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZI_OVERDUE_REPORT001
  as select from zlending as l

  association [0..1] to ZR_BOOK_COPIES001  as _Copy
    on $projection.CopyId = _Copy.CopyID

  association [0..1] to ZR_LIBRARY_USERS001 as _User
    on $projection.UserId = _User.UserID

{
  key l.lending_id                          as LendingId,
      l.copy_id                             as CopyId,
      l.user_id                             as UserId,
      l.borrow_date                         as BorrowDate,
      l.due_date                            as DueDate,
      
      dats_days_between(
        l.due_date,
        cast( $session.system_date as abap.dats )
      )                                     as DaysOverdue,

     
      cast( 'EUR' as abap.cuky )            as Currency,

     
      @Semantics.amount.currencyCode: 'Currency'
      cast(
        dats_days_between(
          l.due_date,
          cast( $session.system_date as abap.dats )
        ) * 2 as abap.curr(15,2)
      )                                     as LateFee,

      _Copy._Book.Title                     as BookTitle,
      _User.FullName                        as UserFullName,
      _User.Email                           as UserEmail,

      _Copy,
      _User
}
where
      l.due_date    < cast( $session.system_date as abap.dats )
