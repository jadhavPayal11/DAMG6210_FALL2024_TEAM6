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