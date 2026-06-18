CLASS LHC_ZR_LENDING000001 DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR Lendings
        RESULT result,
      setDueDate FOR DETERMINE ON MODIFY
            IMPORTING keys FOR Lendings~setDueDate,
      validateLending FOR VALIDATE ON SAVE
            IMPORTING keys FOR Lendings~validateLending,
      validateBorrowDate FOR VALIDATE ON SAVE
            IMPORTING keys FOR Lendings~validateBorrowDate,
      checkCopyIdInReservation FOR VALIDATE ON SAVE
            IMPORTING keys FOR Lendings~checkCopyIdInReservation,
      checkUserStatus FOR VALIDATE ON SAVE
            IMPORTING keys FOR Lendings~checkUserStatus.
ENDCLASS.

CLASS LHC_ZR_LENDING000001 IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.

  METHOD setDueDate.

      READ ENTITIES OF zr_lending000001 IN LOCAL MODE
        ENTITY Lendings
        FIELDS ( BorrowDate DueDate )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_lendings).

      DATA lt_update TYPE TABLE FOR UPDATE zr_lending000001\\Lendings.

      LOOP AT lt_lendings ASSIGNING FIELD-SYMBOL(<lending>).

        CHECK <lending>-BorrowDate IS NOT INITIAL.

        APPEND VALUE #(
          %tky    = <lending>-%tky
          DueDate = <lending>-BorrowDate + 30
        ) TO lt_update.

      ENDLOOP.

      IF lt_update IS NOT INITIAL.

        MODIFY ENTITIES OF zr_lending000001 IN LOCAL MODE
          ENTITY Lendings
          UPDATE FIELDS ( DueDate )
          WITH lt_update.

      ENDIF.

    ENDMETHOD.

  METHOD validateLending.

  READ ENTITIES OF zr_lending000001 IN LOCAL MODE
    ENTITY Lendings
    FIELDS ( UserID CopyID )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_lendings).

  LOOP AT lt_lendings ASSIGNING FIELD-SYMBOL(<lending>).

    " Check User exists
    SELECT SINGLE user_id
      FROM zlibrary_users
      WHERE user_id = @<lending>-UserID
      INTO @DATA(lv_user).

    IF sy-subrc <> 0.

      APPEND VALUE #(
        %tky = <lending>-%tky
      ) TO failed-lendings.

      APPEND VALUE #(
        %tky = <lending>-%tky
        %msg = new_message_with_text(
          severity = if_abap_behv_message=>severity-error
          text     = 'Selected user does not exist'
        )
      ) TO reported-lendings.

      CONTINUE.
    ENDIF.


    " Check Copy exists and is available
    SELECT SINGLE is_available
      FROM Zbook_copies
      WHERE copy_id = @<lending>-CopyID
      INTO @DATA(lv_available).

    IF sy-subrc <> 0.

      APPEND VALUE #(
        %tky = <lending>-%tky
      ) TO failed-lendings.

      APPEND VALUE #(
        %tky = <lending>-%tky
        %msg = new_message_with_text(
          severity = if_abap_behv_message=>severity-error
          text     = 'Selected copy does not exist'
        )
      ) TO reported-lendings.

      CONTINUE.

      ELSEIF lv_available <> 'X'.

          APPEND VALUE #(
            %tky = <lending>-%tky
          ) TO failed-lendings.

          APPEND VALUE #(
            %tky = <lending>-%tky
            %msg = new_message_with_text(
              severity = if_abap_behv_message=>severity-error
              text     = 'Book copy is not available'
            )
          ) TO reported-lendings.

    ENDIF.

  ENDLOOP.

  ENDMETHOD.

  METHOD validateBorrowDate.

  READ ENTITIES OF zr_lending000001 IN LOCAL MODE
    ENTITY Lendings
    FIELDS ( BorrowDate )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_lendings).

  DATA(lv_today) = cl_abap_context_info=>get_system_date( ).

  LOOP AT lt_lendings ASSIGNING FIELD-SYMBOL(<lending>).

    IF <lending>-BorrowDate IS INITIAL.

      APPEND VALUE #(
        %tky = <lending>-%tky
      ) TO failed-lendings.

      APPEND VALUE #(
        %tky = <lending>-%tky
        %element-BorrowDate = if_abap_behv=>mk-on
        %msg = new_message_with_text(
          severity = if_abap_behv_message=>severity-error
          text     = 'Borrow Date is mandatory'
        )
      ) TO reported-lendings.

      CONTINUE.

    ENDIF.

    IF <lending>-BorrowDate < lv_today.

      APPEND VALUE #(
        %tky = <lending>-%tky
      ) TO failed-lendings.

      APPEND VALUE #(
        %tky = <lending>-%tky
        %element-BorrowDate = if_abap_behv=>mk-on
        %msg = new_message_with_text(
          severity = if_abap_behv_message=>severity-error
          text     = 'Borrow Date cannot be earlier than today'
        )
      ) TO reported-lendings.

    ENDIF.

  ENDLOOP.

ENDMETHOD.


  METHOD checkCopyIdInReservation.

READ ENTITIES OF zr_lending000001 IN LOCAL MODE
  ENTITY Lendings
  FIELDS ( CopyID )
  WITH CORRESPONDING #( keys )
  RESULT DATA(lt_lendings).

LOOP AT lt_lendings ASSIGNING FIELD-SYMBOL(<lending>).

  " Check if copy is already reserved
  SELECT SINGLE user_id, expiry_date
    FROM zreservation
    WHERE copy_id = @<lending>-CopyID
    INTO @DATA(ls_reservation).

  IF sy-subrc = 0.

  " Same user who made the reservation -> allow
  IF ls_reservation-user_id = <lending>-UserID.
    CONTINUE.
  ENDIF.

  SELECT SINGLE full_name
    FROM zlibrary_users
    WHERE user_id = @ls_reservation-user_id
    INTO @DATA(lv_reserved_user_name).

    APPEND VALUE #(
      %tky = <lending>-%tky
    ) TO failed-lendings.

    APPEND VALUE #(
      %tky = <lending>-%tky
      %element-CopyID = if_abap_behv=>mk-on
      %msg = new_message_with_text(
        severity = if_abap_behv_message=>severity-error
        text     = |Book copy is already reserved for { lv_reserved_user_name } till { ls_reservation-expiry_date }|
      )
    ) TO reported-lendings.

  ENDIF.

ENDLOOP.
  ENDMETHOD.

 METHOD checkUserStatus.

  DATA(lv_today) = cl_abap_context_info=>get_system_date( ).

  READ ENTITIES OF zr_lending000001 IN LOCAL MODE
    ENTITY Lendings
    FIELDS ( UserID )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_lendings).

  LOOP AT lt_lendings ASSIGNING FIELD-SYMBOL(<lending>).

    SELECT SINGLE membership_status,
                  membership_end_date
      FROM zlibrary_users
      WHERE user_id = @<lending>-UserID
      INTO @DATA(ls_user).

    " Membership status check
    IF ls_user-membership_status <> 'ACTIVE'.

      APPEND VALUE #( %tky = <lending>-%tky )
        TO failed-lendings.

      APPEND VALUE #(
        %tky            = <lending>-%tky
        %element-UserID = if_abap_behv=>mk-on
        %msg            = new_message_with_text(
          severity = if_abap_behv_message=>severity-error
          text     = |Only ACTIVE members can borrow books.|
        )
      ) TO reported-lendings.

      CONTINUE.

    ENDIF.

    " Membership expiry check
    IF ls_user-membership_end_date IS NOT INITIAL
       AND ls_user-membership_end_date < lv_today.

      APPEND VALUE #( %tky = <lending>-%tky )
        TO failed-lendings.

      APPEND VALUE #(
        %tky            = <lending>-%tky
        %element-UserID = if_abap_behv=>mk-on
        %msg            = new_message_with_text(
          severity = if_abap_behv_message=>severity-error
          text     = |Membership expired on { ls_user-membership_end_date }. User cannot borrow books.|
        )
      ) TO reported-lendings.

    ENDIF.

  ENDLOOP.

ENDMETHOD.

ENDCLASS.
