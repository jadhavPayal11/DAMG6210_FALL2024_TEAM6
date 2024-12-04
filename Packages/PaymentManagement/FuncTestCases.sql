DECLARE
    report VARCHAR2(4000);
BEGIN
    -- Call the function to get the payment report
    report := GetPaymentReport;
    
    -- Output the report
    DBMS_OUTPUT.PUT_LINE(report);
END;
/
