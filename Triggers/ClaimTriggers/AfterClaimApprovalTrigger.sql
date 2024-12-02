/* 
    ORDER of Execution: 2nd Trigger
    THIS SCRIPT SHOULD BE RUN BY ICPS_CORE.
*/

SET SERVEROUTPUT ON;

DECLARE
    trigger_exists INTEGER;

BEGIN
    -- Check if trigger exists
    SELECT COUNT(*) INTO trigger_exists
    FROM all_triggers
    WHERE trigger_name = 'AFTER_CLAIM_APPROVAL_TRIGGER';

    -- Drop trigger if exists
    IF trigger_exists > 0 THEN
        EXECUTE IMMEDIATE 'DROP TRIGGER AFTER_CLAIM_APPROVAL_TRIGGER';
        DBMS_OUTPUT.PUT_LINE('Trigger AFTER_CLAIM_APPROVAL_TRIGGER dropped.');
    END IF;

    -- Create trigger
    EXECUTE IMMEDIATE '
        CREATE OR REPLACE TRIGGER AFTER_CLAIM_APPROVAL_TRIGGER
        AFTER UPDATE OF claim_status ON CLAIM
        FOR EACH ROW
        DECLARE
            v_notification_message VARCHAR2(255);
        BEGIN
            -- Check for claim approval or rejection
            IF :NEW.claim_status = ''Approved'' THEN
                v_notification_message := ''Claim ID '' || :NEW.claim_id || '' has been approved.'';
            ELSIF :NEW.claim_status = ''Rejected'' THEN
                v_notification_message := ''Claim ID '' || :NEW.claim_id || '' has been rejected.'';
            ELSE
                RETURN; -- Do nothing for other statuses
            END IF;

            -- Log the status change
            INSERT INTO CLAIM_LOG (log_id, claim_id, old_status, new_status, change_date)
            VALUES (CLAIM_LOG_SEQ.NEXTVAL, :NEW.claim_id, :OLD.claim_status, :NEW.claim_status, SYSDATE);

            -- Send notification (placeholder for now)
            DBMS_OUTPUT.PUT_LINE(''Notification: '' || v_notification_message);

        END;
    ';

    DBMS_OUTPUT.PUT_LINE('Trigger AFTER_CLAIM_APPROVAL_TRIGGER created successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/

/*

SELECT TRIGGER_NAME, STATUS FROM USER_TRIGGERS WHERE TABLE_NAME = 'CLAIM';

select * from claim;

UPDATE CLAIM
SET claim_status = 'Approved'
WHERE claim_id = 1;


*/

COMMIT;
