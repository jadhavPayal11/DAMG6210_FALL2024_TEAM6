/*
    ORDER of Execution: Run this after creating the CLAIM table and POLICYHOLDER table.
    THIS SCRIPT SHOULD BE RUN BY ICPS_CORE.
*/

SET SERVEROUTPUT ON;

DECLARE
    trigger_exists INTEGER;

BEGIN
    -- Check if trigger exists
    SELECT COUNT(*) INTO trigger_exists
    FROM all_triggers
    WHERE trigger_name = 'NOTIFY_CUSTOMER_ON_CLAIM_UPDATE_TRIGGER';

    -- Drop trigger if it exists
    IF trigger_exists > 0 THEN
        EXECUTE IMMEDIATE 'DROP TRIGGER NOTIFY_CUSTOMER_ON_CLAIM_UPDATE_TRIGGER';
        DBMS_OUTPUT.PUT_LINE('Trigger NOTIFY_CUSTOMER_ON_CLAIM_UPDATE_TRIGGER dropped.');
    END IF;

    -- Create trigger
    EXECUTE IMMEDIATE '
        CREATE OR REPLACE TRIGGER NOTIFY_CUSTOMER_ON_CLAIM_UPDATE_TRIGGER
        AFTER UPDATE OF CLAIM_STATUS ON CLAIM
        FOR EACH ROW
        DECLARE
            v_policyholder_name VARCHAR2(100);
        BEGIN
            -- Retrieve policyholder name
            SELECT first_name || '' '' || last_name
            INTO v_policyholder_name
            FROM POLICYHOLDER
            WHERE POLICYHOLDER_ID = (
                SELECT POLICYHOLDER_ID
                FROM POLICY
                WHERE POLICY_ID = :NEW.POLICY_ID
            );

            -- Log a notification message for the customer
            DBMS_OUTPUT.PUT_LINE(''Notification: Claim ID '' || :NEW.CLAIM_ID || 
                                 '' status updated to '' || :NEW.CLAIM_STATUS || 
                                 ''. Dear '' || v_policyholder_name || 
                                 '', please check your claim status.'');

        END;
    ';

    DBMS_OUTPUT.PUT_LINE('Trigger NOTIFY_CUSTOMER_ON_CLAIM_UPDATE_TRIGGER created successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
COMMIT;

/*
UPDATE CLAIM
SET CLAIM_STATUS = 'Approved'
WHERE CLAIM_ID = 1;

-- Expected Result:
-- A message like "Notification: Claim ID 1 status updated to Approved. Dear [Customer Name], please check your claim status." 
*/
