CLASS LHC_ZR_RESERVATION001 DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR Reservations
        RESULT result,
      setExpiryDate FOR DETERMINE ON MODIFY
            IMPORTING keys FOR Reservations~setExpiryDate,
      validateReservation FOR VALIDATE ON SAVE
            IMPORTING keys FOR Reservations~validateReservation,
      validateReservationDate FOR VALIDATE ON SAVE
            IMPORTING keys FOR Reservations~validateReservationDate,
      checkExistingReservation FOR VALIDATE ON SAVE
            IMPORTING keys FOR Reservations~checkExistingReservation.
ENDCLASS.

CLASS LHC_ZR_RESERVATION001 IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.

  METHOD setExpiryDate.

READ ENTITIES OF ZR_RESERVATION001 IN LOCAL MODE
  ENTITY Reservations
    FIELDS ( ReservationDate ExpiryDate )
    WITH CORRESPONDING #( keys )
  RESULT DATA(entities).

" Filter out entities where dates are already set
DELETE entities WHERE ReservationDate IS NOT INITIAL
                  AND ExpiryDate IS NOT INITIAL.

CHECK entities IS NOT INITIAL.

" Set ReservationDate to current date and ExpiryDate to 3 days after current date
MODIFY ENTITIES OF ZR_RESERVATION001 IN LOCAL MODE
  ENTITY Reservations
    UPDATE FIELDS ( ReservationDate ExpiryDate )
    WITH VALUE #(
        FOR entity IN entities (
          %tky            = entity-%tky
          ReservationDate = cl_abap_context_info=>get_system_date( )
          ExpiryDate      = cl_abap_context_info=>get_system_date( ) + 3
        )
    ).

  ENDMETHOD.

  METHOD validateReservation.

READ ENTITIES OF ZR_RESERVATION001 IN LOCAL MODE
  ENTITY Reservations
    FIELDS ( UserID CopyID )
    WITH CORRESPONDING #( keys )
  RESULT DATA(entities).

LOOP AT entities INTO DATA(entity).
  " Clear state messages
  APPEND VALUE #(
      %tky        = entity-%tky
      %state_area = 'validateReservation'
  ) TO reported-reservations.

  " Validate UserID is not initial
  IF entity-UserID IS INITIAL.
    APPEND VALUE #( %tky = entity-%tky ) TO failed-reservations.
    APPEND VALUE #(
        %tky                = entity-%tky
        %state_area         = 'validateReservation'
        %msg                = NEW_MESSAGE_WITH_TEXT(
        text     = 'User is mandatory and cannot be empty'
        severity = if_abap_behv_message=>severity-error
        )
        %element-UserID     = if_abap_behv=>mk-on
    ) TO reported-reservations.
  ENDIF.

  " Validate CopyID is not initial
  IF entity-CopyID IS INITIAL.
    APPEND VALUE #( %tky = entity-%tky ) TO failed-reservations.
    APPEND VALUE #(
        %tky                = entity-%tky
        %state_area         = 'validateReservation'
        %msg                = NEW_MESSAGE_WITH_TEXT(
        text     = 'Book is mandatory and cannot be empty'
        severity = if_abap_behv_message=>severity-error
        )
        %element-CopyID     = if_abap_behv=>mk-on
    ) TO reported-reservations.
  ENDIF.
ENDLOOP.
  ENDMETHOD.

  METHOD validateReservationDate.

READ ENTITIES OF ZR_RESERVATION001 IN LOCAL MODE
  ENTITY Reservations
    FIELDS ( ReservationDate )
    WITH CORRESPONDING #( keys )
  RESULT DATA(entities).

LOOP AT entities INTO DATA(entity).
  " Clear state messages
  APPEND VALUE #(
      %tky        = entity-%tky
      %state_area = 'validateReservationDate'
  ) TO reported-reservations.

  " Validate ReservationDate is not initial
  IF entity-ReservationDate IS INITIAL.
    APPEND VALUE #( %tky = entity-%tky ) TO failed-reservations.
    APPEND VALUE #(
        %tky                = entity-%tky
        %state_area         = 'validateReservationDate'
        %msg                = NEW_MESSAGE_WITH_TEXT(
        text     = 'Reservation Date cannot be empty'
        severity = if_abap_behv_message=>severity-error
        )
        %element-ReservationDate = if_abap_behv=>mk-on
    ) TO reported-reservations.
  ENDIF.

  " Validate ReservationDate is not earlier than current date
  IF entity-ReservationDate < cl_abap_context_info=>get_system_date( ).
    APPEND VALUE #( %tky = entity-%tky ) TO failed-reservations.
    APPEND VALUE #(
        %tky                = entity-%tky
        %state_area         = 'validateReservationDate'
        %msg                = NEW_MESSAGE_WITH_TEXT(
        text     = 'Reservation Date cannot be earlier than the current date'
        severity = if_abap_behv_message=>severity-error
        )
        %element-ReservationDate = if_abap_behv=>mk-on
    ) TO reported-reservations.
  ENDIF.
ENDLOOP.
  ENDMETHOD.

  METHOD checkExistingReservation.

  DATA(lv_today) = cl_abap_context_info=>get_system_date( ).

  READ ENTITIES OF zr_reservation001 IN LOCAL MODE
    ENTITY Reservations
      FIELDS ( CopyID ExpiryDate ReservationID )
      WITH CORRESPONDING #( keys )
    RESULT DATA(entities).

  LOOP AT entities INTO DATA(entity).

    APPEND VALUE #(
      %tky        = entity-%tky
      %state_area = 'checkExistingReservation'
    ) TO reported-reservations.

    SELECT SINGLE reservation_id
      FROM zreservation
      WHERE copy_id = @entity-CopyID
        AND expiry_date >= @lv_today
      INTO @DATA(lv_existing_reservation).

    IF sy-subrc = 0.

      APPEND VALUE #(
        %tky = entity-%tky
      ) TO failed-reservations.

      APPEND VALUE #(
        %tky            = entity-%tky
        %state_area     = 'checkExistingReservation'
        %msg            = new_message_with_text(
          text     = 'An active reservation already exists for this book copy'
          severity = if_abap_behv_message=>severity-error
        )
        %element-CopyID = if_abap_behv=>mk-on
      ) TO reported-reservations.

    ENDIF.

  ENDLOOP.

ENDMETHOD.

ENDCLASS.
