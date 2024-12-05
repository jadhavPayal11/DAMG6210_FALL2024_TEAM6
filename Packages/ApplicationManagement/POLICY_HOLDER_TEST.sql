SET SERVEROUTPUT ON;

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