SET SERVEROUTPUT ON;

BEGIN
    -- Creating Application with all valid details
    ICPS_CORE.CREATE_APPLICATION_WRAPPER_PROC(
        p_first_name => 'Sushma',
        p_last_name => 'Mangalampati',
        p_dob => to_date('04-12-1997', 'DD-MM-YYYY'),
        p_email => 'saisushma412@gmail.com',
        p_contact => '9876543210',
        p_address_line_1 => '123 Main St',
        p_address_line_2 => 'Apt 4B',
        p_city => 'New York',
        p_state => 'New York',
        p_zipcode => '10001',
        p_country => 'USA',
        p_provider_name => 'HealthFirst Insurance',
        p_insurance_type => 'Health Insurance'
        );
END;
/

BEGIN
    -- Creating Application with invalid details
    ICPS_CORE.CREATE_APPLICATION_WRAPPER_PROC(
        p_first_name => 'Sushm@',
        p_last_name => 'Mangalampati',
        p_dob => to_date('04-12-1997', 'DD-MM-YYYY'),
        p_email => 'sushma.mangalampati@gmail.com',
        p_contact => '9876543211',
        p_address_line_1 => '123 Main St',
        p_address_line_2 => 'Apt 4B',
        p_city => 'New York',
        p_state => 'New York',
        p_zipcode => '10001',
        p_country => 'USA',
        p_provider_name => 'HealthFirst Insurance',
        p_insurance_type => 'Health Insurance'
        );
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
