@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Overdue Report - Projection'
@Metadata.allowExtensions: true

@UI.headerInfo: {
  typeName:       'Overdue Book',
  typeNamePlural: 'Overdue Books',
  title:          { value: 'BookTitle' }
}

define root view entity ZC_OVERDUE_REPORT001
provider contract transactional_query
  as projection on ZI_OVERDUE_REPORT001
{
      @UI.facet: [{
        id:              'OverdueDetails',
        type:            #FIELDGROUP_REFERENCE,
        label:           'Overdue Details',
        targetQualifier: 'OverdueDetails',
        position:        10
      }]

  @UI.hidden: true
  key LendingId,

      @UI.lineItem:   [{ position: 10, label: 'Book Title' }]
      @UI.fieldGroup: [{ qualifier: 'OverdueDetails', position: 10, label: 'Book Title' }]
      BookTitle,

      @UI.lineItem:   [{ position: 20, label: 'Borrower Name' }]
      @UI.fieldGroup: [{ qualifier: 'OverdueDetails', position: 20, label: 'Borrower Name' }]
      UserFullName,

      @UI.lineItem:   [{ position: 30, label: 'Email' }]
      @UI.fieldGroup: [{ qualifier: 'OverdueDetails', position: 30, label: 'Email' }]
      UserEmail,

      @UI.lineItem:   [{ position: 40, label: 'Borrow Date' }]
      @UI.fieldGroup: [{ qualifier: 'OverdueDetails', position: 40, label: 'Borrow Date' }]
      BorrowDate,

      @UI.lineItem:   [{ position: 50, label: 'Due Date' }]
      @UI.fieldGroup: [{ qualifier: 'OverdueDetails', position: 50, label: 'Due Date' }]
      DueDate,

      @UI.lineItem:   [{ position: 60, label: 'Days Overdue' }]
      @UI.fieldGroup: [{ qualifier: 'OverdueDetails', position: 60, label: 'Days Overdue' }]
      DaysOverdue,

      @UI.lineItem:   [{ position: 70, label: 'Late Fee (EUR)' }]
      @UI.fieldGroup: [{ qualifier: 'OverdueDetails', position: 70, label: 'Late Fee (EUR)' }]
      @Semantics.amount.currencyCode: 'Currency'
      LateFee,

      @UI.hidden: true
      Currency,

      @UI.hidden: true
      CopyId,

      @UI.hidden: true
      UserId,


      _Copy,
      _User
}
