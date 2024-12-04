BEGIN
    policy_management_package.ReviewPolicy(5);
END;
/
-- Verify the update
SELECT policy_status FROM POLICY WHERE policy_id = 5;
-- Expected Output: "Active"

BEGIN
    policy_management_package.ReviewPolicy(1);
END;
/
-- Expected Output: Error - "Policy is not in the 'In Progress' state."

BEGIN
    policy_management_package.ReviewPolicy(999);
END;
/
-- Expected Output: Error - "Policy does not exist."
