CLASS LHC_ZR_BOOK_COPIES001 DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR ZrBookCopies001
        RESULT result,
      setavailable FOR DETERMINE ON MODIFY
            IMPORTING keys FOR ZrBookCopies001~setavailable.
ENDCLASS.

CLASS LHC_ZR_BOOK_COPIES001 IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.
  METHOD setavailable.

READ ENTITIES OF ZR_BOOK_COPIES001 IN LOCAL MODE
  ENTITY ZrBookCopies001
    FIELDS ( IsAvailable )
    WITH CORRESPONDING #( keys )
  RESULT DATA(entities).

"If IsAvailable is already set, do nothing
DELETE entities WHERE IsAvailable IS NOT INITIAL.
CHECK entities IS NOT INITIAL.

" Set IsAvailable to 'X' (abap_true for boolean)
MODIFY ENTITIES OF ZR_BOOK_COPIES001 IN LOCAL MODE
  ENTITY ZrBookCopies001
    UPDATE FIELDS ( IsAvailable )
    WITH VALUE #(
        FOR entity IN entities (
        %tky          = entity-%tky
        IsAvailable = abap_true
        )
).
  ENDMETHOD.

ENDCLASS.
