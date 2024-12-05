-- Wrapper for UpdatePolicyStatus
CREATE OR REPLACE PROCEDURE UpdatePolicyStatusWrapper (
    p_policy_id IN POLICY.POLICY_ID%TYPE,
    p_policyholder_id IN POLICY.POLICYHOLDER_ID%TYPE,
    p_new_status IN VARCHAR2
)
AS
BEGIN
    -- Call the UpdatePolicyStatus procedure from the package
    policy_management_package.UpdatePolicyStatus(
        p_policy_id,
        p_policyholder_id,
        p_new_status
    );
END UpdatePolicyStatusWrapper;
/
-- Grant execute on UpdatePolicyStatusWrapper to Policy_Holder role
GRANT EXECUTE ON UpdatePolicyStatusWrapper TO Policy_Holder;

-- Wrapper for ReviewPolicy
CREATE OR REPLACE PROCEDURE ReviewPolicyWrapper (
    p_policy_id IN POLICY.POLICY_ID%TYPE
)
AS
BEGIN
    -- Call the ReviewPolicy procedure from the package
    policy_management_package.ReviewPolicy(
        p_policy_id
    );
END ReviewPolicyWrapper;
/
-- Grant execute on ReviewPolicyWrapper to Manager role
GRANT EXECUTE ON ReviewPolicyWrapper TO Manager;

-- Wrapper for CheckPolicyValidity
CREATE OR REPLACE FUNCTION CheckPolicyValidityWrapper (
    p_policy_id IN POLICY.POLICY_ID%TYPE
) RETURN VARCHAR2
AS
    v_result VARCHAR2(20);
BEGIN
    -- Call the CheckPolicyValidity function from the package
    v_result := policy_management_package.CheckPolicyValidity(
        p_policy_id
    );
    RETURN v_result;
END CheckPolicyValidityWrapper;
/
-- Grant execute on CheckPolicyValidityWrapper to Policy_Holder, Manager, Adjuster, and Salesman roles
GRANT EXECUTE ON CheckPolicyValidityWrapper TO Policy_Holder, Manager, Adjuster, Salesman;

-- Wrapper for GetPolicyDetails
CREATE OR REPLACE FUNCTION GetPolicyDetailsWrapper (
    p_policy_id IN POLICY.POLICY_ID%TYPE
) RETURN VARCHAR2
AS
    v_details VARCHAR2(1000);
BEGIN
    -- Call the GetPolicyDetails function from the package
    v_details := policy_management_package.GetPolicyDetails(
        p_policy_id
    );
    RETURN v_details;
END GetPolicyDetailsWrapper;
/
-- Grant execute on GetPolicyDetailsWrapper to Policy_Holder, Manager, Adjuster, and Salesman roles
GRANT EXECUTE ON GetPolicyDetailsWrapper TO Policy_Holder, Manager, Adjuster, Salesman;
