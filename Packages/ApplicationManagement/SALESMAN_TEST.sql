SET SERVEROUTPUT ON;

BEGIN
    -- Creating Application with all valid details
    ICPS_CORE.CREATE_APPLICATION_WRAPPER_PROC(
        'Sushma',
        'Mangalampati',
        to_date('04-12-1997', 'DD-MM-YYYY'),
        'saisushma412@gmail.com',
        '9876543210',
        '123 Main St',
        'Apt 4B',
        'New York',
        'New York',
        '10001',
        'USA',
        'HealthFirst Insurance',
        'Health Insurance'
        );
END;
/

BEGIN
    -- Creating Application with invalid details
    ICPS_CORE.CREATE_APPLICATION_WRAPPER_PROC(
        'Sushma',
        'Mangalampati',
        to_date('04-12-1997', 'DD-MM-YYYY'),
        'sushma.mangalampati@gmail.com',
        '9876543211',
        '123 Main St',
        'Apt 4B',
        'New York',
        'New York',
        '10001',
        'USA',
        'HealthFirst Insurance',
        'Health Insurance'
        );
END;
/
