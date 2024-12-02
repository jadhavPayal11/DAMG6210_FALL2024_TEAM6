/* 
    Script Name: TriggerPaymentStatusUpdate.sql
    Description: Updates the claim status in the CLAIM table automatically when payment is completed, partial, or failed.
    Associated Table: PAYMENT
    Execution: BEFORE UPDATE
    Prerequisites: Ensure CLAIM and PAYMENT tables exist and InsertRecords.sql is executed.
*/

/* Run this as ICPS_CORE */

SET SERVEROUTPUT ON;

DECLARE
    trigger_exists INTEGER;

BEGIN
    -- Check if trigger already exists
    SELECT COUNT(*) INTO trigger_exists
    FROM all_triggers
    WHERE trigger_name = 'TRIGGER_PAYMENT_STATUS_UPDATE';

    -- Drop trigger if it exists
    IF trigger_exists > 0 THEN
        EXECUTE IMMEDIATE 'DROP TRIGGER TRIGGER_PAYMENT_STATUS_UPDATE';
        DBMS_OUTPUT.PUT_LINE('Trigger TRIGGER_PAYMENT_STATUS_UPDATE dropped.');
    END IF;

    -- Create the trigger
    EXECUTE IMMEDIATE '
        CREATE OR REPLACE TRIGGER TRIGGER_PAYMENT_STATUS_UPDATE
        AFTER UPDATE OF PAYMENT_STATUS ON PAYMENT
        FOR EACH ROW
        DECLARE
            v_claim_status VARCHAR2(20);
        BEGIN
            -- Determine claim status based on payment status
            IF :NEW.PAYMENT_STATUS = ''Completed'' THEN
                v_claim_status := ''Closed'';
            ELSIF :NEW.PAYMENT_STATUS = ''Partial'' THEN
                v_claim_status := ''In Progress'';
            ELSIF :NEW.PAYMENT_STATUS = ''Failed'' THEN
                v_claim_status := ''Pending Payment'';
            END IF;

            -- Update the CLAIM table with the new claim status
            UPDATE CLAIM
            SET CLAIM_STATUS = v_claim_status
            WHERE CLAIM_ID = :NEW.CLAIM_ID;

            -- Output a message for debugging/logging
            DBMS_OUTPUT.PUT_LINE(''Payment status updated: '' || :NEW.PAYMENT_STATUS || 
                                 '', Claim status updated to: '' || v_claim_status);
        END;
    ';

    DBMS_OUTPUT.PUT_LINE('Trigger TRIGGER_PAYMENT_STATUS_UPDATE created successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred while creating the trigger: ' || SQLERRM);
END;
/

COMMIT;


/*

Test cases:
UPDATE PAYMENT
SET PAYMENT_STATUS = 'Completed'
WHERE PAYMENT_ID = 3;


SELECT CLAIM_ID, CLAIM_STATUS 
FROM CLAIM 
WHERE CLAIM_ID = (SELECT CLAIM_ID FROM PAYMENT WHERE PAYMENT_ID = 3);
 
*/