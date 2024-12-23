SET SERVEROUTPUT ON;

BEGIN
    -- Reviwing Application with valid details
    ICPS_CORE.REVIEW_APPLICATION_WRAPPER_PROC(
        p_application_id => 6,
        p_application_status => 'Approved',
        p_comments => 'Application has been approved',
        p_premium_amount => 150,
        p_coverage_amount => 10000);
END;
/

BEGIN
    -- Reviwing Application with valid details
    ICPS_CORE.REVIEW_APPLICATION_WRAPPER_PROC(
        p_application_id => 6,
        p_application_status => 'Approve',
        p_comments => 'Application has been approved',
        p_premium_amount => 150,
        p_coverage_amount => 10000);
END;
/

-- Get status of a valid application
DECLARE
v_application_status ICPS_CORE.INSURANCE_APPLICATION.STATUS%TYPE;
BEGIN
    v_application_status := ICPS_CORE.GET_APPLICATION_STATUS_WRAPPER_FUNC(
                                p_application_id => 1);
    dbms_output.put_line('Application status is: ' || v_application_status);
END;
/

-- Get status of an invalid application
DECLARE
v_application_status ICPS_CORE.INSURANCE_APPLICATION.STATUS%TYPE;
BEGIN
    v_application_status := ICPS_CORE.GET_APPLICATION_STATUS_WRAPPER_FUNC(
                                p_application_id => 8);
    dbms_output.put_line('Application status is: ' || v_application_status);
END;
/