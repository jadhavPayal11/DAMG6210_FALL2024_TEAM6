
BEGIN
    -- Update an active policy's status to "Canceled" by the policyholder
    UpdatePolicyStatus(2, 1, 'Canceled');
END;
/
-- Verify the update
SELECT
    "A1"."POLICY_ID"         "POLICY_ID",
    "A1"."APPLICATION_ID"    "APPLICATION_ID",
    "A1"."POLICYHOLDER_ID"   "POLICYHOLDER_ID",
    "A1"."PROVIDER_ID"       "PROVIDER_ID",
    "A1"."INSURANCE_TYPE_ID" "INSURANCE_TYPE_ID",
    "A1"."START_DATE"        "START_DATE",
    "A1"."END_DATE"          "END_DATE",
    "A1"."PREMIUM_AMOUNT"    "PREMIUM_AMOUNT",
    "A1"."COVERAGE_AMOUNT"   "COVERAGE_AMOUNT",
    "A1"."POLICY_STATUS"     "POLICY_STATUS"
FROM
    "ICPS_CORE"."POLICY" "A1";
-- Expected Output: "Canceled"
