CREATE OR REPLACE PACKAGE PaymentManagement AS
    -- Function to get a payment report
    FUNCTION GetPaymentReport(
    p_claim_id IN PAYMENT.CLAIM_ID%TYPE
    ) RETURN VARCHAR2;
    
    -- Procedure to process payment (example placeholder)
    PROCEDURE ProcessPayment(
        p_claim_id IN NUMBER,
        p_payment_status IN VARCHAR2
    );
END PaymentManagement;
/
