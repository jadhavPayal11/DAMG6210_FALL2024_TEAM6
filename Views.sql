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
        CONCAT(ph.first_name, '' '', ph.last_name) AS policy_holder_name,
        prov.provider_name,
        pol.policy_type,
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
        CONCAT(ph.first_name, '' '', ph.last_name) AS applicant_name,
        ia.application_date,
        it.insurance_type_name AS insurance_type,
        ia.status AS application_status,
        ia.review_date,
        CONCAT(ag.first_name, '' '', ag.last_name) AS agent_name,
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
            CONCAT(ph.first_name, '' '', ph.last_name) AS policy_holder_name,
            cl.claim_type,
            cl.amount,
            cl.claim_date AS submission_date,
            cl.claim_status AS current_status,
            CONCAT(ag.first_name, '' '', ag.last_name) AS assigned_agent,
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
            cl.claim_status = ''Pending''';
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
            AVG(cl.amount) AS average_claim_amount,
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

EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Exception during the creation of overall VIEWS: ' || sqlerrm);
END;
/

-- End of script for creating ACTIVE_POLICIES_SUMMARY