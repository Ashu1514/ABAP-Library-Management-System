@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: 'Book Authors'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZAUTHORS1001'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_AUTHORS1001
  provider contract transactional_query
  as projection on ZI_AUTHORS1001
  {
      
      @UI.facet: [
        {
          id:              'AuthorDetails',
          type:            #FIELDGROUP_REFERENCE,
          label:           'Author Details',
          targetQualifier: 'AuthorDetails',
          position:        10
        }
      ]
  key AuthorID,

     @UI.lineItem:   [{ position: 10, label: 'First Name' }]
      @UI.fieldGroup: [{ qualifier: 'AuthorDetails', position: 10, label: 'First Name' }]
      FirstName,

      @UI.lineItem:   [{ position: 20, label: 'Last Name' }]
      @UI.fieldGroup: [{ qualifier: 'AuthorDetails', position: 20, label: 'Last Name' }]
      LastName,

      @UI.lineItem:   [{ position: 30, label: 'Display Name' }]
      @UI.fieldGroup: [{ qualifier: 'AuthorDetails', position: 30, label: 'Display Name' }]
      DisplayName,

    

      @UI.lineItem:   [{ position: 50, label: 'Birth Year' }]
      @UI.fieldGroup: [{ qualifier: 'AuthorDetails', position: 50, label: 'Birth Year' }]
      BirthYear,

      @UI.hidden: true
      CreatedBy,
      
      @UI.hidden: true
      LocalLastChangedAt,

      @UI.hidden: true
      CreatedAt,

      @UI.hidden: true
      LastChangedAt
}

