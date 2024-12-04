SET SERVEROUTPUT ON;

DECLARE
    v_claim_id        CLAIM.CLAIM_ID%TYPE;
    v_log_entry_count INTEGER;
    v_error_code      NUMBER;
    v_error_message   VARCHAR2(4000);
BEGIN
    -- Test Case 1: Submit a valid claim
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Test Case 1: Submitting a valid claim...');
        
        -- Execute the procedure
        ClaimLifecyclePackage.SubmitClaim(
            p_policy_id => 1,
            p_agent_id => 1,
            p_claim_date => SYSDATE,
            p_claim_type => 'Accident',
            p_claim_description => 'Minor accident involving a scratch.',
            p_claim_amount => 5000,
            p_claim_status => 'In Progress',
            p_claim_priority => 'Medium',
            p_estimated_settlement_date => SYSDATE + 15
        );

        DBMS_OUTPUT.PUT_LINE('Claim submitted successfully.');

        -- Fetch the latest claim ID
        SELECT MAX(CLAIM_ID)
        INTO v_claim_id
        FROM CLAIM;

        -- Verify the CLAIM_LOG entry
        SELECT COUNT(*)
        INTO v_log_entry_count
        FROM CLAIM_LOG
        WHERE CLAIM_ID = v_claim_id;

        IF v_log_entry_count > 0 THEN
            DBMS_OUTPUT.PUT_LINE('CLAIM_LOG entry verified successfully.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('CLAIM_LOG entry missing for Claim ID: ' || v_claim_id);
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            v_error_code := SQLCODE;
            v_error_message := SQLERRM;
            DBMS_OUTPUT.PUT_LINE('Error in Test Case 1: ' || v_error_message);
    END;
    
    -- Test Case 2: Policy Not Active
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Test Case 2: Submitting a claim for an inactive policy...');

        -- Set the policy status to 'Expired'
        UPDATE POLICY
        SET POLICY_STATUS = 'Expired'
        WHERE POLICY_ID = 2;

        COMMIT;

        -- Execute the procedure
        ClaimLifecyclePackage.SubmitClaim(
            p_policy_id => 2,
            p_agent_id => 2,
            p_claim_date => SYSDATE,
            p_claim_type => 'Theft',
            p_claim_description => 'Vehicle theft.',
            p_claim_amount => 8000,
            p_claim_status => 'Pending',
            p_claim_priority => 'High',
            p_estimated_settlement_date => SYSDATE + 10
        );

        DBMS_OUTPUT.PUT_LINE('Test Case 2 failed: Claim submitted for an inactive policy.');
    EXCEPTION
        WHEN OTHERS THEN
            v_error_code := SQLCODE;
            v_error_message := SQLERRM;
            IF v_error_code = -20004 THEN
                DBMS_OUTPUT.PUT_LINE('Test Case 2 passed: ' || v_error_message);
            ELSE
                DBMS_OUTPUT.PUT_LINE('Error in Test Case 2: ' || v_error_message);
            END IF;
    END;
    
    -- Test Case 3: Policyholder does not exist
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Test Case 3: Submitting a claim for a non-existent policyholder...');
        
        -- Execute the procedure with a policy ID that has no associated policyholder
        ClaimLifecyclePackage.SubmitClaim(
            p_policy_id => 999, -- Non-existent policy ID
            p_agent_id => 3,
            p_claim_date => SYSDATE,
            p_claim_type => 'Fire',
            p_claim_description => 'Fire damage in the vehicle.',
            p_claim_amount => 10000,
            p_claim_status => 'Pending',
            p_claim_priority => 'Critical',
            p_estimated_settlement_date => SYSDATE + 20
        );

        DBMS_OUTPUT.PUT_LINE('Test Case 3 failed: Claim submitted for a non-existent policyholder.');
    EXCEPTION
        WHEN OTHERS THEN
            v_error_code := SQLCODE;
            v_error_message := SQLERRM;
            IF v_error_code = -20002 THEN
                DBMS_OUTPUT.PUT_LINE('Test Case 3 passed: ' || v_error_message);
            ELSE
                DBMS_OUTPUT.PUT_LINE('Error in Test Case 3: ' || v_error_message);
            END IF;
    END;

    -- Test Case 4: Claim exceeding coverage amount
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Test Case 4: Submitting a claim exceeding the policy coverage amount...');

        -- Insert existing claims to simulate a near-coverage limit scenario
        INSERT INTO CLAIM (CLAIM_ID, POLICY_ID, AGENT_ID, CLAIM_DATE, CLAIM_TYPE, CLAIM_DESCRIPTION, CLAIM_AMOUNT, CLAIM_STATUS, CLAIM_PRIORITY, ESTIMATED_SETTLEMENT_DATE)
        VALUES (CLAIM_SEQ.NEXTVAL, 1, 1, SYSDATE - 10, 'Accident', 'Existing damage.', 9500, 'In Progress', 'Low', SYSDATE + 5);

        COMMIT;

        -- Execute the procedure with a claim that exceeds coverage
        ClaimLifecyclePackage.SubmitClaim(
            p_policy_id => 1,
            p_agent_id => 1,
            p_claim_date => SYSDATE,
            p_claim_type => 'Accident',
            p_claim_description => 'Exceeding coverage test.',
            p_claim_amount => 1000,
            p_claim_status => 'Pending',
            p_claim_priority => 'High',
            p_estimated_settlement_date => SYSDATE + 15
        );

        DBMS_OUTPUT.PUT_LINE('Test Case 4 failed: Claim exceeding coverage amount submitted.');
    EXCEPTION
        WHEN OTHERS THEN
            v_error_code := SQLCODE;
            v_error_message := SQLERRM;
            IF v_error_code = -20005 THEN
                DBMS_OUTPUT.PUT_LINE('Test Case 4 passed: ' || v_error_message);
            ELSE
                DBMS_OUTPUT.PUT_LINE('Error in Test Case 4: ' || v_error_message);
            END IF;
    END;

END;
/

COMMIT;

-- Display current CLAIM and CLAIM_LOG tables for verification
SELECT * FROM CLAIM ORDER BY CLAIM_ID;
SELECT * FROM CLAIM_LOG ORDER BY LOG_ID;
