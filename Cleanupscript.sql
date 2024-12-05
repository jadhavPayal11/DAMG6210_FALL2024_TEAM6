SET SERVEROUTPUT ON;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Starting cleanup process...');

    -- Drop Triggers
    BEGIN
        EXECUTE IMMEDIATE 'DROP TRIGGER BEFORE_CLAIM_INSERT_TRIGGER';
        DBMS_OUTPUT.PUT_LINE('Trigger BEFORE_CLAIM_INSERT_TRIGGER dropped.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Trigger BEFORE_CLAIM_INSERT_TRIGGER not found or already dropped.');
    END;

    BEGIN
        EXECUTE IMMEDIATE 'DROP TRIGGER AFTER_CLAIM_APPROVAL_TRIGGER';
        DBMS_OUTPUT.PUT_LINE('Trigger AFTER_CLAIM_APPROVAL_TRIGGER dropped.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Trigger AFTER_CLAIM_APPROVAL_TRIGGER not found or already dropped.');
    END;

    -- Drop Procedures and Functions
    BEGIN
        EXECUTE IMMEDIATE 'DROP PROCEDURE SUBMITCLAIMWRAPPER';
        DBMS_OUTPUT.PUT_LINE('Procedure SUBMITCLAIMWRAPPER dropped.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Procedure SUBMITCLAIMWRAPPER not found or already dropped.');
    END;

    BEGIN
        EXECUTE IMMEDIATE 'DROP PROCEDURE VALIDATECLAIMWRAPPER';
        DBMS_OUTPUT.PUT_LINE('Procedure VALIDATECLAIMWRAPPER dropped.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Procedure VALIDATECLAIMWRAPPER not found or already dropped.');
    END;

    BEGIN
        EXECUTE IMMEDIATE 'DROP PROCEDURE PROCESSCLAIMWRAPPER';
        DBMS_OUTPUT.PUT_LINE('Procedure PROCESSCLAIMWRAPPER dropped.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Procedure PROCESSCLAIMWRAPPER not found or already dropped.');
    END;

    -- Drop Package
    BEGIN
        EXECUTE IMMEDIATE 'DROP PACKAGE CLAIMLIFECYCLEPACKAGE';
        DBMS_OUTPUT.PUT_LINE('Package CLAIMLIFECYCLEPACKAGE dropped.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Package CLAIMLIFECYCLEPACKAGE not found or already dropped.');
    END;

    -- Drop Sequences
    BEGIN
        EXECUTE IMMEDIATE 'DROP SEQUENCE CLAIM_SEQ';
        DBMS_OUTPUT.PUT_LINE('Sequence CLAIM_SEQ dropped.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Sequence CLAIM_SEQ not found or already dropped.');
    END;

    BEGIN
        EXECUTE IMMEDIATE 'DROP SEQUENCE CLAIM_LOG_SEQ';
        DBMS_OUTPUT.PUT_LINE('Sequence CLAIM_LOG_SEQ dropped.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Sequence CLAIM_LOG_SEQ not found or already dropped.');
    END;

    -- Drop Tables
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE CLAIM_LOG CASCADE CONSTRAINTS';
        DBMS_OUTPUT.PUT_LINE('Table CLAIM_LOG dropped.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Table CLAIM_LOG not found or already dropped.');
    END;

    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE CLAIM CASCADE CONSTRAINTS';
        DBMS_OUTPUT.PUT_LINE('Table CLAIM dropped.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Table CLAIM not found or already dropped.');
    END;

    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE POLICY CASCADE CONSTRAINTS';
        DBMS_OUTPUT.PUT_LINE('Table POLICY dropped.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Table POLICY not found or already dropped.');
    END;

    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE AGENT CASCADE CONSTRAINTS';
        DBMS_OUTPUT.PUT_LINE('Table AGENT dropped.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Table AGENT not found or already dropped.');
    END;

    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE PROVIDER CASCADE CONSTRAINTS';
        DBMS_OUTPUT.PUT_LINE('Table PROVIDER dropped.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Table PROVIDER not found or already dropped.');
    END;

    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE POLICYHOLDER CASCADE CONSTRAINTS';
        DBMS_OUTPUT.PUT_LINE('Table POLICYHOLDER dropped.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Table POLICYHOLDER not found or already dropped.');
    END;

    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE INSURANCE_TYPE CASCADE CONSTRAINTS';
        DBMS_OUTPUT.PUT_LINE('Table INSURANCE_TYPE dropped.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Table INSURANCE_TYPE not found or already dropped.');
    END;

    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE ADDRESS CASCADE CONSTRAINTS';
        DBMS_OUTPUT.PUT_LINE('Table ADDRESS dropped.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Table ADDRESS not found or already dropped.');
    END;

    DBMS_OUTPUT.PUT_LINE('Cleanup process completed.');
END;
/
COMMIT;