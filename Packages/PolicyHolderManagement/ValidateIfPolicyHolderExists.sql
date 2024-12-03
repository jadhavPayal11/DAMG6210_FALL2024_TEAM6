CREATE OR REPLACE FUNCTION ValidatePolicyholder(p_policy_id IN POLICY.POLICY_ID%TYPE)
RETURN BOOLEAN
IS
    v_policyholder_exists INTEGER;
BEGIN
    -- Check if policyholder exists for the given policy
    SELECT COUNT(*)
    INTO v_policyholder_exists
    FROM POLICY P
    WHERE P.POLICY_ID = p_policy_id
      AND EXISTS (
          SELECT 1
          FROM POLICYHOLDER PH
          WHERE PH.POLICYHOLDER_ID = P.POLICYHOLDER_ID
      );

    -- Return true if policyholder exists, false otherwise
    RETURN v_policyholder_exists > 0;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20004, 'Error occurred during policyholder validation: ' || SQLERRM);
END ValidatePolicyholder;
/

COMMIT;