SELECT policy_management_package.CheckPolicyValidityWrapper(1) AS validity_status FROM dual;
-- Expected Output: "Valid"

-- Manually set the end_date for a policy to a past date for testing
UPDATE POLICY SET END_DATE = SYSDATE - 1 WHERE POLICY_ID = 2;
COMMIT;

SELECT policy_management_package.CheckPolicyValidityWrapper(2) AS validity_status FROM dual;
-- Expected Output: "Invalid"

SELECT policy_management_package.CheckPolicyValidityWrapper(5) AS validity_status FROM dual;
-- Expected Output: "Invalid" (as end_date is NULL)
