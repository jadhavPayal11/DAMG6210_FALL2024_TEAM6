SET SERVEROUTPUT ON;

DECLARE
table_exists integer;

BEGIN
    --Address table
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
         CONSTRAINT check_addr_type CHECK(address_type IN (''PROVIDER'', ''POLICYHOLDER'')),
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
        table_exists := 0;
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
            insurance_type_name VARCHAR2(30),
            description VARCHAR2(255),
            CONSTRAINT insurance_type_id_pk PRIMARY KEY (insurance_type_id)
        )';
        dbms_output.put_line('Table INSURANCE_TYPE created');
       
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
            first_name VARCHAR2(30),
            last_name VARCHAR2(30),
            dob DATE,
            email VARCHAR2(30),
            contact NUMBER(10),
            address_id INTEGER,
            CONSTRAINT policyholder_id_pk PRIMARY KEY (policyholder_id),
            CONSTRAINT ph_addr_id_fk FOREIGN KEY (address_id) REFERENCES ADDRESS(address_id)
        )';
         dbms_output.put_line('Table POLICYHOLDER created');
       
    exception 
        when others then
            dbms_output.put_line('Exception occured while creating POLICYHOLDER table: '||sqlerrm);
        
    end;
    
    -- Table PROVIDER
    begin
        table_exists := 0;
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
            provider_name VARCHAR2(30),
            email VARCHAR2(30),
            contact NUMBER(10),
            address_id INTEGER,
            FOREIGN KEY (address_id) REFERENCES ADDRESS(address_id)
        )';
        dbms_output.put_line('Table PROVIDER created');
       
    exception 
        when others then
            dbms_output.put_line('Exception occured while creating PROVIDER table: '||sqlerrm);
        
    end;
    
    -- Table AGENT
    begin
        table_exists := 0;
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
            provider_id INTEGER,
            first_name VARCHAR2(30),
            last_name VARCHAR2(30),
            designation VARCHAR2(20),
            manager_id INTEGER,
            email VARCHAR2(30),
            contact NUMBER(10),
            FOREIGN KEY (provider_id) REFERENCES PROVIDER(provider_id),
            FOREIGN KEY (manager_id) REFERENCES AGENT(agent_id)
        )';
        dbms_output.put_line('Table AGENT created');
       
    exception 
        when others then
            dbms_output.put_line('Exception occured while creating AGENT table: '||sqlerrm);
        
    end;
    
    -- Table INSURANCE_APPLICATION
    begin
        table_exists := 0;
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
            insurance_type_id INTEGER,
            application_date DATE,
            status VARCHAR2(20),
            review_date DATE,
            agent_id INTEGER,
            comments VARCHAR2(255),
            FOREIGN KEY (policyholder_id) REFERENCES POLICYHOLDER(policyholder_id),
            FOREIGN KEY (insurance_type_id) REFERENCES INSURANCE_TYPE(insurance_type_id),
            FOREIGN KEY (agent_id) REFERENCES AGENT(agent_id)
        )';
        dbms_output.put_line('Table INSURANCE_APPLICATION created');
       
    exception 
        when others then
            dbms_output.put_line('Exception occured while creating INSURANCE_APPLICATION table: '||sqlerrm);
        
    end;
    
    -- Table POLICY
    begin
        table_exists := 0;
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
            application_id INTEGER,
            policyholder_id INTEGER,
            provider_id INTEGER,
            insurance_type_id INTEGER,
            policy_type VARCHAR2(30),
            start_date DATE,
            end_date DATE,
            premium_amount NUMBER(10,2),
            coverage_amount NUMBER(10,2),
            policy_status VARCHAR2(20),
            FOREIGN KEY (application_id) REFERENCES INSURANCE_APPLICATION(application_id),
            FOREIGN KEY (policyholder_id) REFERENCES POLICYHOLDER(policyholder_id),
            FOREIGN KEY (provider_id) REFERENCES PROVIDER(provider_id),
            FOREIGN KEY (insurance_type_id) REFERENCES INSURANCE_TYPE(insurance_type_id)
        )';
        dbms_output.put_line('Table POLICY created');
       
    exception 
        when others then
            dbms_output.put_line('Exception occured while creating POLICY table: '||sqlerrm);
        
    end;
    
    
    -- Table CLAIM
    begin
        table_exists := 0;
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
            policy_id INTEGER,
            agent_id INTEGER,
            claim_date DATE,
            claim_type VARCHAR2(20),
            claim_description VARCHAR2(255),
            amount NUMBER(10,2),
            claim_status VARCHAR2(20),
            claim_priority VARCHAR2(10),
            estimated_settlement_date DATE,
            FOREIGN KEY (policy_id) REFERENCES POLICY(policy_id),
            FOREIGN KEY (agent_id) REFERENCES AGENT(agent_id)
        )';
        dbms_output.put_line('Table CLAIM created');
       
    exception 
        when others then
            dbms_output.put_line('Exception occured while creating CLAIM table: '||sqlerrm);
        
    end;
    
    
    -- Table PAYMENT
    begin
        table_exists := 0;
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
            claim_id INTEGER,
            payment_date DATE,
            payment_amount INTEGER,
            payment_method VARCHAR2(20),
            payment_status VARCHAR2(20),
            FOREIGN KEY (claim_id) REFERENCES CLAIM(claim_id)
        )';
        dbms_output.put_line('Table PAYMENT created');
       
    exception 
        when others then
            dbms_output.put_line('Exception occured while creating PAYMENT table: '||sqlerrm);
        
    end;
EXCEPTION 
    WHEN OTHERS THEN
        dbms_output.put_line('Exception occured while creating tables');    
END;