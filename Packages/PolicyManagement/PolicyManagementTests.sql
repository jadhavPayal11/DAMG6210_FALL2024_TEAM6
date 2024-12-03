-- Test Cases for Policy Management Package
-- ========================================
-- Ensure this script is run after the package `policy_management` is created.

-- Setup Test Data
INSERT INTO Policy (policy_id, status, policyholder_id, start_date, end_date)
VALUES (101, 'Active', USER, SYSDATE - 10, SYSDATE + 10);
COMMIT;

INSERT INTO Policy (policy_id, status, policyholder_id, start_date, end_date)
VALUES (102, 'Active', USER, SYSDATE - 20, SYSDATE - 5);
COMMIT;

INSERT INTO Policy (policy_id, status, policyholder_id, start_date, end_date)
VALUES (103, 'Cancelled', USER, SYSDATE - 30, SYSDATE - 10);
COMMIT;

-- ====================
-- Test Stored Procedure
-- ====================
-- Test Case 1: Cancel an Active Policy
BEGIN
    policy_management.update_policy_status(101, 'Cancelled');
END;
/

-- Verify the update
SELECT policy_id, status
FROM Policy
WHERE policy_id = 101;

-- Test Case 2: Attempt to Cancel a Non-Active Policy (should raise an error)
BEGIN
    policy_management.update_policy_status(102, 'Cancelled');
END;
/

-- ====================
-- Test Function: check_policy_validity
-- ====================
-- Test Case 3: Check Validity of an Active and Valid Policy
SELECT policy_management.check_policy_validity(101) AS validity_status
FROM dual;

-- Test Case 4: Check Validity of an Expired Policy
SELECT policy_management.check_policy_validity(102) AS validity_status
FROM dual;

-- Test Case 5: Check Validity of a Cancelled Policy
SELECT policy_management.check_policy_validity(103) AS validity_status
FROM dual;

-- ====================
-- Test Function: get_policy_details
-- ====================
-- Test Case 6: Get Details of an Existing Policy
SELECT policy_management.get_policy_details(101) AS policy_details
FROM dual;

-- Test Case 7: Attempt to Get Details of a Non-Existing Policy (should raise an error)
SELECT policy_management.get_policy_details(999) AS policy_details
FROM dual;

-- Cleanup Test Data
DELETE FROM Policy
WHERE policy_id IN (101, 102, 103);
COMMIT;
