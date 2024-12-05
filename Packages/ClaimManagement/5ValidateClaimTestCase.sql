/*
MANAGER and ADJUSTER can run it
*/

SET SERVEROUTPUT ON;

DECLARE
    v_claim_id        ICPS_CORE.CLAIM.CLAIM_ID%TYPE;
    v_error_code      NUMBER;
    v_error_message   VARCHAR2(4000);
BEGIN
    -- Test Case 1: Validate a claim in "In Progress" status
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Test Case 1: Validating a claim with status "In Progress"...');
        
        -- Execute the procedure with schema prefix
        ICPS_CORE.ValidateClaimWrapper(
            p_claim_id => 4 -- Replace with an actual claim_id in "In Progress" status
        );

        DBMS_OUTPUT.PUT_LINE('Claim validation successful for Claim ID: 1');

    EXCEPTION
        WHEN OTHERS THEN
            v_error_code := SQLCODE;
            v_error_message := SQLERRM;
            DBMS_OUTPUT.PUT_LINE('Error in Test Case 1: ' || v_error_message);
    END;

    -- Test Case 2: Attempt to validate a claim with status not "In Progress"
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Test Case 2: Attempting to validate a claim not in "In Progress" status...');
        
        -- Set a claim status to "Closed" or another invalid state for validation
        UPDATE ICPS_CORE.CLAIM
        SET CLAIM_STATUS = 'Settled'
        WHERE CLAIM_ID = 2;

        COMMIT;

        -- Execute the procedure
        ICPS_CORE.ValidateClaimWrapper(
            p_claim_id => 2 -- Replace with an actual claim_id
        );

        DBMS_OUTPUT.PUT_LINE('Test Case 2 failed: Claim validated despite invalid status.');

    EXCEPTION
        WHEN OTHERS THEN
            v_error_code := SQLCODE;
            v_error_message := SQLERRM;
            IF v_error_code = -20005 THEN
                DBMS_OUTPUT.PUT_LINE('Test Case 2 passed: ' || v_error_message);
            ELSE
                DBMS_OUTPUT.PUT_LINE('Error in Test Case 2: ' || v_error_message);
            END IF;
    END;

    -- Test Case 3: Validate a non-existent claim
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Test Case 3: Validating a non-existent claim...');
        
        -- Execute the procedure with a non-existent claim_id
        ICPS_CORE.ValidateClaimWrapper(
            p_claim_id => 9999 -- Replace with a non-existent claim_id
        );

        DBMS_OUTPUT.PUT_LINE('Test Case 3 failed: Non-existent claim validated.');

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Claim does not exist');
        WHEN OTHERS THEN
            v_error_code := SQLCODE;
            v_error_message := SQLERRM;
            IF v_error_code = -20002 THEN
                DBMS_OUTPUT.PUT_LINE('Test Case 3 passed: ' || v_error_message);
            ELSE
                DBMS_OUTPUT.PUT_LINE('Error in Test Case 3: ' || v_error_message);
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
