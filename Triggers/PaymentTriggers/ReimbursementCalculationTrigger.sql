SET SERVEROUTPUT ON;

DECLARE
    trigger_exists INTEGER;

BEGIN
    -- Check if the trigger exists
    SELECT COUNT(*) INTO trigger_exists
    FROM all_triggers
    WHERE trigger_name = 'TRIGGER_REIMBURSEMENT_CALCULATION';

    -- Drop trigger if it exists
    IF trigger_exists > 0 THEN
        EXECUTE IMMEDIATE 'DROP TRIGGER TRIGGER_REIMBURSEMENT_CALCULATION';
        DBMS_OUTPUT.PUT_LINE('Trigger TRIGGER_REIMBURSEMENT_CALCULATION dropped.');
    END IF;

    -- Create the BEFORE INSERT trigger
    EXECUTE IMMEDIATE '
        CREATE OR REPLACE TRIGGER TRIGGER_REIMBURSEMENT_CALCULATION
        BEFORE INSERT ON PAYMENT
        FOR EACH ROW
        DECLARE
            v_claim_amount NUMBER(10, 2);
        BEGIN
            -- Fetch the claim amount for the associated claim_id
            SELECT CLAIM_AMOUNT
            INTO v_claim_amount
            FROM CLAIM
            WHERE CLAIM_ID = :NEW.CLAIM_ID;

            -- Calculate the payment amount based on the payment status
            IF :NEW.PAYMENT_STATUS = ''Completed'' THEN
                :NEW.PAYMENT_AMOUNT := v_claim_amount - 500; -- Deductible
            ELSIF :NEW.PAYMENT_STATUS = ''Partial'' THEN
                :NEW.PAYMENT_AMOUNT := (v_claim_amount - 500) * 0.5; -- 50% payout
            ELSE
                :NEW.PAYMENT_AMOUNT := 0; -- Failed or unknown status
            END IF;
        END;
    ';

    DBMS_OUTPUT.PUT_LINE('Trigger TRIGGER_REIMBURSEMENT_CALCULATION created successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/

COMMIT;


/*
/*
INSERT INTO PAYMENT (PAYMENT_ID, CLAIM_ID, PAYMENT_DATE, PAYMENT_METHOD, PAYMENT_STATUS)
VALUES (101, 1, TO_DATE('2024-12-01', 'YYYY-MM-DD'), 'Direct Deposit', 'Completed');

-- Expected Result:
-- PAYMENT_AMOUNT should be equal to (CLAIM_AMOUNT - 500), as the payment status is 'Completed'.
-- Example:
-- If CLAIM_AMOUNT for CLAIM_ID 1 is 2500, then PAYMENT_AMOUNT = 2000.
*/

*/