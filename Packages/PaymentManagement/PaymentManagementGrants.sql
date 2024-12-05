SET SERVEROUTPUT ON;

-- Wrapper Procedure for Processing Payment
CREATE OR REPLACE PROCEDURE PROCESS_PAYMENT_WRAPPER_PROC(
    p_claim_id IN PAYMENT.CLAIM_ID%TYPE,
    p_payment_status IN PAYMENT.PAYMENT_STATUS%TYPE
) AS
    current_status VARCHAR2(20);
BEGIN
    -- Check current payment status
    SELECT payment_status
    INTO current_status
    FROM payment
    WHERE claim_id = p_claim_id;

    IF current_status = 'Completed' THEN
        DBMS_OUTPUT.PUT_LINE('Payment for Claim ID ' || p_claim_id || ' is already completed.');
    ELSE
        -- Update payment status
        UPDATE payment
        SET payment_status = p_payment_status
        WHERE claim_id = p_claim_id;

        -- Update claim status to 'Settled'
        UPDATE claim
        SET claim_status = 'Settled'
        WHERE claim_id = p_claim_id;

        DBMS_OUTPUT.PUT_LINE('Payment status updated for Claim ID: ' || p_claim_id);
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No payment found for Claim ID: ' || p_claim_id);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in PROCESS_PAYMENT_WRAPPER_PROC: ' || SQLERRM);
END PROCESS_PAYMENT_WRAPPER_PROC;
/

-- Wrapper Function for Getting Payment Details
CREATE OR REPLACE FUNCTION GET_PAYMENT_DETAILS_WRAPPER_FUNC(
    p_claim_id IN PAYMENT.CLAIM_ID%TYPE
) RETURN SYS_REFCURSOR AS
    payment_cursor SYS_REFCURSOR;
BEGIN
    -- Open cursor to fetch payment details for the given Claim ID
    OPEN payment_cursor FOR
        SELECT *
        FROM payment
        WHERE claim_id = p_claim_id;

    RETURN payment_cursor;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in GET_PAYMENT_DETAILS_WRAPPER_FUNC: ' || SQLERRM);
        RETURN NULL;
END GET_PAYMENT_DETAILS_WRAPPER_FUNC;
/

-- Granting Privileges
BEGIN
    -- Grant EXECUTE privilege on PROCESS_PAYMENT_WRAPPER_PROC to Adjuster
    EXECUTE IMMEDIATE 'GRANT EXECUTE ON PROCESS_PAYMENT_WRAPPER_PROC TO ADJUSTER';
    DBMS_OUTPUT.PUT_LINE('Grant on PROCESS_PAYMENT_WRAPPER_PROC to Adjuster successful!');

    -- Grant EXECUTE privilege on GET_PAYMENT_DETAILS_WRAPPER_FUNC to Adjuster, Manager, and PolicyHolder
    EXECUTE IMMEDIATE 'GRANT EXECUTE ON GET_PAYMENT_DETAILS_WRAPPER_FUNC TO ADJUSTER, MANAGER, POLICY_HOLDER';
    DBMS_OUTPUT.PUT_LINE('Grant on GET_PAYMENT_DETAILS_WRAPPER_FUNC to Adjuster, Manager, and PolicyHolder successful!');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred while granting privileges: ' || SQLERRM);
END;
/
