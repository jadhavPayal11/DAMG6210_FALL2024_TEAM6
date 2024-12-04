-- Wrapper for SubmitClaim
CREATE OR REPLACE PROCEDURE SubmitClaimWrapper (
    p_policy_id IN CLAIM.POLICY_ID%TYPE,
    p_agent_id IN CLAIM.AGENT_ID%TYPE,
    p_claim_date IN CLAIM.CLAIM_DATE%TYPE,
    p_claim_type IN CLAIM.CLAIM_TYPE%TYPE,
    p_claim_description IN CLAIM.CLAIM_DESCRIPTION%TYPE,
    p_claim_amount IN CLAIM.CLAIM_AMOUNT%TYPE,
    p_claim_status IN CLAIM.CLAIM_STATUS%TYPE,
    p_claim_priority IN CLAIM.CLAIM_PRIORITY%TYPE,
    p_estimated_settlement_date IN CLAIM.ESTIMATED_SETTLEMENT_DATE%TYPE
)
AS
BEGIN
    -- Call the SubmitClaim procedure from the package
    ClaimLifecyclePackage.SubmitClaim(
        p_policy_id,
        p_agent_id,
        p_claim_date,
        p_claim_type,
        p_claim_description,
        p_claim_amount,
        p_claim_status,
        p_claim_priority,
        p_estimated_settlement_date
    );
END SubmitClaimWrapper;
/
-- Grant execute on SubmitClaimWrapper to PolicyHolder role
GRANT EXECUTE ON ICPS_CORE.SubmitClaimWrapper TO Policy_Holder;

-- Wrapper for ValidateClaim
CREATE OR REPLACE PROCEDURE ValidateClaimWrapper (
    p_claim_id IN CLAIM.CLAIM_ID%TYPE
)
AS
BEGIN
    -- Call the ValidateClaim procedure from the package
    ClaimLifecyclePackage.ValidateClaim(p_claim_id);
END ValidateClaimWrapper;
/
-- Grant execute on ValidateClaimWrapper to Manager and Adjuster roles
GRANT EXECUTE ON ValidateClaimWrapper TO Manager, Adjuster;

-- Wrapper for ProcessClaim
CREATE OR REPLACE PROCEDURE ProcessClaimWrapper (
    p_claim_id IN CLAIM.CLAIM_ID%TYPE,
    p_approval_status IN VARCHAR2,
    p_comments IN VARCHAR2
)
AS
BEGIN
    -- Call the ProcessClaim procedure from the package
    ClaimLifecyclePackage.ProcessClaim(
        p_claim_id,
        p_approval_status,
        p_comments
    );
END ProcessClaimWrapper;
/
-- Grant execute on ProcessClaimWrapper to Manager role
GRANT EXECUTE ON ProcessClaimWrapper TO Manager;

-- Verify the creation of wrappers
SET SERVEROUTPUT ON;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Verifying wrapper creation and grants...');
    FOR obj IN (SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME IN ('SUBMITCLAIMWRAPPER', 'VALIDATECLAIMWRAPPER', 'PROCESSCLAIMWRAPPER')) LOOP
        DBMS_OUTPUT.PUT_LINE('Object: ' || obj.OBJECT_NAME || ' - Status: ' || obj.STATUS);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Verification complete.');
END;
/
