/* 
    FILE: NotifyAgentOnHighRiskTrigger.sql
    PURPOSE: Trigger to notify the agent when a claim is flagged as high-risk.
    EXECUTION CONTEXT: This script should be run by ICPS_CORE.
*/

SET SERVEROUTPUT ON;

DECLARE
    trigger_exists INTEGER;

BEGIN
    -- Check if trigger already exists
    SELECT COUNT(*) INTO trigger_exists
    FROM all_triggers
    WHERE trigger_name = 'NOTIFY_AGENT_ON_HIGH_RISK_TRIGGER';

    -- Drop the trigger if it exists
    IF trigger_exists > 0 THEN
        EXECUTE IMMEDIATE 'DROP TRIGGER NOTIFY_AGENT_ON_HIGH_RISK_TRIGGER';
        DBMS_OUTPUT.PUT_LINE('Trigger NOTIFY_AGENT_ON_HIGH_RISK_TRIGGER dropped.');
    END IF;

    -- Create the trigger
    EXECUTE IMMEDIATE '
        CREATE OR REPLACE TRIGGER NOTIFY_AGENT_ON_HIGH_RISK_TRIGGER
        AFTER INSERT OR UPDATE OF CLAIM_PRIORITY ON CLAIM
        FOR EACH ROW
        DECLARE
            v_agent_email VARCHAR2(100);
        BEGIN
            -- Check if the claim is flagged as high-risk
            IF :NEW.CLAIM_PRIORITY = ''High'' OR :NEW.CLAIM_PRIORITY = ''Critical'' THEN
                -- Retrieve agent email
                SELECT EMAIL
                INTO v_agent_email
                FROM AGENT
                WHERE AGENT_ID = :NEW.AGENT_ID;

                -- Simulate sending notification
                DBMS_OUTPUT.PUT_LINE(
                    ''Notification: Claim with ID '' || :NEW.CLAIM_ID || 
                    '' has been flagged as '' || :NEW.CLAIM_PRIORITY || ''. Email sent to Agent: '' || v_agent_email
                );
            END IF;
        END;
    ';

    DBMS_OUTPUT.PUT_LINE('Trigger NOTIFY_AGENT_ON_HIGH_RISK_TRIGGER created successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
COMMIT;




/* Insert a claim with high risk 
INSERT INTO CLAIM (CLAIM_ID, POLICY_ID, AGENT_ID, CLAIM_DATE, CLAIM_TYPE, CLAIM_DESCRIPTION, CLAIM_AMOUNT, CLAIM_STATUS, CLAIM_PRIORITY, ESTIMATED_SETTLEMENT_DATE)
VALUES (201, 101, 1, TO_DATE('2024-12-01', 'YYYY-MM-DD'), 'Accident', 'Major accident involving multiple vehicles', 15000, 'Pending', 'High', TO_DATE('2024-12-15', 'YYYY-MM-DD'));

*/

