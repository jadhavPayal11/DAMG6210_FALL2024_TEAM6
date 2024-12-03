CREATE OR REPLACE PACKAGE BODY ClaimLifecyclePackage AS
    PROCEDURE SubmitClaim (
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
    BEGIN
        -- Step 1: Validate Policyholder
        IF NOT ValidatePolicyholder(p_policy_id) THEN
            RAISE_APPLICATION_ERROR(-20002, 'Policyholder does not exist for the given policy.');
        END IF;

        -- Step 2: Insert the claim
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

        -- Step 3: Log the claim status in CLAIM_LOG
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
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20003, 'An unexpected error occurred: ' || SQLERRM);
    END SubmitClaim;
END ClaimLifecyclePackage;
/

COMMIT;
