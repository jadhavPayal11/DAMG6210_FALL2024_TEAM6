-- Insert test data into POLICY table
INSERT INTO POLICY (policy_id, application_id, policyholder_id, provider_id, insurance_type_id, start_date, end_date, premium_amount, coverage_amount, policy_status)
VALUES (101, 1, 1, 1, 1, SYSDATE - 10, SYSDATE + 10, 500.00, 10000.00, 'In Progress');

INSERT INTO POLICY (policy_id, application_id, policyholder_id, provider_id, insurance_type_id, start_date, end_date, premium_amount, coverage_amount, policy_status)
VALUES (102, 2, 2, 2, 2, SYSDATE - 20, SYSDATE - 5, 1000.00, 20000.00, 'Expired');

INSERT INTO POLICY (policy_id, application_id, policyholder_id, provider_id, insurance_type_id, start_date, end_date, premium_amount, coverage_amount, policy_status)
VALUES (103, 3, 3, 3, 3, SYSDATE - 15, SYSDATE + 15, 1500.00, 30000.00, 'Active');

COMMIT;
