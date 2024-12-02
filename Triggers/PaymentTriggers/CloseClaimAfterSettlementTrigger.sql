/*
    ORDER of Execution: Run this after creating the PAYMENT table and the InsertRecords.sql.
    THIS SCRIPT SHOULD BE RUN BY ICPS_CORE.
*/

SET SERVEROUTPUT ON;

DECLARE
    trigger_exists INTEGER;

BEGIN
    -- Check if trigger exists
    SELECT COUNT(*) INTO trigger_exists
    FROM all_triggers
    WHERE trigger_name = 'CLOSE_CLAIM_AFTER_SETTLEMENT_TRIGGER';

    -- Drop trigger if it exists
    IF trigger_exists > 0 THEN
        EXECUTE IMMEDIATE 'DROP TRIGGER CLOSE_CLAIM_AFTER_SETTLEMENT_TRIGGER';
        DBMS_OUTPUT.PUT_LINE('Trigger CLOSE_CLAIM_AFTER_SETTLEMENT_TRIGGER dropped.');
    END IF;

    -- Create trigger
    EXECUTE IMMEDIATE '
        CREATE OR REPLACE TRIGGER CLOSE_CLAIM_AFTER_SETTLEMENT_TRIGGER
        AFTER UPDATE OF PAYMENT_STATUS ON PAYMENT
        FOR EACH ROW
        BEGIN
            -- Check if the payment status is "Completed"
            IF :NEW.PAYMENT_STATUS = ''Completed'' THEN
                -- Update the CLAIM table to mark the claim as "Closed"
                UPDATE CLAIM
                SET CLAIM_STATUS = ''Closed''
                WHERE CLAIM_ID = :NEW.CLAIM_ID;

                DBMS_OUTPUT.PUT_LINE(''Claim '' || :NEW.CLAIM_ID || '' has been closed after settlement.'');
            END IF;
        END;
    ';

    DBMS_OUTPUT.PUT_LINE('Trigger CLOSE_CLAIM_AFTER_SETTLEMENT_TRIGGER created successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
COMMIT;

/*
/*
UPDATE PAYMENT
SET PAYMENT_STATUS = 'Completed'
WHERE PAYMENT_ID = 4;

-- Expected Result:
-- CLAIM_STATUS for CLAIM_ID associated with PAYMENT_ID 4 should be updated to "Closed".
*/

*/
