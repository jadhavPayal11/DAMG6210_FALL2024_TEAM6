CREATE OR REPLACE PACKAGE APPLICATION_MANAGEMENT_PKG AS

    PROCEDURE CREATE_APPLICATION_PROC(
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
        p_insurance_type IN INSURANCE_TYPE.insurance_type_name%TYPE
    );
    
    FUNCTION VALIDATE_APPLICATION_FUNC(
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
        p_insurance_type IN INSURANCE_TYPE.insurance_type_name%TYPE
    ) RETURN BOOLEAN;
    
    PROCEDURE REVIEW_APPLICATION_PROC(
        p_application_id IN INSURANCE_APPLICATION.APPLICATION_ID%TYPE,
        p_application_status IN INSURANCE_APPLICATION.STATUS%TYPE,
        p_comments IN INSURANCE_APPLICATION.COMMENTS%TYPE,
        p_premium_amount IN POLICY.PREMIUM_AMOUNT%TYPE,
        p_coverage_amount IN POLICY.COVERAGE_AMOUNT%TYPE
    );
    
    FUNCTION GET_APPLICATION_STATUS(
        p_application_id IN INSURANCE_APPLICATION.APPLICATION_ID%TYPE
    )RETURN VARCHAR2;
    
END APPLICATION_MANAGEMENT_PKG;
        