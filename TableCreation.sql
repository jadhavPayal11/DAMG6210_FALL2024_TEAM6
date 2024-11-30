SET SERVEROUTPUT ON;

ALTER SESSION SET CURRENT_SCHEMA = ICPS_CORE;


DECLARE
table_exists integer;

BEGIN
    --ADDRESS table
    begin
        table_exists := 0;
        select count(*)
        into table_exists
        from user_tables
        where upper(table_name) = 'ADDRESS';
        
        if(table_exists = 1)then
            execute immediate 'drop table address cascade constraints';
            dbms_output.put_line('Table ADDRESS dropped'); 
         end if;
         execute immediate 'CREATE TABLE ADDRESS(
         address_id INTEGER,
         address_line_1 VARCHAR2(30) CONSTRAINT addr_line_1_nn NOT NULL,
         address_line_2 VARCHAR2(30),
         address_type VARCHAR2(20),
         city VARCHAR2(30) CONSTRAINT city_nn NOT NULL,
         state VARCHAR2(30) CONSTRAINT state_nn NOT NULL,
         zipcode INTEGER CONSTRAINT zipcode_nn NOT NULL,
         country VARCHAR2(30) CONSTRAINT country_nn NOT NULL,
         combined_address GENERATED ALWAYS AS (
            CASE 
                WHEN address_line_2 IS NOT NULL 
                THEN address_line_1 || '', '' || address_line_2 
                ELSE NULL 
            END
         ) VIRTUAL,
         CONSTRAINT address_id_pk PRIMARY KEY (address_id),
         CONSTRAINT check_addr_type CHECK(address_type IN (''RESIDENTIAL'', ''COMMERCIAL'')),
         CONSTRAINT check_unique_addr UNIQUE(combined_address)
         )';
         
         EXECUTE IMMEDIATE 'ALTER TABLE ADDRESS MODIFY combined_address INVISIBLE';
         
         dbms_output.put_line('Table ADDRESS created');
       
    exception 
        when others then
            dbms_output.put_line('Exception occured while creating ADDRESS table: ' || sqlerrm);
    end;
    
  --INSURANCE_TYPE Table
    begin
        table_exists :=0;
        select count(*)
        into table_exists
        from user_tables
        where upper(table_name) = 'INSURANCE_TYPE';
        
        if(table_exists = 1)then
            execute immediate 'drop table INSURANCE_TYPE cascade constraints';
            dbms_output.put_line('Table INSURANCE_TYPE dropped'); 
         end if;
         execute immediate 'CREATE TABLE INSURANCE_TYPE (
            insurance_type_id INTEGER,
            insurance_type_name VARCHAR2(30) CONSTRAINT insurance_type_name_nn NOT NULL,
            description VARCHAR2(255),
            CONSTRAINT insurance_type_id_pk PRIMARY KEY (insurance_type_id),
            CONSTRAINT check_unique_instype_name UNIQUE(insurance_type_name)
        )';
        dbms_output.put_line('Table INSURANCE_TYPE Created');
       
    exception 
        when others then
            dbms_output.put_line('Exception occured while creating INSURANCE_TYPE table: '||sqlerrm);
        
    end; 
    
    
    -- Table POLICYHOLDER
    begin
        table_exists := 0;
        select count(*)
        into table_exists
        from user_tables
        where upper(table_name) = 'POLICYHOLDER';
        
        if(table_exists = 1)then
            execute immediate 'drop table POLICYHOLDER cascade constraints';
            dbms_output.put_line('Table POLICYHOLDER dropped'); 
         end if;
         execute immediate 'CREATE TABLE POLICYHOLDER (
            policyholder_id INTEGER,
            first_name VARCHAR2(30) CONSTRAINT fname_nn NOT NULL,
            last_name VARCHAR2(30) CONSTRAINT lname_nn NOT NULL,
            dob DATE,
            email VARCHAR2(30) CONSTRAINT email_nn NOT NULL,
            contact NUMBER(10) CONSTRAINT contact_nn NOT NULL,
            address_id INTEGER,
            CONSTRAINT policyholder_id_pk PRIMARY KEY (policyholder_id),
            CONSTRAINT ph_addr_id_fk FOREIGN KEY (address_id) REFERENCES ADDRESS(address_id) ON DELETE SET NULL
        )';
        dbms_output.put_line('Table POLICYHOLDER created');
       
    exception 
        when others then
            dbms_output.put_line('Exception occured while creating POLICYHOLDER table: '||sqlerrm);
        
    end;
    
  -- Table PROVIDER
    begin
        table_exists :=0;
        select count(*)
        into table_exists
        from user_tables
        where upper(table_name) = 'PROVIDER';
        
        if(table_exists = 1)then
            execute immediate 'drop table PROVIDER cascade constraints';
            dbms_output.put_line('Table PROVIDER dropped'); 
         end if;
         execute immediate 'CREATE TABLE PROVIDER (
            provider_id INTEGER PRIMARY KEY,
            provider_name VARCHAR2(30) CONSTRAINT provider_name_nn NOT NULL,
            email VARCHAR2(30) CONSTRAINT pr_email_nn NOT NULL,
            contact NUMBER(10) CONSTRAINT pr_contact_nn NOT NULL,
            address_id INTEGER,
            CONSTRAINT address_id_fk FOREIGN KEY (address_id) REFERENCES ADDRESS(address_id) ON DELETE SET NULL,
            CONSTRAINT check_unique_provider_name UNIQUE(provider_name),
            CONSTRAINT check_unique_email UNIQUE(email)
        )';
        dbms_output.put_line('Table PROVIDER Created');
       
    exception 
        when others then
            dbms_output.put_line('Exception occured while creating PROVIDER table: '||sqlerrm);
        
    end;

    -- Table AGENT
    begin
        table_exists :=0;
        select count(*)
        into table_exists
        from user_tables
        where upper(table_name) = 'AGENT';
        
        if(table_exists = 1)then
            execute immediate 'drop table AGENT cascade constraints';
            dbms_output.put_line('Table AGENT dropped'); 
         end if;
         execute immediate 'CREATE TABLE AGENT (
            agent_id INTEGER PRIMARY KEY,
            provider_id INTEGER CONSTRAINT agent_provider_id_nn NOT NULL,
            first_name VARCHAR2(30)CONSTRAINT agent_fname_nn NOT NULL,
            last_name VARCHAR2(30) CONSTRAINT agent_lname_nn NOT NULL,
            designation VARCHAR2(20) CONSTRAINT agent_designation_check CHECK (designation IN (''Manager'', ''Adjuster'', ''Salesman'')),
            manager_id INTEGER,
            email VARCHAR2(30) CONSTRAINT ag_email_nn NOT NULL,
            contact NUMBER(10),
            CONSTRAINT provider_id_fk FOREIGN KEY (provider_id) REFERENCES PROVIDER(provider_id) ON DELETE CASCADE,
            CONSTRAINT manager_id_fk FOREIGN KEY (manager_id) REFERENCES AGENT(agent_id) ON DELETE SET NULL,
            CONSTRAINT check_unique_ag_email UNIQUE(email),
            CONSTRAINT check_unique_ag_contact UNIQUE(contact)
        )';
        dbms_output.put_line('Table AGENT Created');
       
    exception 
        when others then
            dbms_output.put_line('Exception occured while creating AGENT table: '||sqlerrm);
        
    end;
   
    -- Table INSURANCE_APPLICATION
    begin
        table_exists :=0;
        select count(*)
        into table_exists
        from user_tables
        where upper(table_name) = 'INSURANCE_APPLICATION';
        
        if(table_exists = 1)then
            execute immediate 'drop table INSURANCE_APPLICATION cascade constraints';
            dbms_output.put_line('Table INSURANCE_APPLICATION dropped'); 
         end if;
         execute immediate 'CREATE TABLE INSURANCE_APPLICATION (
            application_id INTEGER PRIMARY KEY,
            policyholder_id INTEGER,
            insurance_type_id INTEGER CONSTRAINT insapp_type_id_nn NOT NULL ,
            application_date DATE DEFAULT SYSDATE CONSTRAINT insapp_date_nn NOT NULL,
            status VARCHAR2(20) CONSTRAINT insapp_status_check CHECK (status IN (''Pending'', ''Approved'', ''Rejected'')),
            review_date DATE CONSTRAINT insapp_review_date_nn NOT NULL,
            agent_id INTEGER,
            comments VARCHAR2(255),
            CONSTRAINT policyholder_id_fk FOREIGN KEY (policyholder_id) REFERENCES POLICYHOLDER(policyholder_id) ON DELETE SET NULL,
            CONSTRAINT insurance_type_fk FOREIGN KEY (insurance_type_id) REFERENCES INSURANCE_TYPE(insurance_type_id) ON DELETE CASCADE,
            CONSTRAINT agent_id_fk FOREIGN KEY (agent_id) REFERENCES AGENT(agent_id) ON DELETE SET NULL,
            CONSTRAINT chk_review_after_application CHECK (review_date > application_date)

        )';
        dbms_output.put_line('Table INSURANCE_APPLICATION Created');
       
    exception 
        when others then
            dbms_output.put_line('Exception occured while creating INSURANCE_APPLICATION table: '||sqlerrm);
        
    end;
      
    -- Table POLICY
    begin
        table_exists :=0;
        select count(*)
        into table_exists
        from user_tables
        where upper(table_name) = 'POLICY';
        
        if(table_exists = 1)then
            execute immediate 'drop table POLICY cascade constraints';
            dbms_output.put_line('Table POLICY dropped'); 
         end if;
         execute immediate 'CREATE TABLE POLICY (
            policy_id INTEGER PRIMARY KEY,
            application_id INTEGER CONSTRAINT policy_app_id_nn NOT NULL,
            policyholder_id INTEGER CONSTRAINT policy_holder_id_nn NOT NULL,
            provider_id INTEGER CONSTRAINT policy_provider_id_nn NOT NULL,
            insurance_type_id INTEGER CONSTRAINT insurance_type_id_nn NOT NULL,
            start_date DATE,
            end_date DATE,
            premium_amount NUMBER(10,2) CONSTRAINT policy_premium_check CHECK (premium_amount BETWEEN 20 AND 20000),
            coverage_amount NUMBER(10,2) CONSTRAINT policy_coverage_check CHECK (coverage_amount <= 500000),
            policy_status VARCHAR2(20) CONSTRAINT policy_status_check CHECK (policy_status IN (''Active'', ''Expired'', ''Canceled'', ''Pending'')),
            CONSTRAINT policy_application_id_fk FOREIGN KEY (application_id) REFERENCES INSURANCE_APPLICATION(application_id) ON DELETE CASCADE,
            CONSTRAINT policy_policyholder_id_fk FOREIGN KEY (policyholder_id) REFERENCES POLICYHOLDER(policyholder_id) ON DELETE CASCADE,
            CONSTRAINT policy_provider_id_fk FOREIGN KEY (provider_id) REFERENCES PROVIDER(provider_id) ON DELETE CASCADE,
            CONSTRAINT policy_insurance_type_id_fk FOREIGN KEY (insurance_type_id) REFERENCES INSURANCE_TYPE(insurance_type_id) ON DELETE CASCADE,
            CONSTRAINT chk_start_before_end CHECK (start_date < end_date),
            CONSTRAINT chk_coverage_more_than_premium CHECK (coverage_amount > premium_amount)
        )';
        dbms_output.put_line('Table POLICY Created');
       
    exception 
        when others then
            dbms_output.put_line('Exception occured while creating POLICY table: '||sqlerrm);
        
    end;
    
 
    -- Table CLAIM
    begin
        table_exists :=0;
        select count(*)
        into table_exists
        from user_tables
        where upper(table_name) = 'CLAIM';
        
        if(table_exists = 1)then
            execute immediate 'drop table CLAIM cascade constraints';
            dbms_output.put_line('Table CLAIM dropped'); 
         end if;
         execute immediate 'CREATE TABLE CLAIM (
            claim_id INTEGER PRIMARY KEY,
            policy_id INTEGER CONSTRAINT claim_policy_id_nn NOT NULL,
            agent_id INTEGER,
            claim_date DATE,
            claim_type VARCHAR2(20),
            claim_description VARCHAR2(255),
            claim_amount NUMBER(10,2), 
            claim_status VARCHAR2(20),
            claim_priority VARCHAR2(10),
            estimated_settlement_date DATE,
            CONSTRAINT claim_policy_id_fk FOREIGN KEY (policy_id) REFERENCES POLICY(policy_id) ON DELETE CASCADE,
            CONSTRAINT claim_agent_id_fk FOREIGN KEY (agent_id) REFERENCES AGENT(agent_id) ON DELETE SET NULL
        )';
        dbms_output.put_line('Table CLAIM Created');
       
    exception 
        when others then
            dbms_output.put_line('Exception occured while creating CLAIM table: '||sqlerrm);
        
    end;
    
    -- Table PAYMENT
    begin
        table_exists :=0;
        select count(*)
        into table_exists
        from user_tables
        where upper(table_name) = 'PAYMENT';
        
        if(table_exists = 1)then
            execute immediate 'drop table PAYMENT cascade constraints';
            dbms_output.put_line('Table PAYMENT dropped'); 
         end if;
         execute immediate 'CREATE TABLE PAYMENT (
            payment_id INTEGER PRIMARY KEY,
            claim_id INTEGER CONSTRAINT claim_id_nn NOT NULL,
            payment_date DATE,
            payment_amount INTEGER,
            payment_method VARCHAR2(20) CONSTRAINT payment_method_check CHECK (payment_method IN (''Check'', ''Direct Deposit'', ''Payment to 3rd Party'')),
            payment_status VARCHAR2(20) CONSTRAINT payment_status_check CHECK (payment_status IN (''Partial'', ''Completed'', ''Failed'')),
            CONSTRAINT payment_claim_id_fk FOREIGN KEY (claim_id) REFERENCES CLAIM(claim_id) ON DELETE CASCADE
        )';
        dbms_output.put_line('Table PAYMENT Created');
       
    exception 
        when others then
            dbms_output.put_line('Exception occured while creating PAYMENT table: '||sqlerrm);
        
    end;
    
    -- CLAIM_LOG Table
    BEGIN
        table_exists := 0;
        SELECT COUNT(*)
        INTO table_exists
        FROM user_tables
        WHERE UPPER(table_name) = 'CLAIM_LOG';

        IF (table_exists = 1) THEN
            EXECUTE IMMEDIATE 'DROP TABLE CLAIM_LOG CASCADE CONSTRAINTS';
            DBMS_OUTPUT.PUT_LINE('Table CLAIM_LOG dropped');
        END IF;

        EXECUTE IMMEDIATE 'CREATE TABLE CLAIM_LOG (
            log_id INTEGER PRIMARY KEY,
            claim_id INTEGER CONSTRAINT claim_log_claim_id_nn NOT NULL,
            old_status VARCHAR2(20),
            new_status VARCHAR2(20),
            change_date DATE DEFAULT SYSDATE,
            CONSTRAINT claim_log_claim_fk FOREIGN KEY (claim_id) REFERENCES CLAIM(claim_id) ON DELETE CASCADE
        )';
        DBMS_OUTPUT.PUT_LINE('Table CLAIM_LOG created successfully.');

        -- Drop and create CLAIM_LOG_SEQ sequence
        BEGIN
            EXECUTE IMMEDIATE 'DROP SEQUENCE CLAIM_LOG_SEQ';
            DBMS_OUTPUT.PUT_LINE('Sequence CLAIM_LOG_SEQ dropped');
        EXCEPTION
            WHEN OTHERS THEN
                IF SQLCODE != -2289 THEN -- Ignore "Sequence does not exist" error
                    RAISE;
                END IF;
        END;

        EXECUTE IMMEDIATE 'CREATE SEQUENCE CLAIM_LOG_SEQ START WITH 1 INCREMENT BY 1 NOCACHE';
        DBMS_OUTPUT.PUT_LINE('Sequence CLAIM_LOG_SEQ created successfully.');

        -- Drop and create BEFORE UPDATE trigger for CLAIM table to populate CLAIM_LOG
        BEGIN
            EXECUTE IMMEDIATE 'DROP TRIGGER CLAIM_STATUS_UPDATE_TRIGGER';
            DBMS_OUTPUT.PUT_LINE('Trigger CLAIM_STATUS_UPDATE_TRIGGER dropped');
        EXCEPTION
            WHEN OTHERS THEN
                IF SQLCODE != -4080 THEN -- Ignore "Trigger does not exist" error
                    RAISE;
                END IF;
        END;

        EXECUTE IMMEDIATE '
            CREATE OR REPLACE TRIGGER CLAIM_STATUS_UPDATE_TRIGGER
            BEFORE UPDATE OF claim_status ON CLAIM
            FOR EACH ROW
            BEGIN
                -- Insert a log entry for the status update
                INSERT INTO CLAIM_LOG (log_id, claim_id, old_status, new_status, change_date)
                VALUES (
                    CLAIM_LOG_SEQ.NEXTVAL,
                    :OLD.claim_id,
                    :OLD.claim_status,
                    :NEW.claim_status,
                    SYSDATE
                );
            END;
        ';
        DBMS_OUTPUT.PUT_LINE('Trigger CLAIM_STATUS_UPDATE_TRIGGER created successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Exception occurred while creating CLAIM_LOG table or associated objects: ' || SQLERRM);
    END;
EXCEPTION 
    WHEN OTHERS THEN
        dbms_output.put_line('Exception occured while creating tables');    
END;
/
commit;