CREATE OR REPLACE PACKAGE BODY ClaimLifecyclePackage AS

    -- Helper function: Check if policyholder exists
    FUNCTION ValidatePolicyholder(
        p_policy_id IN POLICY.POLICY_ID%TYPE
    ) RETURN BOOLEAN IS
        v_count INTEGER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM POLICY
        WHERE POLICY_ID = p_policy_id;

        RETURN v_count > 0;
    END ValidatePolicyholder;

    -- Helper function: Check if policy is active
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

    -- Helper function: Check if a claim is valid for validation
    FUNCTION IsClaimValidForValidation(
        p_claim_id IN CLAIM.CLAIM_ID%TYPE
    ) RETURN BOOLEAN IS
        v_status VARCHAR2(20);
    BEGIN
        SELECT CLAIM_STATUS
        INTO v_status
        FROM CLAIM
        WHERE CLAIM_ID = p_claim_id;

        RETURN v_status = 'In Progress';
    END IsClaimValidForValidation;

    -- Submit a new claim
    PROCEDURE SubmitClaim(
        p_policy_id IN CLAIM.POLICY_ID%TYPE,
        p_agent_id IN CLAIM.AGENT_ID%TYPE,
        p_claim_date IN CLAIM.CLAIM_DATE%TYPE,
        p_claim_type IN CLAIM.CLAIM_TYPE%TYPE,
        p_claim_description IN CLAIM.CLAIM_DESCRIPTION%TYPE,
        p_claim_amount IN CLAIM.CLAIM_AMOUNT%TYPE,
        p_claim_status IN CLAIM.CLAIM_STATUS%TYPE,
        p_claim_priority IN CLAIM.CLAIM_PRIORITY%TYPE,
        p_estimated_settlement_date IN CLAIM.ESTIMATED_SETTLEMENT_DATE%TYPE
    ) AS
        v_total_claims NUMBER;
        v_coverage_amount NUMBER;
    BEGIN
        -- Step 1: Validate Policyholder
        IF NOT ValidatePolicyholder(p_policy_id) THEN
            RAISE_APPLICATION_ERROR(-20002, 'Policyholder does not exist for the given policy.');
        END IF;

        -- Step 2: Validate Policy Status
        IF NOT IsPolicyActive(p_policy_id) THEN
            RAISE_APPLICATION_ERROR(-20004, 'Cannot submit a claim for an inactive or expired policy.');
        END IF;
        
        -- Step 3: Validate total claims against coverage amount
        SELECT NVL(SUM(claim_amount), 0), p.coverage_amount
        INTO v_total_claims, v_coverage_amount
        FROM CLAIM c
        JOIN POLICY p ON c.policy_id = p.policy_id
        WHERE c.policy_id = p_policy_id
        GROUP BY p.coverage_amount;

        IF v_total_claims + p_claim_amount > v_coverage_amount THEN
            RAISE_APPLICATION_ERROR(-20006, 'Total claims exceed coverage limit.');
        END IF;

        -- Step 4: Insert the claim
        INSERT INTO CLAIM (
            CLAIM_ID,
            POLICY_ID,
            AGENT_ID,
            CLAIM_DATE,
            CLAIM_TYPE,
            CLAIM_DESCRIPTION,
            CLAIM_AMOUNT,
            CLAIM_STATUS,
            CLAIM_PRIORITY,
            ESTIMATED_SETTLEMENT_DATE
        ) VALUES (
            CLAIM_SEQ.NEXTVAL,
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

        -- Step 5: Log the claim status
        INSERT INTO CLAIM_LOG (
            LOG_ID,
            CLAIM_ID,
            OLD_STATUS,
            NEW_STATUS,
            CHANGE_DATE
        ) VALUES (
            CLAIM_LOG_SEQ.NEXTVAL,
            CLAIM_SEQ.CURRVAL,
            NULL, -- Old status is NULL for a new claim
            p_claim_status,
            SYSDATE
        );

        DBMS_OUTPUT.PUT_LINE('Claim submitted successfully.');
    END SubmitClaim;

    -- Validate a claim
    PROCEDURE ValidateClaim(
        p_claim_id IN CLAIM.CLAIM_ID%TYPE
    ) AS
    BEGIN
        -- Step 1: Validate claim status
        IF NOT IsClaimValidForValidation(p_claim_id) THEN
            RAISE_APPLICATION_ERROR(-20005, 'Claim is not in progress and cannot be validated.');
        END IF;

        -- Step 2: Update claim status to 'Validated'
        UPDATE CLAIM
        SET CLAIM_STATUS = 'Validated'
        WHERE CLAIM_ID = p_claim_id;

        -- Step 3: Log the status change
        INSERT INTO CLAIM_LOG (
            LOG_ID,
            CLAIM_ID,
            OLD_STATUS,
            NEW_STATUS,
            CHANGE_DATE
        ) VALUES (
            CLAIM_LOG_SEQ.NEXTVAL,
            p_claim_id,
            'In Progress',
            'Validated',
            SYSDATE
        );

        DBMS_OUTPUT.PUT_LINE('Claim validated successfully.');
    END ValidateClaim;

    -- Process a claim
    PROCEDURE ProcessClaim(
        p_claim_id IN CLAIM.CLAIM_ID%TYPE,
        p_approval_status IN VARCHAR2,
        p_comments IN VARCHAR2
    ) AS
        v_is_valid BOOLEAN;
        v_current_status CLAIM.CLAIM_STATUS%TYPE;
    BEGIN
        -- Step 1: Validate if the claim can be processed
        v_is_valid := IsClaimValidForProcessing(p_claim_id);

        IF NOT v_is_valid THEN
            RAISE_APPLICATION_ERROR(-20007, 'Claim cannot be processed: Validation failed.');
        END IF;

        -- Step 2: Fetch current status of the claim
        SELECT CLAIM_STATUS
        INTO v_current_status
        FROM CLAIM
        WHERE CLAIM_ID = p_claim_id;

        -- Step 3: Ensure claim is in "Validated" status before processing
        IF v_current_status != 'Validated' THEN
            RAISE_APPLICATION_ERROR(-20012, 'Claim cannot be processed: It is not in "Validated" status.');
        END IF;

        -- Step 4: Update claim status and log the change
        UPDATE CLAIM
        SET CLAIM_STATUS = p_approval_status,
            CLAIM_DESCRIPTION = p_comments
        WHERE CLAIM_ID = p_claim_id;

        INSERT INTO CLAIM_LOG (
            LOG_ID,
            CLAIM_ID,
            OLD_STATUS,
            NEW_STATUS,
            CHANGE_DATE
        ) VALUES (
            CLAIM_LOG_SEQ.NEXTVAL,
            p_claim_id,
            v_current_status,
            p_approval_status,
            SYSDATE
        );

        DBMS_OUTPUT.PUT_LINE('Claim ' || p_claim_id || ' processed successfully. New status: ' || p_approval_status);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20009, 'Claim not found.');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20010, 'An unexpected error occurred: ' || SQLERRM);
    END ProcessClaim;

    -- Function to validate if the claim is valid for processing
    FUNCTION IsClaimValidForProcessing(p_claim_id IN CLAIM.CLAIM_ID%TYPE) RETURN BOOLEAN IS
        v_policy_status POLICY.POLICY_STATUS%TYPE;
        v_claim_exists INTEGER;
        v_claim_total NUMBER;
        v_coverage_limit NUMBER;
    BEGIN
        -- Step 1: Check if the claim exists
        SELECT COUNT(*)
        INTO v_claim_exists
        FROM CLAIM
        WHERE CLAIM_ID = p_claim_id;

        IF v_claim_exists = 0 THEN
            RETURN FALSE; -- Claim does not exist
        END IF;

        -- Step 2: Verify associated policy is active
        SELECT POLICY.POLICY_STATUS
        INTO v_policy_status
        FROM POLICY
        JOIN CLAIM ON POLICY.POLICY_ID = CLAIM.POLICY_ID
        WHERE CLAIM.CLAIM_ID = p_claim_id;

        IF v_policy_status != 'Active' THEN
            RETURN FALSE; -- Policy is not active
        END IF;

        -- Step 3: Verify total claims for the policyholder do not exceed the coverage limit
        SELECT SUM(CLAIM_AMOUNT), POLICY.COVERAGE_AMOUNT
        INTO v_claim_total, v_coverage_limit
        FROM CLAIM
        JOIN POLICY ON CLAIM.POLICY_ID = POLICY.POLICY_ID
        WHERE POLICY.POLICY_ID = (
            SELECT POLICY_ID FROM CLAIM WHERE CLAIM_ID = p_claim_id
        )
        GROUP BY POLICY.COVERAGE_AMOUNT;

        IF v_claim_total > v_coverage_limit THEN
            RETURN FALSE; -- Total claims exceed coverage limit
        END IF;

        -- If all checks pass, the claim is valid for processing
        RETURN TRUE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN FALSE; -- Data inconsistency, return false
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20011, 'An unexpected error occurred during claim validation: ' || SQLERRM);
    END IsClaimValidForProcessing;

END ClaimLifecyclePackage;
/


