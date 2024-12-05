SET SERVEROUTPUT ON;

DECLARE
    v_error_code      NUMBER;
    v_error_message   VARCHAR2(4000);
BEGIN
    -- Test Case 1: Update policy status to 'Active' for an existing policy
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Test Case 1: Updating policy status to "Active"...');
        
        -- Execute the procedure with schema prefix
        ICPS_CORE.UpdatePolicyStatusWrapper(
            p_policy_id => 1,
            p_policyholder_id => 1001,
            p_new_status => 'Active'
        );

        DBMS_OUTPUT.PUT_LINE('Test Case 1 Passed: Policy status updated to "Active".');
        
        -- Verify the policy status
        DECLARE
            v_status VARCHAR2(20);
        BEGIN
            SELECT POLICY_STATUS
            INTO v_status
            FROM ICPS_CORE.POLICY
            WHERE POLICY_ID = 1;

            IF v_status = 'Active' THEN
                DBMS_OUTPUT.PUT_LINE('Verified: Policy status is "Active".');
            ELSE
                DBMS_OUTPUT.PUT_LINE('Verification Failed: Expected "Active" but found "' || v_status || '".');
            END IF;
        END;
    EXCEPTION
        WHEN OTHERS THEN
            v_error_code := SQLCODE;
            v_error_message := SQLERRM;
            DBMS_OUTPUT.PUT_LINE('Error in Test Case 1: ' || v_error_message);
    END;

    -- Test Case 2: Update policy status for a non-existent policy
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Test Case 2: Attempting to update status for a non-existent policy...');
        
        -- Execute the procedure
        ICPS_CORE.UpdatePolicyStatusWrapper(
            p_policy_id => 9999, -- Non-existent policy ID
            p_policyholder_id => 1001,
            p_new_status => 'Active'
        );

        DBMS_OUTPUT.PUT_LINE('Test Case 2 Failed: Status updated for a non-existent policy.');
    EXCEPTION
        WHEN OTHERS THEN
            v_error_code := SQLCODE;
            v_error_message := SQLERRM;
            IF v_error_code = -20002 THEN
                DBMS_OUTPUT.PUT_LINE('Test Case 2 Passed: ' || v_error_message);
            ELSE
                DBMS_OUTPUT.PUT_LINE('Error in Test Case 2: ' || v_error_message);
            END IF;
    END;

    -- Test Case 3: Update policy status with an invalid policyholder ID
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Test Case 3: Attempting to update status with invalid policyholder ID...');
        
        -- Execute the procedure
        ICPS_CORE.UpdatePolicyStatusWrapper(
            p_policy_id => 1, -- Existing policy ID
            p_policyholder_id => 9999, -- Invalid policyholder ID
            p_new_status => 'Expired'
        );

        DBMS_OUTPUT.PUT_LINE('Test Case 3 Failed: Status updated with an invalid policyholder ID.');
    EXCEPTION
        WHEN OTHERS THEN
            v_error_code := SQLCODE;
            v_error_message := SQLERRM;
            IF v_error_code = -20003 THEN
                DBMS_OUTPUT.PUT_LINE('Test Case 3 Passed: ' || v_error_message);
            ELSE
                DBMS_OUTPUT.PUT_LINE('Error in Test Case 3: ' || v_error_message);
            END IF;
    END;

    -- Test Case 4: Update policy status with an invalid status value
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Test Case 4: Attempting to update status with an invalid status value...');
        
        -- Execute the procedure
        ICPS_CORE.UpdatePolicyStatusWrapper(
            p_policy_id => 1,
            p_policyholder_id => 1001,
            p_new_status => 'InvalidStatus' -- Invalid status
        );

        DBMS_OUTPUT.PUT_LINE('Test Case 4 Failed: Status updated with an invalid status value.');
    EXCEPTION
        WHEN OTHERS THEN
            v_error_code := SQLCODE;
            v_error_message := SQLERRM;
            IF v_error_code = -20004 THEN
                DBMS_OUTPUT.PUT_LINE('Test Case 4 Passed: ' || v_error_message);
            ELSE
                DBMS_OUTPUT.PUT_LINE('Error in Test Case 4: ' || v_error_message);
            END IF;
    END;
END;
/

COMMIT;

/*
-- Verify POLICY table contents
SELECT * FROM ICPS_CORE.POLICY ORDER BY POLICY_ID;
*/
