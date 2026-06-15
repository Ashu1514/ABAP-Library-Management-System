CLASS LHC_ZR_LIBRARY_USERS001 DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR ZrLibraryUsers001
        RESULT result,
      setmembershipstatus FOR DETERMINE ON MODIFY
            IMPORTING keys FOR ZrLibraryUsers001~setmembershipstatus,
      validateEmail FOR VALIDATE ON SAVE
            IMPORTING keys FOR ZrLibraryUsers001~validateEmail.
ENDCLASS.

CLASS LHC_ZR_LIBRARY_USERS001 IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.
  METHOD setmembershipstatus.

READ ENTITIES OF ZR_LIBRARY_USERS001 IN LOCAL MODE
  ENTITY ZrLibraryUsers001
    FIELDS ( MembershipStatus )
    WITH CORRESPONDING #( keys )
  RESULT DATA(entities).

"If MembershipStatus is already set, do nothing
DELETE entities WHERE MembershipStatus IS NOT INITIAL.
CHECK entities IS NOT INITIAL.

MODIFY ENTITIES OF ZR_LIBRARY_USERS001 IN LOCAL MODE
  ENTITY ZrLibraryUsers001
    UPDATE FIELDS ( MembershipStatus )
    WITH VALUE #(
        FOR entity IN entities (
        %tky             = entity-%tky
        MembershipStatus = 'ACTIVE'
        )
).
  ENDMETHOD.

  METHOD validateEmail.

READ ENTITIES OF ZR_LIBRARY_USERS001 IN LOCAL MODE
  ENTITY ZrLibraryUsers001
    FIELDS ( Email )
    WITH CORRESPONDING #( keys )
  RESULT DATA(entities).

LOOP AT entities INTO DATA(entity).
  APPEND VALUE #(
      %tky        = entity-%tky
      %state_area = 'VALIDATE_EMAIL'
  ) TO reported-zrlibraryusers001.

  IF entity-Email IS NOT INITIAL.
    DATA(lv_email) = condense(
  val = CONV string( entity-Email )
).

IF NOT matches(
  val  = lv_email
  pcre = `(?i)^[a-z0-9._%+-]+@gmail[.]com$`
).

  APPEND VALUE #(
    %tky = entity-%tky
  ) TO failed-zrlibraryusers001.

  APPEND VALUE #(
    %tky        = entity-%tky
    %state_area = 'VALIDATE_EMAIL'

    %msg = new_message_with_text(
      text     = 'Email must be a valid @gmail.com address'
      severity = if_abap_behv_message=>severity-error
    )

    %element-Email = if_abap_behv=>mk-on

  ) TO reported-zrlibraryusers001.

ENDIF.
  ENDIF.
ENDLOOP.
  ENDMETHOD.

ENDCLASS.
