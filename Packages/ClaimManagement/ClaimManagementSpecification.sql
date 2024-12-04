CREATE OR REPLACE PACKAGE ClaimLifecyclePackage AS
    -- Submit a new claim
    PROCEDURE SubmitClaim(  -- PolicyHolder
        p_policy_id IN CLAIM.POLICY_ID%TYPE,
        p_agent_id IN CLAIM.AGENT_ID%TYPE,
        p_claim_date IN CLAIM.CLAIM_DATE%TYPE,
        p_claim_type IN CLAIM.CLAIM_TYPE%TYPE,
        p_claim_description IN CLAIM.CLAIM_DESCRIPTION%TYPE,
        p_claim_amount IN CLAIM.CLAIM_AMOUNT%TYPE,
        p_claim_status IN CLAIM.CLAIM_STATUS%TYPE,
        p_claim_priority IN CLAIM.CLAIM_PRIORITY%TYPE,
        p_estimated_settlement_date IN CLAIM.ESTIMATED_SETTLEMENT_DATE%TYPE
    );

    -- Validate a submitted claim
    PROCEDURE ValidateClaim( --User: Manager, Adjuster
        p_claim_id IN CLAIM.CLAIM_ID%TYPE
    );

    -- Process a claim (approve/reject)
    PROCEDURE ProcessClaim( -- Manager
        p_claim_id IN CLAIM.CLAIM_ID%TYPE,
        p_approval_status IN VARCHAR2,
        p_comments IN VARCHAR2
    );

    -- Helper function to check if a claim is valid for validation
    FUNCTION IsClaimValidForValidation( 
        p_claim_id IN CLAIM.CLAIM_ID%TYPE
    ) RETURN BOOLEAN;

    -- Helper function to check if a policyholder exists
    FUNCTION ValidatePolicyholder(
        p_policy_id IN POLICY.POLICY_ID%TYPE
    ) RETURN BOOLEAN;

    -- Helper function to check if a policy is active and not expired
    FUNCTION IsPolicyActive(
        p_policy_id IN POLICY.POLICY_ID%TYPE
    ) RETURN BOOLEAN;
END ClaimLifecyclePackage;
/
