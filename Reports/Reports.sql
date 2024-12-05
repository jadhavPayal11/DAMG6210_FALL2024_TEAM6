SET SERVEROUTPUT ON;

CREATE OR REPLACE VIEW CLAIM_PERFORMANCE_VIEW AS
SELECT 
    C.CLAIM_ID,
    C.POLICY_ID,
    P.POLICYHOLDER_ID,
    PH.FIRST_NAME || ' ' || PH.LAST_NAME AS POLICYHOLDER_NAME,
    C.AGENT_ID,
    A.FIRST_NAME || ' ' || A.LAST_NAME AS AGENT_NAME,
    P.INSURANCE_TYPE_ID,
    IT.INSURANCE_TYPE_NAME,
    C.CLAIM_DATE,
    C.CLAIM_TYPE,
    C.CLAIM_DESCRIPTION,
    C.CLAIM_AMOUNT,
    P.COVERAGE_AMOUNT,
    C.CLAIM_STATUS,
    C.CLAIM_PRIORITY,
    C.ESTIMATED_SETTLEMENT_DATE,
    (SELECT MAX(CHANGE_DATE)
     FROM CLAIM_LOG CL
     WHERE CL.CLAIM_ID = C.CLAIM_ID) AS LAST_STATUS_CHANGE_DATE,
    (SELECT COUNT(*) 
     FROM CLAIM_LOG CL 
     WHERE CL.CLAIM_ID = C.CLAIM_ID) AS STATUS_CHANGE_COUNT,
    CASE
        WHEN P.COVERAGE_AMOUNT - NVL((SELECT SUM(CLAIM_AMOUNT)
                                      FROM CLAIM 
                                      WHERE POLICY_ID = P.POLICY_ID), 0) >= 0 THEN 'Within Coverage'
        ELSE 'Exceeds Coverage'
    END AS COVERAGE_STATUS
FROM 
    CLAIM C
    JOIN POLICY P ON C.POLICY_ID = P.POLICY_ID
    JOIN POLICYHOLDER PH ON P.POLICYHOLDER_ID = PH.POLICYHOLDER_ID
    JOIN AGENT A ON C.AGENT_ID = A.AGENT_ID
    JOIN INSURANCE_TYPE IT ON P.INSURANCE_TYPE_ID = IT.INSURANCE_TYPE_ID;



CREATE OR REPLACE VIEW AGENT_CLAIM_PERFORMANCE AS
SELECT
    a.agent_id,
    a.first_name || ' ' || a.last_name AS agent_name,
    COUNT(c.claim_id) AS total_claims_processed,
    ROUND(AVG(c.estimated_settlement_date - c.claim_date), 2) AS avg_processing_time_days,
    SUM(CASE WHEN c.claim_status = 'Approved' THEN 1 ELSE 0 END) AS total_approved_claims,
    SUM(CASE WHEN c.claim_status = 'Rejected' THEN 1 ELSE 0 END) AS total_rejected_claims,
    ROUND(
        CASE 
            WHEN COUNT(c.claim_id) = 0 THEN 0
            ELSE (SUM(CASE WHEN c.claim_status = 'Approved' THEN 1 ELSE 0 END) / COUNT(c.claim_id)) * 100
        END, 
        2
    ) AS approval_rate_percent,
    SUM(c.claim_amount) AS total_claim_amount_handled,
    SUM(CASE 
        WHEN c.claim_priority = 'Critical' THEN 5
        WHEN c.claim_priority = 'High' THEN 4
        WHEN c.claim_priority = 'Medium' THEN 2
        ELSE 1
    END) AS priority_score
FROM
    AGENT a
LEFT JOIN
    CLAIM c ON a.agent_id = c.agent_id
GROUP BY
    a.agent_id, a.first_name, a.last_name
ORDER BY
    priority_score DESC, approval_rate_percent DESC, total_claims_processed DESC;

GRANT SELECT ON ICPS_CORE.AGENT_CLAIM_PERFORMANCE TO MANAGER;


CREATE OR REPLACE VIEW PAYMENT_MANAGEMENT_REPORT AS
SELECT
    p.payment_id,
    cl.claim_id,
    ph.policyholder_id,
    poh.first_name || ' ' || poh.last_name AS policyholder_name, -- Join POLICYHOLDER table for name
    c.policy_id,
    c.claim_type,
    c.claim_priority,
    p.payment_date,
    p.payment_amount,
    p.payment_method,
    p.payment_status,
    ROUND(p.payment_amount / (c.claim_amount + 0.01), 2) AS payment_to_claim_ratio,
    CASE
        WHEN p.payment_status = 'Failed' THEN 'High Risk'
        WHEN p.payment_date > c.estimated_settlement_date THEN 'Delayed'
        ELSE 'On Time'
    END AS payment_status_category,
    ROUND(AVG(p.payment_date - c.estimated_settlement_date) 
          OVER (PARTITION BY c.policy_id), 2) AS avg_payment_delay_by_policy,
    SUM(p.payment_amount) 
        OVER (PARTITION BY poh.policyholder_id) AS total_payments_by_policyholder,
    COUNT(p.payment_id) 
        OVER (PARTITION BY poh.policyholder_id) AS total_payments_count_by_policyholder
FROM
    PAYMENT p
INNER JOIN
    CLAIM c ON p.claim_id = c.claim_id
INNER JOIN
    POLICY ph ON c.policy_id = ph.policy_id -- Use POLICY table for policyholder linking
INNER JOIN
    POLICYHOLDER poh ON ph.policyholder_id = poh.policyholder_id -- Join POLICYHOLDER table
LEFT JOIN
    CLAIM_LOG cl ON cl.claim_id = c.claim_id
WHERE
    p.payment_date IS NOT NULL -- Exclude unpaid claims
ORDER BY
    payment_status_category DESC,
    avg_payment_delay_by_policy DESC,
    total_payments_by_policyholder DESC;


GRANT SELECT ON ICPS_CORE.PAYMENT_MANAGEMENT_REPORT TO MANAGER;

CREATE OR REPLACE VIEW INSURANCE_APPLICATION_ANALYSIS AS
SELECT
    ia.insurance_type_id,
    it.insurance_type_name,
    COUNT(ia.application_id) AS total_applications,
    SUM(CASE WHEN ia.status = 'Approved' THEN 1 ELSE 0 END) AS total_approved,
    SUM(CASE WHEN ia.status = 'Rejected' THEN 1 ELSE 0 END) AS total_rejected,
    SUM(CASE WHEN ia.status = 'Pending' THEN 1 ELSE 0 END) AS total_pending,
    ROUND(SUM(CASE WHEN ia.status = 'Approved' THEN 1 ELSE 0 END) / NULLIF(COUNT(ia.application_id), 0) * 100, 2) AS approval_rate_percent,
    ROUND(SUM(CASE WHEN ia.status = 'Rejected' THEN 1 ELSE 0 END) / NULLIF(COUNT(ia.application_id), 0) * 100, 2) AS rejection_rate_percent,
    AVG(ia.review_date - ia.application_date) AS avg_review_time_days
FROM
    INSURANCE_APPLICATION ia
JOIN
    INSURANCE_TYPE it ON ia.insurance_type_id = it.insurance_type_id
GROUP BY
    ia.insurance_type_id, it.insurance_type_name
ORDER BY
    approval_rate_percent DESC, total_applications DESC;


GRANT SELECT ON ICPS_CORE.PAYMENT_MANAGEMENT_REPORT TO POLICY_HOLDER, SALESMAN, MANAGER;

COMMIT;
/

Select * from ICPS_CORE.PAYMENT_MANAGEMENT_REPORT;
select * from icps_Core.INSURANCE_APPLICATION_ANALYSIS;
