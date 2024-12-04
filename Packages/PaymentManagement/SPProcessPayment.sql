CREATE OR REPLACE PROCEDURE ProcessPayment (
    p_payment_id IN NUMBER
) IS
    v_payment_status VARCHAR2(50);
BEGIN
    -- Fetch the payment status
    SELECT payment_status 
    INTO v_payment_status
    FROM PAYMENT
    WHERE payment_id = p_payment_id;

    IF v_payment_status = 'Completed' THEN
        DBMS_OUTPUT.PUT_LINE('Payment for this claim ID is already completed.');
    ELSE
        -- Update payment status
        UPDATE PAYMENT
        SET payment_status = 'Completed'
        WHERE payment_id = p_payment_id;

        -- Update related claim status
        UPDATE CLAIM
        SET claim_status = 'Settled'
        WHERE claim_id = (
            SELECT claim_id FROM PAYMENT WHERE payment_id = p_payment_id
        );

        DBMS_OUTPUT.PUT_LINE('Payment processed and claim status updated to Settled.');
    END IF;
END;
/
