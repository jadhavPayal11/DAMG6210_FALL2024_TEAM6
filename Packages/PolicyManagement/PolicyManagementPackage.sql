CREATE OR REPLACE PACKAGE policy_management_package AS

    -- Stored Procedure: Update Policy Status
    -- Allows only the policyholder to cancel an active policy
    PROCEDURE UpdatePolicyStatus(
        p_policy_id IN POLICY.POLICY_ID%TYPE,
        p_new_status IN VARCHAR2
    );

    -- Stored Procedure: Review Policy
    -- Allows a manager to review a policy in the "In Progress" state and set it to "Active"
    PROCEDURE ReviewPolicy(
        p_policy_id IN POLICY.POLICY_ID%TYPE
    );

    -- Function: Check Policy Validity
    -- Determines if the policy is valid based on its status and end date
    FUNCTION CheckPolicyValidity(
        p_policy_id IN POLICY.POLICY_ID%TYPE
    ) RETURN VARCHAR2;

    -- Function: Get Policy Details
    -- Retrieves formatted details of the specified policy
    FUNCTION GetPolicyDetails(
        p_policy_id IN POLICY.POLICY_ID%TYPE
    ) RETURN VARCHAR2;

END policy_management_package;
/
