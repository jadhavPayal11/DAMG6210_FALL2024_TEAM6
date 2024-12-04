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
