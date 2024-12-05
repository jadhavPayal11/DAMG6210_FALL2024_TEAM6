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
    v_application_id INSURANCE_APPLICATION.APPLICATION_ID%TYPE;
    
    e_check_violation EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_check_violation, -02290);
    e_not_null_violation EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_not_null_violation, -01400);
    e_fk_violation EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_fk_violation, -02291);
    
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
            dbms_output.put_line('Creating Insurance Application....');
            
            -- checking for existing address
            BEGIN 
                SELECT address_id
                INTO v_address_id
                FROM ADDRESS
                WHERE address_line_1 = p_address_line_1
                AND nvl(address_line_2,' ') = nvl(p_address_line_2,' ')
                AND city = p_city
                AND state = p_state
                AND zipcode = p_zipcode
                AND country = p_country
                AND upper(address_type) = 'RESIDENTIAL';
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
                
                dbms_output.put_line('Policyholder already exists with policyholder id: ' || v_policyholder_id);
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_policyholder_id := POLICY_HOLDER_SEQ.nextval;
                    
                    BEGIN
                    
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
                    EXCEPTION 
                        WHEN DUP_VAL_ON_INDEX THEN
                            dbms_output.put_line('Policy holder already exists, check for duplicate policy holder records');
                            rollback;
                        WHEN e_not_null_violation THEN
                            dbms_output.put_line('Mandatory columns cannot be null in POLICYHOLDER table');
                            rollback;
                        WHEN e_fk_violation THEN
                            dbms_output.put_line('Foreign key violation, enter a valid address id');
                            rollback;
                        WHEN OTHERS THEN
                            dbms_output.put_line('Exception occured while inserting data into POLICYHOLDER table: '||sqlerrm);
                    END;
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
            
            -- checking for existing insurance application
            BEGIN
                SELECT ia.application_id
                INTO v_application_id
                FROM INSURANCE_APPLICATION ia,
                AGENT a,
                PROVIDER p,
                INSURANCE_TYPE it
                WHERE ia.policyholder_id = v_policyholder_id
                AND ia.agent_id = a.agent_id
                AND a.provider_id = p.provider_id
                AND p.provider_id = v_provider_id
                AND ia.insurance_type_id = it.insurance_type_id
                AND it.insurance_type_id = v_insurance_type_id
                AND ia.status = 'In Progress';
                
                dbms_output.put_line('Application already exists with application id ' || v_application_id || ' and status In Progress' );
            
            EXCEPTION
                WHEN NO_DATA_FOUND THEN   
                    BEGIN
                        INSERT INTO INSURANCE_APPLICATION VALUES(
                            INS_APPL_SEQ.nextval,
                            v_policyholder_id,
                            v_insurance_type_id,
                            sysdate,
                            'In Progress',
                            null,
                            v_agent_id,
                            'Application created'
                        );
                        COMMIT;
                        dbms_output.put_line('Application created successfully with Application Id: ' || INS_APPL_SEQ.currval);
                    EXCEPTION 
                        when DUP_VAL_ON_INDEX then
                            DBMS_OUTPUT.PUT_LINE('Insurance application already exists, check for duplicate application records');
                            rollback;
                        when E_NOT_NULL_VIOLATION then
                            DBMS_OUTPUT.PUT_LINE('Mandatory columns cannot be null in INSURANCE_APPLICATION table');
                            rollback;
                        when E_FK_VIOLATION then
                            DBMS_OUTPUT.PUT_LINE('Foreign key violation, enter valid policyholder, insurance type, or agent ID');
                            rollback;
                        when others then
                            DBMS_OUTPUT.PUT_LINE('Exception occurred while inserting data into INSURANCE_APPLICATION table: ' || SQLERRM);
                    END;
                WHEN OTHERS THEN
                    dbms_output.put_line('Exception occured when fetching existing application: ' || sqlerrm);
            END;
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
        
        -- Validate first name (starts with letters, contains letters and spaces only, 2-30 characters)
        IF NOT REGEXP_LIKE(p_first_name, '^[A-Za-z]{1}[A-Za-z\s]{1,29}$') THEN
          dbms_output.put_line('Please enter valid First name');
          RETURN FALSE;
        END IF;
        
        -- Validate last name (single word, contains letters only, 2-30 characters)
        IF NOT REGEXP_LIKE(p_last_name, '^[A-Za-z]{2,30}$') THEN
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
        p_comments IN INSURANCE_APPLICATION.COMMENTS%TYPE,
        p_premium_amount IN POLICY.PREMIUM_AMOUNT%TYPE,
        p_coverage_amount IN POLICY.COVERAGE_AMOUNT%TYPE
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
    
    v_policy_id POLICY.POLICY_ID%TYPE;
    v_policy_status POLICY.POLICY_STATUS%TYPE;
    
    e_check_violation EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_check_violation, -02290);
    e_not_null_violation EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_not_null_violation, -01400);
    e_fk_violation EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_fk_violation, -02291);
    
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
            
            -- Fetching Manager Details
            BEGIN
                SELECT a.agent_id, p.provider_id, i.policyholder_id, i.insurance_type_id
                INTO v_agent_id, v_provider_id, v_policyholder_id, v_insurance_type_id
                FROM INSURANCE_APPLICATION i,
                AGENT a,
                AGENT m,
                PROVIDER p
                WHERE i.agent_id = a.agent_id
                AND a.provider_id = p.provider_id
                AND a.manager_id = m.agent_id
                AND upper(m.designation) = 'MANAGER'
                AND application_id = p_application_id
                AND ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    dbms_output.put_line('Manager details not found');
                WHEN OTHERS THEN
                    dbms_output.put_line('Exception occured while fetching manager details: ' || sqlerrm);
            END;
            
            BEGIN
                SELECT policy_id, policy_status
                INTO v_policy_id, v_policy_status
                FROM policy
                WHERE application_id = p_application_id
                AND policyholder_id = v_policyholder_id
                AND provider_id = v_provider_id
                AND insurance_type_id = v_insurance_type_id
                AND policy_status in ('In Progress', 'Active');
                dbms_output.put_line('Application is approved and a policy already exists with Policy Id ' || v_policy_id || ' and status ' || v_policy_status);
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    BEGIN
                        UPDATE INSURANCE_APPLICATION
                        SET STATUS = p_application_status,
                        REVIEW_DATE = sysdate,
                        AGENT_ID = v_agent_id,
                        COMMENTS = p_comments 
                        WHERE APPLICATION_ID = p_application_id;
                        COMMIT;
                        dbms_output.put_line('Application has been reviewed and the status is updated to ' || p_application_status);
                        BEGIN
                        INSERT INTO POLICY VALUES(
                            POLICY_SEQ.nextval,
                            p_application_id,
                            v_policyholder_id,
                            v_provider_id,
                            v_insurance_type_id,
                            sysdate,
                            ADD_MONTHS(sysdate,12),
                            p_premium_amount,
                            p_coverage_amount,
                            'In Progress'
                        );
                        COMMIT;
                        dbms_output.put_line('Policy with policy id ' || POLICY_SEQ.currval || ' has been created and is In Progress'); 
                    EXCEPTION 
                        WHEN DUP_VAL_ON_INDEX THEN
                            DBMS_OUTPUT.PUT_LINE('Policy already exists, check for duplicate policy records');
                            rollback;
                        WHEN E_NOT_NULL_VIOLATION Then
                            DBMS_OUTPUT.PUT_LINE('Mandatory columns cannot be null in POLICY table ');
                            rollback;
                        WHEN E_FK_VIOLATION THEN
                            DBMS_OUTPUT.PUT_LINE('Foreign key violation, enter valid application, policyholder, provider, or insurance type ID');
                            rollback;
                        WHEN OTHERS THEN
                            DBMS_OUTPUT.PUT_LINE('Exception occurred while inserting data into POLICY table: ' || SQLERRM);
                    END;
                    EXCEPTION 
                        WHEN e_check_violation THEN
                        dbms_output.put_line('Please enter a valid application status');
                        WHEN OTHERS THEN
                        dbms_output.put_line('Exception occured while updating the application status: ' || sqlerrm);
                    END;
                    
                WHEN OTHERS THEN
                dbms_output.put_line('Exception occured while fetching existing policy details: ' || sqlerrm);
            END;
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
        WHERE application_id = p_application_id;
        
        RETURN v_status;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        v_status := ' ';
        dbms_output.put_line('Please enter a valid application id');
        RETURN v_status;
    WHEN OTHERS THEN
        v_status := ' ';
        dbms_output.put_line('Exception occured while retriving application status: ' || sqlerrm);
        RETURN v_status;
    END GET_APPLICATION_STATUS;
    
END APPLICATION_MANAGEMENT_PKG;
        