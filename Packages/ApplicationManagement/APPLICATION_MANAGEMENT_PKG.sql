CREATE OR REPLACE PACKAGE APPLICATION_MANAGEMENT_PKG AS

    PROCEDURE CREATE_APPLICATION_PROC(
        p_first_name IN VARCHAR2,
        p_last_name IN VARCHAR2,
        p_dob IN DATE,
        p_email IN VARCHAR2,
        p_contact IN NUMBER,
        p_address_line_1 IN VARCHAR2,
        p_address_line_2 IN VARCHAR2,
        p_city IN VARCHAR2,
        p_state IN VARCHAR2,
        p_zipcode IN INTEGER,
        p_country IN VARCHAR2
    );
    
    FUNCTION VALIDATE_APPLICATION_FUNC(
        p_first_name IN VARCHAR2,
        p_last_name IN VARCHAR2,
        p_dob IN DATE,
        p_email IN VARCHAR2,
        p_contact IN NUMBER,
        p_address_line_1 IN VARCHAR2,
        p_address_line_2 IN VARCHAR2,
        p_city IN VARCHAR2,
        p_state IN VARCHAR2,
        p_zipcode IN INTEGER,
        p_country IN VARCHAR2
    ) RETURN BOOLEAN;
    
    PROCEDURE REVIEW_APPLICATION_PROC(
        p_application_id IN INTEGER,
        p_application_status IN VARCHAR2,
        p_comments IN VARCHAR2
    );
    
    FUNCTION GET_APPLICATION_STATUS(
        p_application_id IN INTEGER
    )RETURN VARCHAR2;
    
END APPLICATION_MANAGEMENT_PKG;
        