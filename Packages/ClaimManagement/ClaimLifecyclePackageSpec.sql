CREATE OR REPLACE PACKAGE BODY ClaimLifecyclePackage AS

    -- Function: IsClaimValidForValidation
    FUNCTION IsClaimValidForValidation(
        p_claim_id IN CLAIM.CLAIM_ID%TYPE
    ) RETURN BOOLEAN IS
        v_claim_status CLAIM.CLAIM_STATUS%TYPE;
    BEGIN
        -- Fetch the claim status
        SELECT CLAIM_STATUS
        INTO v_claim_status
        FROM CLAIM
        WHERE CLAIM_ID = p_claim_id;

        -- Check if the claim is in progress
        RETURN v_claim_status = 'In Progress';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN FALSE; -- Claim does not exist
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20010, 'Error while checking claim status: ' || SQLERRM);
    END IsClaimValidForValidation;

    -- Procedure: SubmitClaim
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
    ) IS
        v_policyholder_exists BOOLEAN := FALSE;
        v_policy_status POLICY.POLICY_STATUS%TYPE;
    BEGIN
        -- Validate Policyholder
        SELECT CASE WHEN COUNT(*) > 0 THEN TRUE ELSE FALSE END
        INTO v_policyholder_exists
        FROM POLICYHOLDER PH
        WHERE EXISTS (
            SELECT 1
            FROM POLICY P
            WHERE P.POLICY_ID = p_policy_id
            AND P.POLICYHOLDER_ID = PH.POLICYHOLDER_ID
        );

        IF NOT v_policyholder_exists THEN
            RAISE_APPLICATION_ERROR(-20002, 'Policyholder does not exist for the given policy.');
        END IF;

        -- Validate Policy Status
        SELECT POLICY_STATUS
        INTO v_policy_status
        FROM POLICY
        WHERE POLICY_ID = p_policy_id;

        IF v_policy_status != 'Active' THEN
            RAISE_APPLICATION_ERROR(-20004, 'Cannot submit claim: Policy is not active.');
        END IF;

        -- Insert the claim into the CLAIM table
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

        -- Log the claim status in CLAIM_LOG
        INSERT INTO CLAIM_LOG (
            LOG_ID,
            CLAIM_ID,
            OLD_STATUS,
            NEW_STATUS,
            CHANGE_DATE
        ) VALUES (
            CLAIM_LOG_SEQ.NEXTVAL,
            CLAIM_SEQ.CURRVAL,
            NULL,
            p_claim_status,
            SYSDATE
        );

        DBMS_OUTPUT.PUT_LINE('Claim submitted successfully.');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20005, 'Policy does not exist.');
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20006, 'Claim already exists with the same ID.');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20003, 'An unexpected error occurred: ' || SQLERRM);
    END SubmitClaim;

    -- Procedure: ValidateClaim
    PROCEDURE ValidateClaim(
        p_claim_id IN CLAIM.CLAIM_ID%TYPE
    ) IS
        v_claim_status CLAIM.CLAIM_STATUS%TYPE;
    BEGIN
        -- Check if the claim is valid for validation
        IF NOT IsClaimValidForValidation(p_claim_id) THEN
            RAISE_APPLICATION_ERROR(-20007, 'Claim is not valid for validation. Must be in progress.');
        END IF;

        -- Update claim status to "Validated"
        UPDATE CLAIM
        SET CLAIM_STATUS = 'Validated'
        WHERE CLAIM_ID = p_claim_id;

        -- Log the status change
        INSERT INTO CLAIM_LOG (
            LOG_ID,
            CLAIM_ID,
            OLD_STATUS,
            NEW_STATUS,
           
            CHANGE_DATE
        ) VALUES (
            CLAIM_LOG_SEQ.NEXTVAL,
            p_claim_id,
            'In Progress', -- Old status
            'Validated', -- New status
            SYSDATE
        );

        DBMS_OUTPUT.PUT_LINE('Claim validated successfully.');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20008, 'Claim does not exist.');
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20009, 'Duplicate entry in CLAIM_LOG.');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20011, 'An unexpected error occurred: ' || SQLERRM);
    END ValidateClaim;

END ClaimLifecyclePackage;
/

commit;