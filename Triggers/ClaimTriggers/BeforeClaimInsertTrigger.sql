/* 
    ORDER of Execution: 1st Trigger but after InsertRecords.sql
    THIS SCRIPT SHOULD BE RUN BY ICPS_CORE.
*/

SET SERVEROUTPUT ON;

DECLARE
    trigger_exists INTEGER;

BEGIN
    -- Check if trigger exists
    SELECT COUNT(*) INTO trigger_exists
    FROM all_triggers
    WHERE trigger_name = 'BEFORE_CLAIM_INSERT_TRIGGER';

    -- Drop trigger if exists
    IF trigger_exists > 0 THEN
        EXECUTE IMMEDIATE 'DROP TRIGGER BEFORE_CLAIM_INSERT_TRIGGER';
        DBMS_OUTPUT.PUT_LINE('Trigger BEFORE_CLAIM_INSERT_TRIGGER dropped.');
    END IF;

    -- Create trigger
    EXECUTE IMMEDIATE '
        CREATE OR REPLACE TRIGGER BEFORE_CLAIM_INSERT_TRIGGER
        BEFORE INSERT ON CLAIM
        FOR EACH ROW
        DECLARE
            v_policy_status VARCHAR2(20);
        BEGIN
            -- Fetch policy status
            SELECT policy_status
            INTO v_policy_status
            FROM POLICY
            WHERE policy_id = :NEW.policy_id;

            -- Validate if policy is active
            IF v_policy_status != ''Active'' THEN
                RAISE_APPLICATION_ERROR(-20001, ''Cannot insert claim: Policy is not active.'');
            END IF;
        END;
    ';

    DBMS_OUTPUT.PUT_LINE('Trigger BEFORE_CLAIM_INSERT_TRIGGER created successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/

/* Test- These can be run only once:
SELECT TRIGGER_NAME, STATUS FROM USER_TRIGGERS WHERE TABLE_NAME = 'CLAIM';
-- 0. Positive Test case:
INSERT INTO CLAIM (claim_id, policy_id, agent_id, claim_date, claim_type, claim_description, claim_amount, claim_status, claim_priority, estimated_settlement_date)
VALUES (201, 101, 1, TO_DATE('2024-12-01', 'YYYY-MM-DD'), 'Accident', 'Minor accident involving a scratch', 1000, 'Pending', 'Medium', TO_DATE('2024-12-15', 'YYYY-MM-DD'));

-- 1. Test case: Policy Not Active
UPDATE POLICY SET POLICY_STATUS = 'Expired' WHERE POLICY_ID = 102;

INSERT INTO CLAIM (claim_id, policy_id, agent_id, claim_date, claim_type, claim_description, claim_amount, claim_status, claim_priority, estimated_settlement_date)
VALUES (202, 102, 2, TO_DATE('2024-12-01', 'YYYY-MM-DD'), 'Theft', 'Theft of vehicle parts', 5000, 'Pending', 'High', TO_DATE('2024-12-20', 'YYYY-MM-DD'));

-- 2. Test case: Non-existent Policy:
INSERT INTO CLAIM (claim_id, policy_id, agent_id, claim_date, claim_type, claim_description, claim_amount, claim_status, claim_priority, estimated_settlement_date)
VALUES (203, 999, 3, TO_DATE('2024-12-01', 'YYYY-MM-DD'), 'Fire', 'Damage due to fire in the engine', 7000, 'Pending', 'Critical', TO_DATE('2024-12-25', 'YYYY-MM-DD'));

-- 3. Negative Test Case:
UPDATE POLICY SET POLICY_STATUS = 'Pending' WHERE POLICY_ID = 103;

INSERT INTO CLAIM (claim_id, policy_id, agent_id, claim_date, claim_type, claim_description, claim_amount, claim_status, claim_priority, estimated_settlement_date)
VALUES (204, 103, 3, TO_DATE('2024-12-01', 'YYYY-MM-DD'), 'Fire', 'Damage due to fire in the engine', 7000, 'Pending', 'Critical', TO_DATE('2024-12-25', 'YYYY-MM-DD'));

*/


COMMIT;
