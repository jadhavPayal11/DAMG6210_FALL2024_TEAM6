/* 
    ORDER of Execution: #2 After InsertRecords.sql
    THIS SCRIPT SHOULD BE RUN BY ICPS_CORE.
*/

SET SERVEROUTPUT ON;

DECLARE
    trigger_exists INTEGER;

BEGIN
    -- Check if trigger exists
    SELECT COUNT(*) INTO trigger_exists
    FROM all_triggers
    WHERE trigger_name = 'GENERATE_CLAIM_ID_TRIGGER';

    -- Drop trigger if exists
    IF trigger_exists > 0 THEN
        EXECUTE IMMEDIATE 'DROP TRIGGER GENERATE_CLAIM_ID_TRIGGER';
        DBMS_OUTPUT.PUT_LINE('Trigger GENERATE_CLAIM_ID_TRIGGER dropped.');
    END IF;

    -- Create trigger
    EXECUTE IMMEDIATE '
        CREATE OR REPLACE TRIGGER GENERATE_CLAIM_ID_TRIGGER
        BEFORE INSERT ON CLAIM
        FOR EACH ROW
        DECLARE
            v_new_claim_id NUMBER;
        BEGIN
            -- Generate a new Claim ID by finding the maximum existing Claim ID and adding 1
            SELECT NVL(MAX(claim_id), 0) + 1
            INTO v_new_claim_id
            FROM CLAIM;

            -- Assign the new Claim ID to the :NEW record
            :NEW.claim_id := v_new_claim_id;
        END;
    ';

    DBMS_OUTPUT.PUT_LINE('Trigger GENERATE_CLAIM_ID_TRIGGER created successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/

/* Test Cases 
-- Check Trigger Status
SELECT TRIGGER_NAME, STATUS FROM USER_TRIGGERS WHERE TABLE_NAME = 'CLAIM';

-- 0. Positive Test Case: Insert Claim Without Claim ID
INSERT INTO CLAIM (policy_id, agent_id, claim_date, claim_type, claim_description, claim_amount, claim_status, claim_priority, estimated_settlement_date)
VALUES (101, 1, TO_DATE('2024-12-01', 'YYYY-MM-DD'), 'Accident', 'Minor accident involving a scratch', 1000, 'Pending', 'Medium', TO_DATE('2024-12-15', 'YYYY-MM-DD'));

-- 1. Positive Test Case: Insert Another Claim
INSERT INTO CLAIM (policy_id, agent_id, claim_date, claim_type, claim_description, claim_amount, claim_status, claim_priority, estimated_settlement_date)
VALUES (101, 2, TO_DATE('2024-12-01', 'YYYY-MM-DD'), 'Theft', 'Theft of vehicle parts', 5000, 'Pending', 'High', TO_DATE('2024-12-20', 'YYYY-MM-DD'));

-- 2. Test Case: Verify Automatically Generated Claim IDs
SELECT claim_id, policy_id, agent_id, claim_date, claim_type
FROM CLAIM
ORDER BY claim_id;


*/

COMMIT;
