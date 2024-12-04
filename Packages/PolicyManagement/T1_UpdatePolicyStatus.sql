BEGIN
    policy_management_package.UpdatePolicyStatus(1, 'Canceled');
END;
/
-- Verify the update
SELECT
    "A1"."POLICY_STATUS" "POLICY_STATUS"
FROM
    "ICPS_CORE"."POLICY" "A1"
WHERE
    "A1"."POLICY_ID" = 1;
-- Expected Output: "Canceled"

BEGIN
    policy_management_package.UpdatePolicyStatus(5, 'Canceled');
END;
/
-- Expected Output: Error - "Only active policies can be cancelled."

BEGIN
    -- Assume USER != policyholder_id for policy_id = 1
    policy_management_package.UpdatePolicyStatus(1, 'Canceled');
END;
/
-- Expected Output: Error - "Only the policyholder can cancel the policy."
