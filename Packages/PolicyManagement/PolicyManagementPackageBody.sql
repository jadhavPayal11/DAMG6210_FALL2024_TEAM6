CREATE OR REPLACE PACKAGE BODY policy_management_package AS

    -- Helper Function: Validate Policy Existence
    FUNCTION ValidatePolicy(
        p_policy_id IN POLICY.POLICY_ID%TYPE
    ) RETURN BOOLEAN IS
        v_count INTEGER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM POLICY
        WHERE POLICY_ID = p_policy_id;

        RETURN v_count > 0;
    END ValidatePolicy;

    -- Helper Function: Check if Policy is In Progress
    FUNCTION IsPolicyInProgress(
        p_policy_id IN POLICY.POLICY_ID%TYPE
    ) RETURN BOOLEAN IS
        v_status VARCHAR2(20);
    BEGIN
        SELECT POLICY_STATUS
        INTO v_status
        FROM POLICY
        WHERE POLICY_ID = p_policy_id;

        RETURN v_status = 'In Progress';
    END IsPolicyInProgress;

    -- Helper Function: Check if Policy is Active
    FUNCTION IsPolicyActive(
        p_policy_id IN POLICY.POLICY_ID%TYPE
    ) RETURN BOOLEAN IS
        v_status VARCHAR2(20);
    BEGIN
        SELECT POLICY_STATUS
        INTO v_status
        FROM POLICY
        WHERE POLICY_ID = p_policy_id;

        RETURN v_status = 'Active';
    END IsPolicyActive;

    -- Stored Procedure: Update Policy Status
    PROCEDURE UpdatePolicyStatus(
        p_policy_id IN POLICY.POLICY_ID%TYPE,
        p_new_status IN VARCHAR2
    ) IS
        v_policyholder_id INTEGER;
        v_current_status VARCHAR2(20);
    BEGIN
        -- Validate Policy
        IF NOT ValidatePolicy(p_policy_id) THEN
            RAISE_APPLICATION_ERROR(-20001, 'Policy does not exist.');
        END IF;

        -- Check if the policy is active
        IF NOT IsPolicyActive(p_policy_id) THEN
            RAISE_APPLICATION_ERROR(-20002, 'Only active policies can be cancelled.');
        END IF;

        -- Get the Policy Holder ID and Current Status
        SELECT POLICYHOLDER_ID, POLICY_STATUS
        INTO v_policyholder_id, v_current_status
        FROM POLICY
        WHERE POLICY_ID = p_policy_id;

        -- Check if the current user is the policyholder
        IF v_policyholder_id != USER THEN
            RAISE_APPLICATION_ERROR(-20003, 'Only the policyholder can cancel the policy.');
        END IF;

        -- Update the Policy Status
        UPDATE POLICY
        SET POLICY_STATUS = p_new_status
        WHERE POLICY_ID = p_policy_id;

        COMMIT;

        DBMS_OUTPUT.PUT_LINE('Policy status updated successfully.');
    END UpdatePolicyStatus;

    -- Stored Procedure: Review Policy (Manager Action)
    PROCEDURE ReviewPolicy(
        p_policy_id IN POLICY.POLICY_ID%TYPE
    ) IS
        v_current_status VARCHAR2(20);
    BEGIN
        -- Validate Policy
        IF NOT ValidatePolicy(p_policy_id) THEN
            RAISE_APPLICATION_ERROR(-20004, 'Policy does not exist.');
        END IF;

        -- Check if the policy is in progress
        IF NOT IsPolicyInProgress(p_policy_id) THEN
            RAISE_APPLICATION_ERROR(-20005, 'Policy is not in the "In Progress" state.');
        END IF;

        -- Update the Policy Status to Active
        UPDATE POLICY
        SET POLICY_STATUS = 'Active'
        WHERE POLICY_ID = p_policy_id;

        COMMIT;

        DBMS_OUTPUT.PUT_LINE('Policy reviewed successfully and updated to "Active".');
    END ReviewPolicy;

    -- Function: Check Policy Validity
    FUNCTION CheckPolicyValidity(
        p_policy_id IN POLICY.POLICY_ID%TYPE
    ) RETURN VARCHAR2 IS
        v_status VARCHAR2(20);
        v_end_date DATE;
    BEGIN
        SELECT POLICY_STATUS, END_DATE
        INTO v_status, v_end_date
        FROM POLICY
        WHERE POLICY_ID = p_policy_id;

        -- Determine Policy Validity
        IF v_status = 'Active' AND v_end_date > SYSDATE THEN
            RETURN 'Valid';
        ELSE
            RETURN 'Invalid';
        END IF;
    END CheckPolicyValidity;

    -- Function: Get Policy Details
    FUNCTION GetPolicyDetails(
        p_policy_id IN POLICY.POLICY_ID%TYPE
    ) RETURN VARCHAR2 IS
        v_details VARCHAR2(1000);
    BEGIN
        SELECT 'Policy ID: ' || POLICY_ID || ', Status: ' || POLICY_STATUS || 
               ', Start Date: ' || TO_CHAR(START_DATE, 'YYYY-MM-DD') || 
               ', End Date: ' || TO_CHAR(END_DATE, 'YYYY-MM-DD') || 
               ', Premium: ' || PREMIUM_AMOUNT || 
               ', Coverage: ' || COVERAGE_AMOUNT || 
               ', Policyholder ID: ' || POLICYHOLDER_ID || 
               ', Provider ID: ' || PROVIDER_ID || 
               ', Insurance Type ID: ' || INSURANCE_TYPE_ID
        INTO v_details
        FROM POLICY
        WHERE POLICY_ID = p_policy_id;

        RETURN v_details;
    END GetPolicyDetails;

END policy_management_package;
/
