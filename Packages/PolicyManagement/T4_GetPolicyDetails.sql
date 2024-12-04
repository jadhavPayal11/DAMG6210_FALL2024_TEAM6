SELECT policy_management_package.GetPolicyDetails(3) AS policy_details FROM dual;
-- Expected Output: Full details of the policy in a formatted string

SELECT policy_management_package.GetPolicyDetails(999) AS policy_details FROM dual;
-- Expected Output: Error - "Policy does not exist."
