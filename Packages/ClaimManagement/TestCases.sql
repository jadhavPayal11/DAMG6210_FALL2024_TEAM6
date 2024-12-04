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
        SubmitClaimWrapper(
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

END;
/

COMMIT;

