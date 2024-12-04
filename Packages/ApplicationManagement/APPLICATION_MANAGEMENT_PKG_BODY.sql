CREATE OR REPLACE PACKAGE BODY APPLICATION_MANAGEMENT_PKG AS

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
    ) AS
    
    v_address_id ADDRESS.ADDRESS_ID%TYPE;
    v_policyholder_id POLICYHOLDER.POLICYHOLDER_ID%TYPE;
    v_provider_id PROVIDER.PROVIDER_ID%TYPE;
    v_agent_id AGENT.AGENT_ID%TYPE;
    v_insurance_type_id INSURANCE_TYPE.INSURANCE_TYPE_ID%TYPE;
    
    BEGIN
        IF VALIDATE_APPLICATION_FUNC(
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
            p_insurance_type) THEN
            dbms_output.put_line('Creating Application....');
            
            -- checking for existing address
            BEGIN 
                SELECT address_id
                INTO v_address_id
                FROM ADDRESS
                WHERE address_line_1 = p_address_line_1
                AND nvl(address_line_2,' ') = ' '
                AND city = p_city
                AND state = p_state
                AND zipcode = p_zipcode
                AND country = p_country;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    dbms_output.put_line('Please enter a valid address');
                WHEN OTHERS THEN
                    dbms_output.put_line('Exception occured when fetching address id: ' || sqlerrm);
            END;
            
            -- checking for existing policyholder
            BEGIN 
                SELECT policyholder_id
                INTO v_policyholder_id
                FROM POLICYHOLDER
                WHERE email = p_email;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_policyholder_id := POLICY_HOLDER_SEQ.nextval;
                    
                    INSERT INTO POLICYHOLDER VALUES(
                        v_policyholder_id,
                        p_first_name,
                        p_last_name,
                        p_dob,
                        p_email,
                        p_contact,
                        v_address_id
                    );
                    COMMIT;
                    dbms_output.put_line('Policyholder created successfully with Policyholder Id: ' || v_policyholder_id);
                WHEN OTHERS THEN
                    dbms_output.put_line('Exception occured when fetching policyholder id: ' || sqlerrm);
            END;
            
            -- checking for existing provider
            BEGIN 
                SELECT provider_id
                INTO v_provider_id
                FROM PROVIDER
                WHERE provider_name = p_provider_name;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    dbms_output.put_line('Please enter a valid provider name');
                WHEN OTHERS THEN
                    dbms_output.put_line('Exception occured when fetching provider id: ' || sqlerrm);
            END;
            
            -- fetch agent id based on provider id
            BEGIN 
                SELECT agent_id
                INTO v_agent_id
                FROM AGENT
                WHERE provider_id = v_provider_id
                AND upper(designation) = 'SALESMAN'
                AND ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    dbms_output.put_line('Agent does not exist for this provider. Please choose another provider...');
                WHEN OTHERS THEN
                    dbms_output.put_line('Exception occured when fetching agent id: ' || sqlerrm);
            END;
            
            -- checking for existing insurance type
            BEGIN 
                SELECT insurance_type_id
                INTO v_insurance_type_id
                FROM INSURANCE_TYPE
                WHERE insurance_type_name = p_insurance_type;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    dbms_output.put_line('Please enter a valid insurance type');
                WHEN OTHERS THEN
                    dbms_output.put_line('Exception occured when fetching provider id: ' || sqlerrm);
            END;
            
            
            INSERT INTO INSURANCE_APPLICATION VALUES(
                INS_APPL_SEQ.nextval,
                v_policyholder_id,
                v_insurance_type_id,
                sysdate,
                'Pending',
                null,
                v_agent_id,
                'Application created'
            );
            COMMIT;
            dbms_output.put_line('Application created successfully with Application Id: ' || INS_APPL_SEQ.currval);
    ELSE 
        dbms_output.put_line('Please enter valid application data...');
            
    END IF;           
        
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Exception occured while creating application: ' || sqlerrm);
    END CREATE_APPLICATION_PROC;
    
    
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
    ) RETURN BOOLEAN AS
    
    BEGIN
        -- Basic validation checks
        IF p_first_name IS NULL OR p_last_name IS NULL OR p_dob IS NULL OR
           p_email IS NULL OR p_contact IS NULL OR p_address_line_1 IS NULL OR
           p_city IS NULL OR p_state IS NULL OR p_zipcode IS NULL OR
           p_country IS NULL OR p_provider_name IS NULL OR p_insurance_type IS NULL THEN
          RETURN FALSE;
        END IF;
        
        -- Validate first name (letters, hyphens, and apostrophes only, 2-30 characters)
        IF NOT REGEXP_LIKE(p_first_name, '^[A-Za-z][A-Za-z\-'']{1,29}$') THEN
          dbms_output.put_line('Please enter valid First name');
          RETURN FALSE;
        END IF;
        
        -- Validate last name (letters, hyphens, and apostrophes only, 2-30 characters)
        IF NOT REGEXP_LIKE(p_last_name, '^[A-Za-z][A-Za-z\-'']{1,29}$') THEN
          dbms_output.put_line('Please enter valid Last name');
          RETURN FALSE;
        END IF;
        
        -- Validate email format
        IF NOT REGEXP_LIKE(p_email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$') THEN
          dbms_output.put_line('Please enter valid Email');
          RETURN FALSE;
        END IF;
        
        -- Validate contact number
        IF NOT REGEXP_LIKE(p_contact, '^\d{10}$') THEN
          dbms_output.put_line('Please enter valid contact');
          RETURN FALSE;
        END IF;
        
        RETURN TRUE;

    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Exception occured while validating application: ' || sqlerrm);
    END VALIDATE_APPLICATION_FUNC;
    
    PROCEDURE REVIEW_APPLICATION_PROC(
        p_application_id IN INSURANCE_APPLICATION.APPLICATION_ID%TYPE,
        p_application_status IN INSURANCE_APPLICATION.STATUS%TYPE,
        p_comments IN INSURANCE_APPLICATION.COMMENTS%TYPE
    ) AS
    
    v_agent_id AGENT.AGENT_ID%TYPE;
    v_provider_id PROVIDER.PROVIDER_ID%TYPE;
    v_policyholder_id POLICYHOLDER.POLICYHOLDER_ID%TYPE;
    v_insurance_type_id INSURANCE_TYPE.INSURANCE_TYPE_ID%TYPE;
    
    v_first_name POLICYHOLDER.FIRST_NAME%TYPE;
    v_last_name POLICYHOLDER.LAST_NAME%TYPE;
    v_dob POLICYHOLDER.DOB%TYPE;
    v_email POLICYHOLDER.EMAIL%TYPE;
    v_contact POLICYHOLDER.CONTACT%TYPE;
    v_address_line_1 ADDRESS.ADDRESS_LINE_1%TYPE;
    v_address_line_2 ADDRESS.ADDRESS_LINE_2%TYPE;
    v_city ADDRESS.CITY%TYPE;
    v_state ADDRESS.STATE%TYPE;
    v_zipcode ADDRESS.ZIPCODE%TYPE;
    v_country ADDRESS.COUNTRY%TYPE;
    v_provider_name PROVIDER.provider_name%TYPE;
    v_insurance_type INSURANCE_TYPE.insurance_type_name%TYPE;
    
    BEGIN
        BEGIN
            SELECT ph.first_name, ph.last_name, ph.dob, ph.email, ph.contact,
                a.address_line_1, a.address_line_2, a.city, a.state, a.zipcode, a.country, p.provider_name, t.insurance_type_name
            INTO v_first_name, v_last_name, v_dob, v_email, v_contact,
                v_address_line_1, v_address_line_2, v_city, v_state, v_zipcode, v_country, v_provider_name, v_insurance_type
            FROM INSURANCE_APPLICATION i,
            POLICYHOLDER ph,
            ADDRESS a,
            PROVIDER p,
            AGENT ag,
            INSURANCE_TYPE t
            WHERE i.policyholder_id = ph.policyholder_id
            AND ph.address_id = a.address_id
            AND i.agent_id = ag.agent_id
            AND ag.provider_id = p.provider_id
            AND i.insurance_type_id = t.insurance_type_id
            AND i.application_id = p_application_id;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('Please enter valid application id');
        WHEN OTHERS THEN
            dbms_output.put_line('Exception occured while fetching application details: ' || sqlerrm);
        END;
        
        IF VALIDATE_APPLICATION_FUNC(
            v_first_name,
            v_last_name,
            v_dob,
            v_email,
            v_contact,
            v_address_line_1,
            v_address_line_2,
            v_city,
            v_state,
            v_zipcode,
            v_country,
            v_provider_name,
            v_insurance_type) THEN
            BEGIN
                SELECT a.agent_id, p.provider_id, i.policyholder_id, i.insurance_type_id
                INTO v_agent_id, v_provider_id, v_policyholder_id, v_insurance_type_id
                FROM INSURANCE_APPLICATION i,
                AGENT a,
                PROVIDER p
                WHERE i.agent_id = a.agent_id
                AND a.provider_id = p.provider_id
                AND upper(a.designation) = 'MANAGER'
                AND application_id = p_application_id
                AND ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    dbms_output.put_line('Manager details not found');
                WHEN OTHERS THEN
                    dbms_output.put_line('Exception occured while fetching manager details: ' || sqlerrm);
            END;
            
            UPDATE INSURANCE_APPLICATION
            SET STATUS = p_application_status,
            REVIEW_DATE = sysdate,
            AGENT_ID = v_agent_id,
            COMMENTS = p_comments 
            WHERE APPLICATION_ID = p_application_id;
            COMMIT;
            dbms_output.put_line('Application has been reviewed and the status is updated to ' || p_application_status);
            
            INSERT INTO POLICY VALUES(
                POLICY_SEQ.nextval,
                p_application_id,
                v_policyholder_id,
                v_provider_id,
                v_insurance_type_id,
                sysdate,
                ADD_MONTHS(sysdate,12),
                150,
                10000,
                'Active'
            );
            COMMIT;
            dbms_output.put_line('Policy with policy id ' || POLICY_SEQ.currval || ' has been created and is active'); 
        ELSE
            dbms_output.put_line('Please enter valid application data...');
        END IF;
        
    EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Exception occured while reviewing application: ' || sqlerrm);
    END REVIEW_APPLICATION_PROC;
    
    FUNCTION GET_APPLICATION_STATUS(
        p_application_id IN INSURANCE_APPLICATION.APPLICATION_ID%TYPE
    )RETURN VARCHAR2 AS
    v_status INSURANCE_APPLICATION.STATUS%TYPE;
    BEGIN
        SELECT status 
        INTO v_status
        FROM INSURANCE_APPLICATION
        where application_id = p_application_id;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
                    dbms_output.put_line('Please enter a valid application id');
    WHEN OTHERS THEN
        dbms_output.put_line('Exception occured while retriving application status: ' || sqlerrm);
    END GET_APPLICATION_STATUS;
    
END APPLICATION_MANAGEMENT_PKG;
        