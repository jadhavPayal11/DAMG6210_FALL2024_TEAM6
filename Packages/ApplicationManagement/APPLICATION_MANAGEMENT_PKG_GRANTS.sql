SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE CREATE_APPLICATION_WRAPPER_PROC( 
    p_first_name IN POLICYHOLDER.FIRST_NAME%TYPE,
    p_last_name IN POLICYHOLDER.LAST_NAME%TYPE,
    p_dob IN POLICYHOLDER.DOB%TYPE,
    p_email IN POLICYHOLDER.EMAIL%TYPE,
    p_contact IN POLICYHOLDER.CONTACT%TYPE,
    p_address_line_1 IN ADDRESS.ADDRESS_LINE_1%TYPE,
    p_address_line_2 IN ADDRESS.ADDRESS_LINE_2%TYPE,
    p_city IN ADDRESS.CITY%TYPE,
    p_state IN ADDRESS.STATE%TYPE,
    p_zipcode IN ADDRESS.ZIPCODE%TYPE,
    p_country IN ADDRESS.COUNTRY%TYPE,
    p_provider_name IN PROVIDER.provider_name%TYPE,
    p_insurance_type IN INSURANCE_TYPE.insurance_type_name%TYPE) AS
        
    BEGIN
        APPLICATION_MANAGEMENT_PKG.CREATE_APPLICATION_PROC(
            p_first_name,
            p_last_name,
            p_dob,
            p_email,
            p_contact,
            p_address_line_1,
            p_address_line_2,
            p_city,
            p_state,
            p_zipcode,
            p_country,
            p_provider_name,
            p_insurance_type);
    EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Exception occured when creating CREATE_APPLICATION_WRAPPER_PROC: ' || sqlerrm);
    END CREATE_APPLICATION_WRAPPER_PROC;
    /
            
CREATE OR REPLACE FUNCTION VALIDATE_APPLICATION_WRAPPER_FUNC(  
    p_first_name IN POLICYHOLDER.FIRST_NAME%TYPE,
    p_last_name IN POLICYHOLDER.LAST_NAME%TYPE,
    p_dob IN POLICYHOLDER.DOB%TYPE,
    p_email IN POLICYHOLDER.EMAIL%TYPE,
    p_contact IN POLICYHOLDER.CONTACT%TYPE,
    p_address_line_1 IN ADDRESS.ADDRESS_LINE_1%TYPE,
    p_address_line_2 IN ADDRESS.ADDRESS_LINE_2%TYPE,
    p_city IN ADDRESS.CITY%TYPE,
    p_state IN ADDRESS.STATE%TYPE,
    p_zipcode IN ADDRESS.ZIPCODE%TYPE,
    p_country IN ADDRESS.COUNTRY%TYPE,
    p_provider_name IN PROVIDER.provider_name%TYPE,
    p_insurance_type IN INSURANCE_TYPE.insurance_type_name%TYPE) RETURN BOOLEAN AS
        
    BEGIN
        RETURN APPLICATION_MANAGEMENT_PKG.VALIDATE_APPLICATION_FUNC(
            p_first_name,
            p_last_name,
            p_dob,
            p_email,
            p_contact,
            p_address_line_1,
            p_address_line_2,
            p_city,
            p_state,
            p_zipcode,
            p_country,
            p_provider_name,
            p_insurance_type);
    EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Exception occured when creating VALIDATE_APPLICATION_WRAPPER_FUNC: ' || sqlerrm);
    END VALIDATE_APPLICATION_WRAPPER_FUNC;
    /
    
CREATE OR REPLACE PROCEDURE REVIEW_APPLICATION_WRAPPER_PROC(
        p_application_id IN INSURANCE_APPLICATION.APPLICATION_ID%TYPE,
        p_application_status IN INSURANCE_APPLICATION.STATUS%TYPE,
        p_comments IN INSURANCE_APPLICATION.COMMENTS%TYPE,
        p_premium_amount IN POLICY.PREMIUM_AMOUNT%TYPE,
        p_coverage_amount IN POLICY.COVERAGE_AMOUNT%TYPE
    ) AS
    
    BEGIN
        APPLICATION_MANAGEMENT_PKG.REVIEW_APPLICATION_PROC(
            p_application_id,
            p_application_status,
            p_comments,
            p_premium_amount,
            p_coverage_amount);
    EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Exception occured when creating REVIEW_APPLICATION_WRAPPER_PROC: ' || sqlerrm);
    END REVIEW_APPLICATION_WRAPPER_PROC;
    /
    
CREATE OR REPLACE FUNCTION GET_APPLICATION_STATUS_WRAPPER_FUNC(
    p_application_id IN INSURANCE_APPLICATION.APPLICATION_ID%TYPE) RETURN VARCHAR2 AS
    
    BEGIN
        RETURN APPLICATION_MANAGEMENT_PKG.GET_APPLICATION_STATUS(p_application_id);
    EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Exception occured when creating GET_APPLICATION_STATUS_WRAPPER_FUNC: ' || sqlerrm);
    END GET_APPLICATION_STATUS_WRAPPER_FUNC;
    /
       
BEGIN     
    EXECUTE IMMEDIATE 'GRANT EXECUTE ON CREATE_APPLICATION_WRAPPER_PROC TO SALESMAN';
    dbms_output.put_line('Grant on CREATE_APPLICATION_WRAPPER_PROC to SALESMAN successful!');
    EXECUTE IMMEDIATE 'GRANT EXECUTE ON VALIDATE_APPLICATION_WRAPPER_FUNC TO SALESMAN, MANAGER';
    dbms_output.put_line('Grant on VALIDATE_APPLICATION_WRAPPER_FUNC to SALESMAN and MANAGER successful!');
    EXECUTE IMMEDIATE 'GRANT EXECUTE ON REVIEW_APPLICATION_WRAPPER_PROC TO MANAGER';
    dbms_output.put_line('Grant on REVIEW_APPLICATION_WRAPPER_PROC to MANAGER successful!');
    EXECUTE IMMEDIATE 'GRANT EXECUTE ON GET_APPLICATION_STATUS_WRAPPER_FUNC TO POLICY_HOLDER, SALESMAN, MANAGER';
    dbms_output.put_line('Grant on GET_APPLICATION_STATUS_WRAPPER_FUNC to POLICYHOLDER, SALESMAN and MANAGER successful!');
    
EXCEPTION
WHEN OTHERS THEN
    dbms_output.put_line('Exception occured when granting previleges: ' || sqlerrm);
END;
/
        
    