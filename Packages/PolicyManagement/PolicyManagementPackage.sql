CREATE OR REPLACE PACKAGE policy_management_package AS
    -- Helper Functions
    FUNCTION ValidatePolicy(p_policy_id IN POLICY.POLICY_ID%TYPE) RETURN BOOLEAN;
    FUNCTION ValidatePolicyHolder(
        p_policy_id IN POLICY.POLICY_ID%TYPE,
        p_policyholder_id IN POLICY.POLICYHOLDER_ID%TYPE
    ) RETURN BOOLEAN;
    FUNCTION IsPolicyInProgress(p_policy_id IN POLICY.POLICY_ID%TYPE) RETURN BOOLEAN;
    FUNCTION IsPolicyActive(p_policy_id IN POLICY.POLICY_ID%TYPE) RETURN BOOLEAN;

    -- Stored Procedures
    PROCEDURE UpdatePolicyStatus(
        p_policy_id IN POLICY.POLICY_ID%TYPE,
        p_policyholder_id IN POLICY.POLICYHOLDER_ID%TYPE,
        p_new_status IN VARCHAR2
    );
    PROCEDURE ReviewPolicy(p_policy_id IN POLICY.POLICY_ID%TYPE);

    -- Functions
    FUNCTION CheckPolicyValidity(p_policy_id IN POLICY.POLICY_ID%TYPE) RETURN VARCHAR2;
    FUNCTION GetPolicyDetails(p_policy_id IN POLICY.POLICY_ID%TYPE) RETURN VARCHAR2;
END policy_management_package;
/
