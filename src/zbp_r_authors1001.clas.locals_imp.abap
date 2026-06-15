CLASS LHC_ZI_AUTHORS1001 DEFINITION
  INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.

  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR ZiAuthors1001
        RESULT result,

      det_full_name FOR DETERMINE ON MODIFY
        IMPORTING keys FOR ZiAuthors1001~det_full_name,

      val_birth_year FOR VALIDATE ON SAVE
        IMPORTING keys FOR ZiAuthors1001~val_birth_year.

ENDCLASS.

CLASS LHC_ZI_AUTHORS1001 IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD det_full_name.
    READ ENTITIES OF ZI_AUTHORS1001 IN LOCAL MODE
      ENTITY ZiAuthors1001
      FIELDS ( FirstName LastName )
      WITH CORRESPONDING #( keys )
      RESULT DATA(authors).

    DATA updates TYPE TABLE FOR UPDATE
      ZI_AUTHORS1001\\ZiAuthors1001.

    LOOP AT authors INTO DATA(author).
      IF author-FirstName IS NOT INITIAL
      OR author-LastName  IS NOT INITIAL.
        APPEND VALUE #(
          %tky        = author-%tky
          DisplayName = author-FirstName
                     && ' '
                     && author-LastName
          %control    = VALUE #(
            DisplayName = if_abap_behv=>mk-on )
        ) TO updates.
      ENDIF.
    ENDLOOP.

    MODIFY ENTITIES OF ZI_AUTHORS1001 IN LOCAL MODE
      ENTITY ZiAuthors1001
      UPDATE FIELDS ( DisplayName )
      WITH updates
      REPORTED DATA(rep).

    reported = CORRESPONDING #( DEEP rep ).
  ENDMETHOD.

  METHOD val_birth_year.
    READ ENTITIES OF ZI_AUTHORS1001 IN LOCAL MODE
      ENTITY ZiAuthors1001
      FIELDS ( BirthYear )
      WITH CORRESPONDING #( keys )
      RESULT DATA(authors).

    DATA current_year TYPE numc4.
    current_year = sy-datum(4).

    LOOP AT authors INTO DATA(author).
      IF author-BirthYear > current_year
      OR author-BirthYear < 1000.
        APPEND VALUE #(
          %tky = author-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = 'Birth year must be between 1000 and current year' )
        ) TO reported-ZiAuthors1001.
        APPEND VALUE #(
          %tky = author-%tky
        ) TO failed-ZiAuthors1001.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

