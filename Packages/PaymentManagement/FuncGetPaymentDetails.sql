SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION GetPaymentReport
RETURN VARCHAR2 IS
    payment_report VARCHAR2(4000);  -- Variable to store the report
    v_payment_id NUMBER;
    v_claim_id NUMBER;
    v_payment_date VARCHAR2(20);
    v_payment_amount NUMBER(10,2);
    v_payment_method VARCHAR2(20);
    v_payment_status VARCHAR2(20);
BEGIN
    -- Initialize the report string
    payment_report := 'Payment Report: ' || CHR(10);

    -- Loop through all payments and append details to the report
    FOR rec IN (SELECT payment_id, claim_id, TO_CHAR(payment_date, 'YYYY-MM-DD') AS payment_date,
                       payment_amount, payment_method, payment_status
                FROM PAYMENT) LOOP
        payment_report := payment_report || 
                          'Payment ID: ' || rec.payment_id || ', ' ||
                          'Claim ID: ' || rec.claim_id || ', ' ||
                          'Payment Date: ' || rec.payment_date || ', ' ||
                          'Amount: ' || rec.payment_amount || ', ' ||
                          'Method: ' || rec.payment_method || ', ' ||
                          'Status: ' || rec.payment_status || CHR(10);
    END LOOP;

    -- If no data is returned, notify the user
    IF payment_report = 'Payment Report: ' || CHR(10) THEN
        payment_report := 'No payments found for the given criteria.' || CHR(10);
    END IF;

    RETURN payment_report;

EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error occurred: ' || SQLERRM;
END;
/





