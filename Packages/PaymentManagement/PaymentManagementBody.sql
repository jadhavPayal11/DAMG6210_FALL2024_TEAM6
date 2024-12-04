CREATE OR REPLACE PACKAGE BODY paymentmanagement AS

    -- Function to generate a payment report
    FUNCTION getpaymentreport(
     p_claim_id IN PAYMENT.CLAIM_ID%TYPE
    ) RETURN VARCHAR2 IS
        payment_report VARCHAR2(4000);
    BEGIN
        -- Initialize the report
        payment_report := 'Payment Report: ' || chr(10);
        
        -- Fetch payment details and append to the report
        FOR rec IN (
            SELECT
                payment_id,
                claim_id,
                to_char(payment_date, 'YYYY-MM-DD') AS payment_date,
                payment_amount,
                payment_method,
                payment_status
            FROM
                payment
            WHERE
            CLAIM_ID = P_CLAIM_ID
        ) LOOP
            payment_report := payment_report
                              || 'Payment ID: '
                              || rec.payment_id
                              || ', '
                              || 'Claim ID: '
                              || rec.claim_id
                              || ', '
                              || 'Payment Date: '
                              || rec.payment_date
                              || ', '
                              || 'Amount: '
                              || rec.payment_amount
                              || ', '
                              || 'Method: '
                              || rec.payment_method
                              || ', '
                              || 'Status: '
                              || rec.payment_status
                              || chr(10);
        END LOOP;
        
        -- Handle case where no records are found
        IF payment_report = 'Payment Report: ' || chr(10) THEN
            payment_report := 'No payments found.';
        END IF;

        RETURN payment_report;
    END getpaymentreport;


    -- Procedure to process payment
    PROCEDURE processpayment (
        p_claim_id       IN NUMBER,
        p_payment_status IN VARCHAR2
    ) IS
        payment_exists NUMBER;
        claim_status   VARCHAR2(20);
    BEGIN
    -- Check if the payment exists for the claim ID
        SELECT
            COUNT(*)
        INTO payment_exists
        FROM
            payment
        WHERE
            claim_id = p_claim_id;

        IF payment_exists = 0 THEN
            dbms_output.put_line('No payments found for Claim ID: ' || p_claim_id);
        ELSE
        -- Check claim status
            SELECT
                claim_status
            INTO claim_status
            FROM
                claim
            WHERE
                claim_id = p_claim_id;

            IF claim_status != 'Approved' THEN
                dbms_output.put_line('Claim ID: '
                                     || p_claim_id
                                     || ' is not Approved. Payment cannot be processed.');
            ELSE
            -- Update payment status
                UPDATE payment
                SET
                    payment_status = p_payment_status
                WHERE
                    claim_id = p_claim_id;

            -- Optionally update claim status as well
                UPDATE claim
                SET
                    claim_status = 'Settled'
                WHERE
                    claim_id = p_claim_id;

                dbms_output.put_line('Payment status updated for Claim ID: ' || p_claim_id);
            END IF;

        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Error in ProcessPayment: ' || sqlerrm);
    END processpayment;

END paymentmanagement;
/