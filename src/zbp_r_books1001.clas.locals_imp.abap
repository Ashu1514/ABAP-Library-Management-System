CLASS LHC_ZI_BOOKS1001 DEFINITION
  INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.

  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR ZiBooks1001
        RESULT result,

      det_set_publish_year FOR DETERMINE ON MODIFY
        IMPORTING keys FOR ZiBooks1001~det_set_publish_year,

      val_isbn FOR VALIDATE ON SAVE
        IMPORTING keys FOR ZiBooks1001~val_isbn.

ENDCLASS.

CLASS LHC_ZI_BOOKS1001 IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.


  METHOD det_set_publish_year.
    READ ENTITIES OF ZI_BOOKS1001 IN LOCAL MODE
      ENTITY ZiBooks1001
      FIELDS ( PublishYear )
      WITH CORRESPONDING #( keys )
      RESULT DATA(books).

    DATA updates TYPE TABLE FOR UPDATE
      ZI_BOOKS1001\\ZiBooks1001.

    DATA current_year TYPE numc4.
    current_year = sy-datum(4).

    LOOP AT books INTO DATA(book).
      IF book-PublishYear IS INITIAL.
        APPEND VALUE #(
          %tky        = book-%tky
          PublishYear = current_year
          %control    = VALUE #(
            PublishYear = if_abap_behv=>mk-on )
        ) TO updates.
      ENDIF.
    ENDLOOP.

    MODIFY ENTITIES OF ZI_BOOKS1001 IN LOCAL MODE
      ENTITY ZiBooks1001
      UPDATE FIELDS ( PublishYear )
      WITH updates
      REPORTED DATA(rep).

    reported = CORRESPONDING #( DEEP rep ).
  ENDMETHOD.

  " ─────────────────────────────────────────────
  " VALIDATION
  " ISBN must be exactly 13 characters
  " ─────────────────────────────────────────────
  METHOD val_isbn.
    READ ENTITIES OF ZI_BOOKS1001 IN LOCAL MODE
      ENTITY ZiBooks1001
      FIELDS ( Isbn )
      WITH CORRESPONDING #( keys )
      RESULT DATA(books).

    LOOP AT books INTO DATA(book).
      IF book-Isbn IS INITIAL
      OR strlen( book-Isbn ) <> 13.
        APPEND VALUE #(
          %tky = book-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'ISBN must be exactly 13 characters' )
        ) TO reported-ZiBooks1001.
        APPEND VALUE #(
          %tky = book-%tky
        ) TO failed-ZiBooks1001.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

