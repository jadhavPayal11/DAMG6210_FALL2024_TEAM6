-- Create Package Specification
CREATE OR REPLACE PACKAGE policy_management AS
    PROCEDURE update_policy_status(policy_id IN NUMBER, new_status IN VARCHAR2);
    FUNCTION check_policy_validity(policy_id IN NUMBER) RETURN VARCHAR2;
    FUNCTION get_policy_details(policy_id IN NUMBER) RETURN VARCHAR2;
END policy_management;
/

-- Create Package Body
CREATE OR REPLACE PACKAGE BODY policy_management AS

    -- Stored Procedure: Update Policy Status
    PROCEDURE update_policy_status(policy_id IN NUMBER, new_status IN VARCHAR2) IS
        v_policy_holder_id NUMBER;
        v_current_status VARCHAR2(20);
    BEGIN
        -- Get policy holder ID and current status
        SELECT policyholder_id, status INTO v_policy_holder_id, v_current_status
        FROM Policy
        WHERE policy_id = policy_id;

        -- Ensure only the policyholder can cancel active policies
        IF v_current_status = 'Active' AND v_policy_holder_id = USER THEN
            UPDATE Policy
            SET status = new_status
            WHERE policy_id = policy_id;
            COMMIT;
        ELSE
            RAISE_APPLICATION_ERROR(-20001, 'Only the policyholder can cancel an active policy.');
        END IF;
    END update_policy_status;

    -- Function: Check Policy Validity
    FUNCTION check_policy_validity(policy_id IN NUMBER) RETURN VARCHAR2 IS
        v_status VARCHAR2(20);
        v_end_date DATE;
    BEGIN
        SELECT status, end_date INTO v_status, v_end_date
        FROM Policy
        WHERE policy_id = policy_id;

        -- Check if the policy is valid
        IF v_status = 'Active' AND v_end_date > SYSDATE THEN
            RETURN 'Valid';
        ELSE
            RETURN 'Invalid';
        END IF;
    END check_policy_validity;

    -- Function: Get Policy Details
    FUNCTION get_policy_details(policy_id IN NUMBER) RETURN VARCHAR2 IS
        v_details VARCHAR2(500);
    BEGIN
        SELECT 'Policy ID: ' || policy_id || ', Status: ' || status || 
               ', Start Date: ' || TO_CHAR(start_date, 'YYYY-MM-DD') || 
               ', End Date: ' || TO_CHAR(end_date, 'YYYY-MM-DD') || 
               ', Policy Holder: ' || policyholder_id
        INTO v_details
        FROM Policy
        WHERE policy_id = policy_id;

        RETURN v_details;
    END get_policy_details;

END policy_management;
/
