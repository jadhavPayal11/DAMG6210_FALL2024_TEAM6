/* 
    File: PolicyExpirationCheck.sql
    Description: Trigger to automatically update the status of expired policies.
    Execution: Should be run by ICPS_CORE.
*/

SET SERVEROUTPUT ON;

DECLARE
    trigger_exists INTEGER;

BEGIN
    -- Check if trigger exists
    SELECT COUNT(*) INTO trigger_exists
    FROM all_triggers
    WHERE trigger_name = 'POLICY_EXPIRATION_CHECK';

    -- Drop trigger if it exists
    IF trigger_exists > 0 THEN
        EXECUTE IMMEDIATE 'DROP TRIGGER POLICY_EXPIRATION_CHECK';
        DBMS_OUTPUT.PUT_LINE('Trigger POLICY_EXPIRATION_CHECK dropped.');
    END IF;

    -- Create the trigger
    EXECUTE IMMEDIATE '
        CREATE OR REPLACE TRIGGER POLICY_EXPIRATION_CHECK
        BEFORE INSERT OR UPDATE ON POLICY
        FOR EACH ROW
        BEGIN
            -- Check if the policy end_date is in the past
            IF :NEW.end_date < SYSDATE THEN
                :NEW.policy_status := ''Expired'';
                DBMS_OUTPUT.PUT_LINE(''Policy Expired, please renew it'');
            END IF;
        END;
    ';

    DBMS_OUTPUT.PUT_LINE('Trigger POLICY_EXPIRATION_CHECK created successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
COMMIT;

/*
UPDATE POLICY
SET END_DATE = TO_DATE('2023-11-30', 'YYYY-MM-DD')
WHERE POLICY_ID = 101;

UPDATE PAYMENT
SET PAYMENT_STATUS = 'Failed'
WHERE PAYMENT_ID = 3;

SELECT CLAIM_ID, CLAIM_STATUS 
FROM CLAIM 
WHERE CLAIM_ID = (SELECT CLAIM_ID FROM PAYMENT WHERE PAYMENT_ID = 3);



*/