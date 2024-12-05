-- For stored procedure
-- Test Case 1: Update payment status and claim status successfully
BEGIN
    PROCESS_PAYMENT_WRAPPER_PROC(
        p_claim_id => 1, -- Existing Claim ID with payment status not "Completed"
        p_payment_status => 'Completed'
    );
    -- Expected Output: Payment status updated for Claim ID: 101
    -- Verify: Check if payment status is updated to "Completed" and claim status is updated to "Settled".
END;
/

BEGIN
    PROCESS_PAYMENT_WRAPPER_PROC(
        p_claim_id => 2, -- Existing Claim ID with payment status not "Completed"
        p_payment_status => 'Completed'
    );
    -- Expected Output: Payment status updated for Claim ID: 101
    -- Verify: Check if payment status is updated to "Completed" and claim status is updated to "Settled".
END;
/

-- For Function
-- Test Case 1: Fetch payment details for a valid Claim ID
SET SERVEROUTPUT ON;

DECLARE
    payment_cursor SYS_REFCURSOR;
    payment_record PAYMENT%ROWTYPE; -- Record to hold payment details
BEGIN
    -- Call the wrapper function with a valid Claim ID
    payment_cursor := GET_PAYMENT_DETAILS_WRAPPER_FUNC(1); -- Meention existing Claim ID in your data

    -- Loop through the cursor to fetch records
    LOOP
        FETCH payment_cursor INTO payment_record;
        EXIT WHEN payment_cursor%NOTFOUND;

        -- Print the fetched payment details
        DBMS_OUTPUT.PUT_LINE(
            'Payment ID: ' || payment_record.payment_id || 
            ', Claim ID: ' || payment_record.claim_id || 
            ', Payment Date: ' || payment_record.payment_date || 
            ', Payment Amount: ' || payment_record.payment_amount || 
            ', Payment Method: ' || payment_record.payment_method || 
            ', Payment Status: ' || payment_record.payment_status
        );
    END LOOP;

    -- Close the cursor
    CLOSE payment_cursor;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error during test execution: ' || SQLERRM);
END;
/
