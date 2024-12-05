SET SERVEROUTPUT ON;

DECLARE
    v_claim_id        ICPS_CORE.CLAIM.CLAIM_ID%TYPE;
    v_error_code      NUMBER;
    v_error_message   VARCHAR2(4000);
    v_status          ICPS_CORE.CLAIM.CLAIM_STATUS%TYPE;
    v_log_entry_count INTEGER;
BEGIN
    -- Test Case 1: Process a valid claim
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Test Case 1: Processing a valid claim...');
        
        -- Execute the procedure with schema prefix
        ICPS_CORE.ProcessClaimWrapper(
            p_claim_id => 4,
            p_approval_status => 'Approved',
            p_comments => 'Claim approved successfully.'
        );

        DBMS_OUTPUT.PUT_LINE('Claim processed successfully.');

        -- Verify the claim status
        SELECT CLAIM_STATUS
        INTO v_status
        FROM ICPS_CORE.CLAIM
        WHERE CLAIM_ID = 1; -- Replace with the same claim_id used above

        IF v_status = 'Approved' THEN
            DBMS_OUTPUT.PUT_LINE('Claim status updated successfully to "Approved".');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Test Case 1 failed: Claim status not updated as expected.');
        END IF;

        -- Verify the CLAIM_LOG entry
        SELECT COUNT(*)
        INTO v_log_entry_count
        FROM ICPS_CORE.CLAIM_LOG
        WHERE CLAIM_ID = 1;

        IF v_log_entry_count > 0 THEN
            DBMS_OUTPUT.PUT_LINE('CLAIM_LOG entry verified successfully.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('CLAIM_LOG entry missing for Claim ID: 1');
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            v_error_code := SQLCODE;
            v_error_message := SQLERRM;
            DBMS_OUTPUT.PUT_LINE('Error in Test Case 1: ' || v_error_message);
    END;

    -- Test Case 2: Attempt to process a claim with invalid status
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Test Case 2: Attempting to process a claim not in "In Progress" status...');
        
        -- Set the claim status to "Closed"
        UPDATE ICPS_CORE.CLAIM
        SET CLAIM_STATUS = 'Settled'
        WHERE CLAIM_ID = 2;

        COMMIT;

        -- Execute the procedure
        ICPS_CORE.ProcessClaimWrapper(
            p_claim_id => 2, -- Replace with a claim_id that is not in "In Progress" status
            p_approval_status => 'Rejected',
            p_comments => 'Claim rejected due to invalid conditions.'
        );

        DBMS_OUTPUT.PUT_LINE('Test Case 2 failed: Claim processed despite invalid status.');

    EXCEPTION
        WHEN OTHERS THEN
            v_error_code := SQLCODE;
            v_error_message := SQLERRM;
            IF v_error_code = -20006 THEN
                DBMS_OUTPUT.PUT_LINE('Test Case 2 passed: ' || v_error_message);
            ELSE
                DBMS_OUTPUT.PUT_LINE('Error in Test Case 2: ' || v_error_message);
            END IF;
    END;

END;
/

COMMIT;

/*
-- Verify CLAIM table contents
SELECT * FROM ICPS_CORE.CLAIM ORDER BY CLAIM_ID;

-- Verify CLAIM_LOG table contents
SELECT * FROM ICPS_CORE.CLAIM_LOG ORDER BY LOG_ID;

SELECT * FROM ICPS_CORE.POLICY ORDER BY POLICY_ID;
*/
