SET SERVEROUTPUT ON;

DECLARE
    view_exists INTEGER;
BEGIN
    -- First View: ACTIVE POLICY SUMMARY
    BEGIN
    -- Check if the view already exists
        SELECT
            COUNT(*)
        INTO view_exists
        FROM
            user_views
        WHERE
            view_name = 'ACTIVE_POLICIES_SUMMARY';

    -- Drop the view if it exists
        IF view_exists = 1 THEN
            EXECUTE IMMEDIATE 'DROP VIEW ACTIVE_POLICIES_SUMMARY';
            dbms_output.put_line('View ACTIVE_POLICIES_SUMMARY dropped');
        END IF;

    -- Create the view
        EXECUTE IMMEDIATE 'CREATE VIEW ACTIVE_POLICIES_SUMMARY AS
    SELECT
        pol.policy_id,
        ph.first_name || '' '' || ph.last_name AS policy_holder_name,
        prov.provider_name,
        inst.insurance_type_name,
        pol.premium_amount,
        pol.coverage_amount,
        pol.start_date AS policy_start_date,
        pol.end_date AS policy_end_date
    FROM
        POLICY pol
    JOIN
        POLICYHOLDER ph ON pol.policyholder_id = ph.policyholder_id
    JOIN
        PROVIDER prov ON pol.provider_id = prov.provider_id
    JOIN 
        INSURANCE_TYPE inst ON pol.insurance_type_id = inst.insurance_type_id
    WHERE
        pol.policy_status = ''Active''';
        dbms_output.put_line('View ACTIVE_POLICIES_SUMMARY created');
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Exception occurred while creating ACTIVE_POLICIES_SUMMARY: ' || sqlerrm);
    END;
    
    -- Second View:
    BEGIN
    -- Check if the view already exists
        SELECT
            COUNT(*)
        INTO view_exists
        FROM
            user_views
        WHERE
            view_name = 'INSURANCE_APPLICATION_OVERVIEW';

    -- Drop the view if it exists
        IF view_exists = 1 THEN
            EXECUTE IMMEDIATE 'DROP VIEW INSURANCE_APPLICATION_OVERVIEW';
            dbms_output.put_line('View INSURANCE_APPLICATION_OVERVIEW dropped');
        END IF;

    -- Create the view
        EXECUTE IMMEDIATE 'CREATE VIEW INSURANCE_APPLICATION_OVERVIEW AS
    SELECT
        ia.application_id,
        ph.first_name || '' '' || ph.last_name AS applicant_name,
        ia.application_date,
        it.insurance_type_name AS insurance_type,
        ia.status AS application_status,
        ia.review_date,
        ag.first_name || '' '' || ag.last_name AS agent_name,
        CASE
            WHEN ia.status = ''Approved'' THEN ''Approved''
            WHEN ia.status = ''Rejected'' THEN ''Rejected''
            ELSE ''Pending''
        END AS decision,
        pol.policy_id AS issued_policy_id
    FROM
        INSURANCE_APPLICATION ia
    JOIN
        POLICYHOLDER ph ON ia.policyholder_id = ph.policyholder_id
    JOIN
        INSURANCE_TYPE it ON ia.insurance_type_id = it.insurance_type_id
    LEFT JOIN
        AGENT ag ON ia.agent_id = ag.agent_id
    LEFT JOIN
        POLICY pol ON ia.application_id = pol.application_id';
        dbms_output.put_line('View INSURANCE_APPLICATION_OVERVIEW created');
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Exception occurred while creating INSURANCE_APPLICATION_OVERVIEW: ' || sqlerrm);
    END;
    
    
    -- Third View:
    BEGIN
        -- Check if the view already exists
        SELECT
            COUNT(*)
        INTO view_exists
        FROM
            user_views
        WHERE
            view_name = 'PENDING_CLAIMS_OVERVIEW';

        -- Drop the view if it exists
        IF view_exists = 1 THEN
            EXECUTE IMMEDIATE 'DROP VIEW PENDING_CLAIMS_OVERVIEW';
            dbms_output.put_line('View PENDING_CLAIMS_OVERVIEW dropped');
        END IF;

        -- Create the view
        EXECUTE IMMEDIATE 'CREATE VIEW PENDING_CLAIMS_OVERVIEW AS
        SELECT
            cl.claim_id,
            cl.policy_id,
            ph.first_name || '' '' || ph.last_name AS policy_holder_name,
            cl.claim_type,
            cl.claim_amount,
            cl.claim_date AS submission_date,
            cl.claim_status AS current_status,
            ag.first_name || '' '' || ag.last_name AS assigned_agent,
            TRUNC(SYSDATE - cl.claim_date) AS days_in_current_status
        FROM
            CLAIM cl
        JOIN
            POLICY pol ON cl.policy_id = pol.policy_id
        JOIN
            POLICYHOLDER ph ON pol.policyholder_id = ph.policyholder_id
        LEFT JOIN
            AGENT ag ON cl.agent_id = ag.agent_id
        WHERE
            cl.claim_status = ''In Progress''';
        dbms_output.put_line('View PENDING_CLAIMS_OVERVIEW created');
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Exception occurred while creating PENDING_CLAIMS_OVERVIEW: ' || sqlerrm);
    END;

    BEGIN
        -- Check if the view already exists
        SELECT
            COUNT(*)
        INTO view_exists
        FROM
            user_views
        WHERE
            view_name = 'MONTHLY_CLAIMS_STATISTICS';

        -- Drop the view if it exists
        IF view_exists = 1 THEN
            EXECUTE IMMEDIATE 'DROP VIEW MONTHLY_CLAIMS_STATISTICS';
            dbms_output.put_line('View MONTHLY_CLAIMS_STATISTICS dropped');
        END IF;

        -- Create the view
        EXECUTE IMMEDIATE 'CREATE VIEW MONTHLY_CLAIMS_STATISTICS AS
        SELECT
            TO_CHAR(cl.claim_date, ''MM'') AS month,
            TO_CHAR(cl.claim_date, ''YYYY'') AS year,
            COUNT(cl.claim_id) AS total_claims_submitted,
            COUNT(CASE WHEN cl.claim_status = ''Approved'' THEN 1 END) AS total_claims_approved,
            COUNT(CASE WHEN cl.claim_status = ''Rejected'' THEN 1 END) AS total_claims_rejected,
            AVG(cl.claim_amount) AS average_claim_amount,
            AVG(cl.estimated_settlement_date - cl.claim_date) AS average_processing_time
        FROM
            CLAIM cl
        GROUP BY
            TO_CHAR(cl.claim_date, ''MM''), TO_CHAR(cl.claim_date, ''YYYY'')';
        dbms_output.put_line('View MONTHLY_CLAIMS_STATISTICS created');
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Exception occurred while creating MONTHLY_CLAIMS_STATISTICS: ' || sqlerrm);
    END;
    
    
    BEGIN
        -- Check if the view already exists
        SELECT COUNT(*)
        INTO view_exists
        FROM USER_VIEWS
        WHERE VIEW_NAME = 'POLICYHOLDER_CLAIM_HISTORY';

        -- Drop the view if it exists
        IF view_exists = 1 THEN
            EXECUTE IMMEDIATE 'DROP VIEW POLICYHOLDER_CLAIM_HISTORY';
            DBMS_OUTPUT.PUT_LINE('View POLICYHOLDER_CLAIM_HISTORY dropped');
        END IF;

        -- Create the view
        EXECUTE IMMEDIATE 'CREATE VIEW POLICYHOLDER_CLAIM_HISTORY AS
        SELECT
            ph.policyholder_id,
            ph.first_name || '' '' || ph.last_name AS policy_holder_name,
            pol.policy_id,
            cl.claim_id,
            cl.claim_type,
            cl.claim_amount,
            cl.claim_date AS submission_date,
            cl.estimated_settlement_date,
            cl.claim_status
        FROM
            CLAIM cl
        JOIN
            POLICY pol ON cl.policy_id = pol.policy_id
        JOIN
            POLICYHOLDER ph ON pol.policyholder_id = ph.policyholder_id';
        
        DBMS_OUTPUT.PUT_LINE('View POLICYHOLDER_CLAIM_HISTORY created');
    
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Exception occurred while creating POLICYHOLDER_CLAIM_HISTORY: ' || SQLERRM);
    END;
    
    
    BEGIN
        -- Check if the view already exists
        SELECT COUNT(*)
        INTO view_exists
        FROM USER_VIEWS
        WHERE VIEW_NAME = 'POLICY_EXPIRATION_ALERT';

        -- Drop the view if it exists
        IF view_exists = 1 THEN
            EXECUTE IMMEDIATE 'DROP VIEW POLICY_EXPIRATION_ALERT';
            DBMS_OUTPUT.PUT_LINE('View POLICY_EXPIRATION_ALERT dropped');
        END IF;

        -- Create the view
        EXECUTE IMMEDIATE 'CREATE VIEW POLICY_EXPIRATION_ALERT AS
        SELECT
            pol.policy_id,
            ph.first_name || '' '' || ph.last_name AS policy_holder_name,
            inst.insurance_type_name,
            pol.end_date AS expiration_date,
            TRUNC(pol.end_date - SYSDATE) AS days_until_expiration
        FROM
            POLICY pol
        JOIN
            POLICYHOLDER ph ON pol.policyholder_id = ph.policyholder_id
        JOIN 
            INSURANCE_TYPE inst ON pol.insurance_type_id = inst.insurance_type_id
        WHERE
            pol.end_date BETWEEN SYSDATE AND SYSDATE + 30';
        
        DBMS_OUTPUT.PUT_LINE('View POLICY_EXPIRATION_ALERT created');
    
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Exception occurred while creating POLICY_EXPIRATION_ALERT: ' || SQLERRM);
    END;
    
    
    BEGIN
        -- Check if the view already exists
        SELECT COUNT(*)
        INTO view_exists
        FROM USER_VIEWS
        WHERE VIEW_NAME = 'ADJUSTER_PERFORMANCE_METRICS';

        -- Drop the view if it exists
        IF view_exists = 1 THEN
            EXECUTE IMMEDIATE 'DROP VIEW ADJUSTER_PERFORMANCE_METRICS';
            DBMS_OUTPUT.PUT_LINE('View ADJUSTER_PERFORMANCE_METRICS dropped');
        END IF;

        -- Create the view
        EXECUTE IMMEDIATE 'CREATE VIEW ADJUSTER_PERFORMANCE_METRICS AS
        SELECT
            ag.agent_id AS adjuster_id,
            ag.first_name || '' '' || ag.last_name AS adjuster_name,
            COUNT(cl.claim_id) AS total_claims_assigned,
            COUNT(CASE WHEN cl.claim_status = ''Settled'' THEN 1 END) AS claims_resolved,
            AVG(cl.estimated_settlement_date - cl.claim_date) AS average_resolution_time,
            ROUND(
                (COUNT(CASE WHEN cl.claim_status = ''Settled'' THEN 1 END) / NULLIF(COUNT(cl.claim_id), 0)) * 100,
                2
            ) AS accuracy_rate
        FROM
            AGENT ag
        LEFT JOIN
            CLAIM cl ON ag.agent_id = cl.agent_id
        GROUP BY
            ag.agent_id, ag.first_name || '' '' || ag.last_name';
        
        DBMS_OUTPUT.PUT_LINE('View ADJUSTER_PERFORMANCE_METRICS created');
    
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Exception occurred while creating ADJUSTER_PERFORMANCE_METRICS: ' || SQLERRM);
    END;
    
    
    BEGIN
        -- Check if the view already exists
        SELECT COUNT(*)
        INTO view_exists
        FROM USER_VIEWS
        WHERE VIEW_NAME = 'PAYMENT_PROCESSING_QUEUE';

        -- Drop the view if it exists
        IF view_exists = 1 THEN
            EXECUTE IMMEDIATE 'DROP VIEW PAYMENT_PROCESSING_QUEUE';
            DBMS_OUTPUT.PUT_LINE('View PAYMENT_PROCESSING_QUEUE dropped');
        END IF;

        -- Create the view
        EXECUTE IMMEDIATE 'CREATE VIEW PAYMENT_PROCESSING_QUEUE AS
        SELECT
            cl.claim_id,
            cl.policy_id,
            ph.first_name || '' '' || ph.last_name AS policy_holder_name,
            cl.claim_amount AS approved_amount,
            cl.estimated_settlement_date AS approval_date,
            pay.payment_status,
            pay.payment_date AS scheduled_payment_date,
            pay.payment_method
        FROM
            CLAIM cl
        JOIN
            POLICY pol ON cl.policy_id = pol.policy_id
        JOIN
            POLICYHOLDER ph ON pol.policyholder_id = ph.policyholder_id
        LEFT JOIN
            PAYMENT pay ON cl.claim_id = pay.claim_id
        WHERE
            cl.claim_status = ''Approved''';
        
        DBMS_OUTPUT.PUT_LINE('View PAYMENT_PROCESSING_QUEUE created');
    
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Exception occurred while creating PAYMENT_PROCESSING_QUEUE: ' || SQLERRM);
    END;

EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Exception during the creation of overall VIEWS: ' || sqlerrm);
END;
