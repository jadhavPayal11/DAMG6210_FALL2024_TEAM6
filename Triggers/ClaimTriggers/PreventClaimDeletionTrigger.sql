/* 
    ORDER of Execution: After Claim-related triggers
    THIS SCRIPT SHOULD BE RUN BY ICPS_CORE.
*/

SET SERVEROUTPUT ON;

ALTER SESSION SET CURRENT_SCHEMA = ICPS_CORE;


DECLARE
    trigger_exists INTEGER;

BEGIN
    -- Check if the trigger already exists
    SELECT COUNT(*) INTO trigger_exists
    FROM all_triggers
    WHERE trigger_name = 'PREVENT_CLAIM_DELETION_TRIGGER';

    -- Drop the trigger if it exists
    IF trigger_exists > 0 THEN
        EXECUTE IMMEDIATE 'DROP TRIGGER PREVENT_CLAIM_DELETION_TRIGGER';
        DBMS_OUTPUT.PUT_LINE('Trigger PREVENT_CLAIM_DELETION_TRIGGER dropped.');
    END IF;

    -- Create the new trigger
    EXECUTE IMMEDIATE '
        CREATE OR REPLACE TRIGGER PREVENT_CLAIM_DELETION_TRIGGER
        BEFORE DELETE ON CLAIM
        FOR EACH ROW
        DECLARE
            v_policy_status VARCHAR2(20);
        BEGIN
            -- Fetch the policy status for the policy associated with the claim
            SELECT policy_status
            INTO v_policy_status
            FROM POLICY
            WHERE policy_id = :OLD.policy_id;

            -- Prevent deletion if the policy is active
            IF v_policy_status = ''Active'' THEN
                RAISE_APPLICATION_ERROR(-20002, ''Cannot delete claim: Policy is active.'');
            END IF;
        END;
    ';

    DBMS_OUTPUT.PUT_LINE('Trigger PREVENT_CLAIM_DELETION_TRIGGER created successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/

COMMIT;

/*
SELECT TRIGGER_NAME, STATUS FROM USER_TRIGGERS WHERE TABLE_NAME = 'Claim';

*/