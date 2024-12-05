SELECT policy_management_package.GetPolicyDetailsWrapper(3) AS policy_details FROM dual;
-- Expected Output: Full details of the policy in a formatted string

SELECT policy_management_package.GetPolicyDetailsWrapper(999) AS policy_details FROM dual;
-- Expected Output: Error - "Policy does not exist."
