set serveroutput on;

declare
table_exists integer;

BEGIN
    --Address table
    begin
        table_exists:=0;
        select count(*)
        into table_exists
        from user_tables
        where upper(table_name) = 'ADDRESS';
        
        if(table_exists = 1)then
            execute immediate 'drop table address cascade constraints';
            dbms_output.put_line('Table Address dropped'); 
         end if;
         execute immediate 'CREATE TABLE ADDRESS (
         address_id INT PRIMARY KEY,
         address_line_1 VARCHAR(255),
         address_line_2 VARCHAR(255),
         address_type VARCHAR(50),
         city VARCHAR(100),
         state VARCHAR(100),
         zipcode INT,
         country VARCHAR(100))';
         dbms_output.put_line('Table ADDRESS Created');
       
    exception 
        when others then
            dbms_output.put_line('Exception occured while creating ADDRESS table: '||sqlerrm);
        
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
            insurance_type_id INT PRIMARY KEY,
            insurance_type_name VARCHAR(255),
            description VARCHAR(255)
        )';
        dbms_output.put_line('Table INSURANCE_TYPE Created');
       
    exception 
        when others then
            dbms_output.put_line('Exception occured while creating INSURANCE_TYPE table: '||sqlerrm);
        
    end;
    
    -- Table POLICYHOLDER
    begin
        table_exists :=0;
        select count(*)
        into table_exists
        from user_tables
        where upper(table_name) = 'POLICYHOLDER';
        
        if(table_exists = 1)then
            execute immediate 'drop table POLICYHOLDER cascade constraints';
            dbms_output.put_line('Table POLICYHOLDER dropped'); 
         end if;
         execute immediate 'CREATE TABLE POLICYHOLDER (
            policyholder_id INT PRIMARY KEY,
            first_name VARCHAR(100),
            last_name VARCHAR(100),
            dob DATE,
            email VARCHAR(255),
            contact VARCHAR(20),
            address_id INT,
            FOREIGN KEY (address_id) REFERENCES ADDRESS(address_id)
        )';
         dbms_output.put_line('Table POLICYHOLDER Created');
       
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
            provider_id INT PRIMARY KEY,
            provider_name VARCHAR(255),
            email VARCHAR(255),
            contact VARCHAR(20),
            address_id INT,
            FOREIGN KEY (address_id) REFERENCES ADDRESS(address_id)
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
            agent_id INT PRIMARY KEY,
            provider_id INT,
            first_name VARCHAR(100),
            last_name VARCHAR(100),
            designation VARCHAR(100),
            manager_id INT,
            email VARCHAR(255),
            contact VARCHAR(20),
            FOREIGN KEY (provider_id) REFERENCES PROVIDER(provider_id),
            FOREIGN KEY (manager_id) REFERENCES AGENT(agent_id)
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
            application_id INT PRIMARY KEY,
            policyholder_id INT,
            insurance_type_id INT,
            application_date DATE,
            status VARCHAR(50),
            review_date DATE,
            agent_id INT,
            comments VARCHAR(255),
            FOREIGN KEY (policyholder_id) REFERENCES POLICYHOLDER(policyholder_id),
            FOREIGN KEY (insurance_type_id) REFERENCES INSURANCE_TYPE(insurance_type_id),
            FOREIGN KEY (agent_id) REFERENCES AGENT(agent_id)
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
            policy_id INT PRIMARY KEY,
            application_id INT,
            policyholder_id INT,
            provider_id INT,
            insurance_type_id INT,
            policy_type VARCHAR(100),
            start_date DATE,
            end_date DATE,
            premium_amount NUMBER,
            coverage_amount NUMBER,
            policy_status VARCHAR(50),
            FOREIGN KEY (application_id) REFERENCES INSURANCE_APPLICATION(application_id),
            FOREIGN KEY (policyholder_id) REFERENCES POLICYHOLDER(policyholder_id),
            FOREIGN KEY (provider_id) REFERENCES PROVIDER(provider_id),
            FOREIGN KEY (insurance_type_id) REFERENCES INSURANCE_TYPE(insurance_type_id)
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
            claim_id INT PRIMARY KEY,
            policy_id INT,
            agent_id INT,
            claim_date DATE,
            claim_type VARCHAR(100),
            claim_description VARCHAR(255),
            amount NUMBER,
            claim_status VARCHAR(50),
            claim_priority VARCHAR(50),
            estimated_settlement_date DATE,
            FOREIGN KEY (policy_id) REFERENCES POLICY(policy_id),
            FOREIGN KEY (agent_id) REFERENCES AGENT(agent_id)
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
            payment_id INT PRIMARY KEY,
            claim_id INT,
            payment_date DATE,
            payment_amount INT,
            payment_method VARCHAR(50),
            payment_status VARCHAR(50),
            FOREIGN KEY (claim_id) REFERENCES CLAIM(claim_id)
        )';
        dbms_output.put_line('Table PAYMENT Created');
       
    exception 
        when others then
            dbms_output.put_line('Exception occured while creating PAYMENT table: '||sqlerrm);
        
    end;
    
END;

select * from user_tables;