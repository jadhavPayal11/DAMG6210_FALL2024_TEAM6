SET SERVEROUTPUT ON;

DECLARE
    role_exists INTEGER;
BEGIN
    -- Role and privileges for ICPS_CORE
    BEGIN
        SELECT COUNT(*) INTO role_exists FROM DBA_ROLES WHERE ROLE = 'ICPS_CORE_ROLE';
        IF role_exists = 1 THEN
            EXECUTE IMMEDIATE 'DROP ROLE ICPS_CORE_ROLE';
            DBMS_OUTPUT.PUT_LINE('Role ICPS_CORE_ROLE dropped');
        END IF;

        EXECUTE IMMEDIATE 'CREATE ROLE ICPS_CORE_ROLE';
        DBMS_OUTPUT.PUT_LINE('Role ICPS_CORE_ROLE created');
        EXECUTE IMMEDIATE 'GRANT ALTER SESSION, CONNECT, RESOURCE TO ICPS_CORE_ROLE';
        EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON ADDRESS TO ICPS_CORE_ROLE';
        EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON INSURANCE_TYPE TO ICPS_CORE_ROLE';
        EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON POLICYHOLDER TO ICPS_CORE_ROLE';
        EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON PROVIDER TO ICPS_CORE_ROLE';
        EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON AGENT TO ICPS_CORE_ROLE';
        EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON INSURANCE_APPLICATION TO ICPS_CORE_ROLE';
        EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON POLICY TO ICPS_CORE_ROLE';
        EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON CLAIM TO ICPS_CORE_ROLE';
        EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON PAYMENT TO ICPS_CORE_ROLE';
        EXECUTE IMMEDIATE 'GRANT UNLIMITED TABLESPACE TO ICPS_CORE';
        EXECUTE IMMEDIATE 'GRANT ICPS_CORE_ROLE TO ICPS_CORE';
        DBMS_OUTPUT.PUT_LINE('ICPS_CORE_ROLE created and privileges granted.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Exception occurred at ICPS_CORE_ROLE creation: ' || SQLERRM);
    END;

    -- Role and privileges for PROVIDER
    BEGIN
        SELECT COUNT(*) INTO role_exists FROM DBA_ROLES WHERE ROLE = 'PROVIDER_ROLE';
        IF role_exists = 1 THEN
            EXECUTE IMMEDIATE 'DROP ROLE PROVIDER_ROLE';
            DBMS_OUTPUT.PUT_LINE('Role PROVIDER_ROLE dropped');
        END IF;

        EXECUTE IMMEDIATE 'CREATE ROLE PROVIDER_ROLE';
        DBMS_OUTPUT.PUT_LINE('Role PROVIDER_ROLE created');
        EXECUTE IMMEDIATE 'GRANT CONNECT TO PROVIDER_ROLE';
        EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON PROVIDER TO PROVIDER_ROLE';
        EXECUTE IMMEDIATE 'GRANT PROVIDER_ROLE TO PROVIDER';
        DBMS_OUTPUT.PUT_LINE('PROVIDER_ROLE created and privileges granted.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Exception occurred at PROVIDER_ROLE creation: ' || SQLERRM);
    END;

    -- Role and privileges for POLICY_HOLDER
    BEGIN
        SELECT COUNT(*) INTO role_exists FROM DBA_ROLES WHERE ROLE = 'POLICY_HOLDER_ROLE';
        IF role_exists = 1 THEN
            EXECUTE IMMEDIATE 'DROP ROLE POLICY_HOLDER_ROLE';
            DBMS_OUTPUT.PUT_LINE('Role POLICY_HOLDER_ROLE dropped');
        END IF;

        EXECUTE IMMEDIATE 'CREATE ROLE POLICY_HOLDER_ROLE';
        DBMS_OUTPUT.PUT_LINE('Role POLICY_HOLDER_ROLE created');
        EXECUTE IMMEDIATE 'GRANT CONNECT TO POLICY_HOLDER_ROLE';
        EXECUTE IMMEDIATE 'GRANT SELECT, UPDATE ON POLICYHOLDER TO POLICY_HOLDER_ROLE';
        EXECUTE IMMEDIATE 'GRANT POLICY_HOLDER_ROLE TO POLICY_HOLDER';
        DBMS_OUTPUT.PUT_LINE('POLICY_HOLDER_ROLE created and privileges granted.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Exception occurred at POLICY_HOLDER_ROLE creation: ' || SQLERRM);
    END;

    -- Role and privileges for MANAGER
    BEGIN
        SELECT COUNT(*) INTO role_exists FROM DBA_ROLES WHERE ROLE = 'MANAGER_ROLE';
        IF role_exists = 1 THEN
            EXECUTE IMMEDIATE 'DROP ROLE MANAGER_ROLE';
            DBMS_OUTPUT.PUT_LINE('Role MANAGER_ROLE dropped');
        END IF;

        EXECUTE IMMEDIATE 'CREATE ROLE MANAGER_ROLE';
        DBMS_OUTPUT.PUT_LINE('Role MANAGER_ROLE created');
        EXECUTE IMMEDIATE 'GRANT CONNECT TO MANAGER_ROLE';
        EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON AGENT TO MANAGER_ROLE';
        EXECUTE IMMEDIATE 'GRANT SELECT, INSERT ON POLICYHOLDER TO MANAGER_ROLE';
        EXECUTE IMMEDIATE 'GRANT SELECT, UPDATE ON CLAIM TO MANAGER_ROLE';
        EXECUTE IMMEDIATE 'GRANT MANAGER_ROLE TO MANAGER';
        DBMS_OUTPUT.PUT_LINE('MANAGER_ROLE created and privileges granted.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Exception occurred at MANAGER_ROLE creation: ' || SQLERRM);
    END;

    -- Role and privileges for ADJUSTER
    BEGIN
        SELECT COUNT(*) INTO role_exists FROM DBA_ROLES WHERE ROLE = 'ADJUSTER_ROLE';
        IF role_exists = 1 THEN
            EXECUTE IMMEDIATE 'DROP ROLE ADJUSTER_ROLE';
            DBMS_OUTPUT.PUT_LINE('Role ADJUSTER_ROLE dropped');
        END IF;

        EXECUTE IMMEDIATE 'CREATE ROLE ADJUSTER_ROLE';
        DBMS_OUTPUT.PUT_LINE('Role ADJUSTER_ROLE created');
        EXECUTE IMMEDIATE 'GRANT CONNECT TO ADJUSTER_ROLE';
        EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE ON CLAIM TO ADJUSTER_ROLE';
        EXECUTE IMMEDIATE 'GRANT SELECT, INSERT ON INSURANCE_APPLICATION TO ADJUSTER_ROLE';
        EXECUTE IMMEDIATE 'GRANT SELECT, INSERT ON POLICYHOLDER TO ADJUSTER_ROLE';
        EXECUTE IMMEDIATE 'GRANT ADJUSTER_ROLE TO ADJUSTER';
        DBMS_OUTPUT.PUT_LINE('ADJUSTER_ROLE created and privileges granted.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Exception occurred at ADJUSTER_ROLE creation: ' || SQLERRM);
    END;

    -- Role and privileges for SALESMAN
    BEGIN
        SELECT COUNT(*) INTO role_exists FROM DBA_ROLES WHERE ROLE = 'SALESMAN_ROLE';
        IF role_exists = 1 THEN
            EXECUTE IMMEDIATE 'DROP ROLE SALESMAN_ROLE';
            DBMS_OUTPUT.PUT_LINE('Role SALESMAN_ROLE dropped');
        END IF;

        EXECUTE IMMEDIATE 'CREATE ROLE SALESMAN_ROLE';
        DBMS_OUTPUT.PUT_LINE('Role SALESMAN_ROLE created');
        EXECUTE IMMEDIATE 'GRANT CONNECT TO SALESMAN_ROLE';
        EXECUTE IMMEDIATE 'GRANT SELECT ON POLICY TO SALESMAN_ROLE';
        EXECUTE IMMEDIATE 'GRANT SELECT, INSERT ON INSURANCE_APPLICATION TO SALESMAN_ROLE';
        EXECUTE IMMEDIATE 'GRANT SALESMAN_ROLE TO SALESMAN';
        DBMS_OUTPUT.PUT_LINE('SALESMAN_ROLE created and privileges granted.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Exception occurred at SALESMAN_ROLE creation: ' || SQLERRM);
    END;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Exception occurred in the main block: ' || SQLERRM);
END;
/
