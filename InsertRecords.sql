SET SERVEROUTPUT ON;

DECLARE
    row_count integer;
    e_check_violation EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_check_violation, -02290);
    e_not_null_violation EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_not_null_violation, -01400);
    e_fk_violation EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_fk_violation, -02291);

BEGIN

    -- Insert data into the ADDRESS table
    Begin
        row_count := 0;
        
        select count(*) 
        into row_count
        from ADDRESS;
    
        if (row_count > 0) then
            delete from ADDRESS;
            commit;
            dbms_output.put_line('All records deleted from ADDRESS table');
        end if;
        
        Insert Into Address (address_id, address_line_1, address_line_2, address_type, city, state, zipcode, country)
        Values (101, '123 Main St', 'Apt 4B', 'RESIDENTIAL', 'New York', 'New York', 10001, 'USA');
        
        Insert Into Address (address_id, address_line_1, address_line_2, address_type, city, state, zipcode, country)
        Values (102, '122 Main St', 'Apt 4B', 'RESIDENTIAL', 'New York', 'New York', 10001, 'USA');
        
        Insert Into Address (address_id, address_line_1, address_line_2, address_type, city, state, zipcode, country)
        Values (103, '456 Elm St', 'Suite 5', 'COMMERCIAL', 'Los Angeles', 'California', 90001, 'USA');
        
        Insert Into Address (address_id, address_line_1, address_line_2, address_type, city, state, zipcode, country)
        Values (104, '789 Maple Ave', Null, 'RESIDENTIAL', 'Chicago', 'Illinois', 60601, 'USA');
        
        Insert Into Address (address_id, address_line_1, address_line_2, address_type, city, state, zipcode, country)
        Values (105, '101 Oak Rd', 'Building 3', 'COMMERCIAL', 'Houston', 'Texas', 77001, 'USA');
        
        Insert Into Address (address_id, address_line_1, address_line_2, address_type, city, state, zipcode, country)
        Values (106, '202 Pine St', Null, Null, 'Phoenix', 'Arizona', 85001, 'USA');
        
        commit;
        dbms_output.put_line('Records inserted into ADDRESS table successfully!');    
    exception 
        when DUP_VAL_ON_INDEX then
            dbms_output.put_line('Address already exists, check for duplicate address records');
            rollback;
        when e_check_violation then
            dbms_output.put_line('Invalid Address type. Address type should be RESIDENTIAL or COMMERCIAL');
            rollback;
        when e_not_null_violation then
            dbms_output.put_line('Address line 1, city, state, zipcode, country cannot be null');
            rollback;
        when others then
            dbms_output.put_line('Exception occured while inserting data into ADDRESS table: '||sqlerrm);
            rollback;
    end;
    
    -- Insert data into the INSURANCE_TYPE table
    begin
        row_count := 0;
            
            select count(*) 
            into row_count
            from INSURANCE_TYPE;
        
            if (row_count > 0) then
                delete from INSURANCE_TYPE;
                commit;
                dbms_output.put_line('All records deleted from INSURANCE_TYPE table');
            end if;
       
          insert into insurance_type (insurance_type_id, insurance_type_name, description)
          values (1, 'Health Insurance', 'Covers medical expenses for individuals and families.');
          
          insert into insurance_type (insurance_type_id, insurance_type_name, description)
          values (2, 'Auto Insurance', 'Provides coverage for vehicle damage and liability.');
          
          insert into insurance_type (insurance_type_id, insurance_type_name, description)
          values (3, 'Life Insurance', 'Offers financial support to beneficiaries after death.');
          
          insert into insurance_type (insurance_type_id, insurance_type_name, description)
          values (4, 'Home Insurance', 'Covers damages to home and personal property.');
          
          insert into insurance_type (insurance_type_id, insurance_type_name, description)
          values (5, 'Travel Insurance', 'Covers travel-related risks, including health and property.');
          
        commit;
        dbms_output.put_line('Records inserted into INSURANCE_TYPE table successfully!');
       
    exception 
        when DUP_VAL_ON_INDEX then
            dbms_output.put_line('insurance_type already exists, check for duplicate insurance_type records');
            rollback;
        when e_not_null_violation then
            dbms_output.put_line('insurance_type_name cannot be null');
            rollback;
        when others then
            dbms_output.put_line('Exception occured while inserting data into INSURANCE_TYPE table: '||sqlerrm);
            rollback;
    end;
    
    -- Insert data into the POLICYHOLDER table
    begin
        row_count := 0;
        
        select count(*) 
        into row_count
        from POLICYHOLDER;
        
        if (row_count > 0) then
            delete from POLICYHOLDER;
            commit;
            dbms_output.put_line('All records deleted from POLICYHOLDER table');
        end if;
        
            INSERT INTO policyholder (policyholder_id, first_name, last_name, dob, email, contact, address_id)
            VALUES (1, 'John', 'Doe', TO_DATE('1985-08-15','YYYY-MM-DD'), 'john.doe@example.com', '1234567890', 101);
          
            INSERT INTO policyholder (policyholder_id, first_name, last_name, dob, email, contact, address_id)
            VALUES (2, 'Jane', 'Smith', TO_DATE( '1990-05-23','YYYY-MM-DD'), 'jane.smith@example.com', '0987654321', 102);
          
            INSERT INTO policyholder (policyholder_id, first_name, last_name, dob, email, contact, address_id)
            VALUES (3, 'Robert', 'Johnson', TO_DATE( '1975-12-12','YYYY-MM-DD'), 'robert.j@example.com', '1122334455', 103);
          
            INSERT INTO policyholder (policyholder_id, first_name, last_name, dob, email, contact, address_id)
            VALUES (4, 'Alice', 'Brown', TO_DATE( '1983-03-05','YYYY-MM-DD'), 'alice.brown@example.com', '2233445566', 104);
          
            INSERT INTO policyholder (policyholder_id, first_name, last_name, dob, email, contact, address_id)
            VALUES (5, 'Emily', 'Clark', TO_DATE( '1995-07-10','YYYY-MM-DD'), 'emily.clark@example.com', '3344556677', 105);
            
            INSERT INTO policyholder (policyholder_id, first_name, last_name, dob, email, contact, address_id)
            VALUES (6, 'Michael', 'Williams', TO_DATE( '1988-11-12','YYYY-MM-DD'), 'michael.williams@example.com', '5551112222', 106);
      
            INSERT INTO policyholder (policyholder_id, first_name, last_name, dob, email, contact, address_id)
            VALUES (7, 'Laura', 'Taylor', TO_DATE( '1992-04-30','YYYY-MM-DD'), 'laura.taylor@example.com', '5552223333', 101);
      
            INSERT INTO policyholder (policyholder_id, first_name, last_name, dob, email, contact, address_id)
            VALUES (8, 'Daniel', 'Anderson', TO_DATE( '1986-09-21','YYYY-MM-DD'), 'daniel.anderson@example.com', '5553334444', 102);
      
            INSERT INTO policyholder (policyholder_id, first_name, last_name, dob, email, contact, address_id)
            VALUES (9, 'Jessica', 'Thomas', TO_DATE( '1993-11-05','YYYY-MM-DD'), 'jessica.thomas@example.com', '5554445555', 104);
      
            INSERT INTO policyholder (policyholder_id, first_name, last_name, dob, email, contact, address_id)
            VALUES (10, 'James', 'Martin', TO_DATE( '1979-06-18','YYYY-MM-DD'), 'james.martin@example.com', '5555556666', 104);
        
        commit;
        dbms_output.put_line('Records inserted into POLICYHOLDER table successfully!');
        
    exception 
        when DUP_VAL_ON_INDEX then
            dbms_output.put_line('Policy holder already exists, check for duplicate policy holder records');
            rollback;
        when e_not_null_violation then
            dbms_output.put_line('Mandatory columns cannot be null in POLICYHOLDER table');
            rollback;
        when e_fk_violation then
            dbms_output.put_line('Foreign key violation, enter a valid address id');
            rollback;
        when others then
            dbms_output.put_line('Exception occured while inserting data into POLICYHOLDER table: '||sqlerrm);
    end;
    
    -- Insert data into the PROVIDER table
    Begin
        -- Check if records exist in the PROVIDER table
        Row_Count := 0;
        
        Select Count(*) 
        Into Row_Count
        From PROVIDER;
        
        -- If records exist, delete them
        If (Row_Count > 0) Then
            Delete From PROVIDER;
            Commit;
            Dbms_Output.Put_Line('All records deleted from PROVIDER table');
        End If;
        
        -- Insert sample data into the PROVIDER table
        Insert Into Provider (Provider_Id, Provider_Name, Address_Id, Contact, Email)
        Values (1, 'HealthFirst Insurance', 103, '5551234567', 'contact@healthfirst.com');
        
        Insert Into Provider (Provider_Id, Provider_Name, Address_Id, Contact, Email)
        Values (2, 'AutoSafe Assurance', 105, '5552345678', 'support@autosafe.com');
        
        Insert Into Provider (Provider_Id, Provider_Name, Address_Id, Contact, Email)
        Values (3, 'LifeSecure Partners', 103, '5553456789', 'info@lifesecure.com');
        
        Insert Into Provider (Provider_Id, Provider_Name, Address_Id, Contact, Email)
        Values (4, 'HomeShield Insurance', 105, '5554567890', 'contact@homeshield.com');
        
        Insert Into Provider (Provider_Id, Provider_Name, Address_Id, Contact, Email)
        Values (5, 'GeneralGuard', 103, '5555678901', 'service@generalguard.com');
        
        Commit;
        Dbms_Output.Put_Line('Records inserted into PROVIDER table successfully!');
        
    Exception 
        When Dup_Val_On_Index Then
            Dbms_Output.Put_Line('Provider already exists, check for duplicate provider records');
            Rollback;
        When E_Not_Null_Violation Then
            Dbms_Output.Put_Line('Mandatory columns cannot be null PROVIDER table');
            Rollback;
        When E_Fk_Violation Then
            Dbms_Output.Put_Line('Foreign key violation, enter a valid address ID');
            Rollback;
        When Others Then
            Dbms_Output.Put_Line('Exception occurred while inserting data into PROVIDER table: ' || Sqlerrm);
    end;

    -- Insert data into the AGENT table
    Begin
        -- Check if records exist in the AGENT table
        Row_Count := 0;
        
        Select Count(*) 
        Into Row_Count
        From Agent;
        
        -- If records exist, delete them
        If (Row_Count > 0) Then
            Delete From Agent;
            Commit;
            Dbms_Output.Put_Line('All records deleted from AGENT table');
        End If;
        
        -- Insert sample data into the AGENT table
        Insert Into Agent (Agent_Id, Provider_Id, First_Name, Last_Name, Designation, Manager_Id, Email, Contact)
        Values (1, 1, 'Sarah', 'Miller', 'Manager', Null, 'sarah.miller@example.com', '5551002000');
        
        Insert Into Agent (Agent_Id, Provider_Id, First_Name, Last_Name, Designation, Manager_Id, Email, Contact)
        Values (2, 1, 'David', 'Johnson', 'Adjuster', 1, 'david.johnson@example.com', '5551003000');
        
        Insert Into Agent (Agent_Id, Provider_Id, First_Name, Last_Name, Designation, Manager_Id, Email, Contact)
        Values (3, 2, 'Emily', 'Davis', 'Salesman', 1, 'emily.davis@example.com', '5551004000');
        
        Insert Into Agent (Agent_Id, Provider_Id, First_Name, Last_Name, Designation, Manager_Id, Email, Contact)
        Values (4, 3, 'James', 'Brown', 'Manager', Null, 'james.brown@example.com', '5551005000');
        
        Insert Into Agent (Agent_Id, Provider_Id, First_Name, Last_Name, Designation, Manager_Id, Email, Contact)
        Values (5, 2, 'Olivia', 'Wilson', 'Adjuster', 4, 'olivia.wilson@example.com', '5551006000');
        
        Commit;
        Dbms_Output.Put_Line('Records inserted into AGENT table successfully!');
        
    Exception 
        When Dup_Val_On_Index Then
            Dbms_Output.Put_Line('Agent already exists, check for duplicate agent records');
            Rollback;
        When E_Not_Null_Violation Then
            Dbms_Output.Put_Line('Mandatory columns cannot be null in AGENT table');
            Rollback;
        When E_Fk_Violation Then
            Dbms_Output.Put_Line('Foreign key violation, enter valid provider or manager ID');
            Rollback;
        When Others Then
            Dbms_Output.Put_Line('Exception occurred while inserting data into AGENT table: ' || Sqlerrm);
    End;
    
    -- Insert data into the INSURANCE_APPLICATION table
    begin
    -- Check if records exist in the INSURANCE_APPLICATION table
        ROW_COUNT := 0;
        
        select count(*) 
        into ROW_COUNT
        from INSURANCE_APPLICATION;
        
        -- If records exist, delete them
        if (ROW_COUNT > 0) then
            delete from INSURANCE_APPLICATION;
            commit;
            DBMS_OUTPUT.PUT_LINE('All records deleted from INSURANCE_APPLICATION table');
        end if;
        
        -- Insert sample data into the INSURANCE_APPLICATION table
        insert into INSURANCE_APPLICATION (APPLICATION_ID, POLICYHOLDER_ID, INSURANCE_TYPE_ID, APPLICATION_DATE, STATUS, REVIEW_DATE, AGENT_ID, COMMENTS)
        values (1, 1, 1, to_date('2023-01-15', 'YYYY-MM-DD'), 'Pending', to_date('2023-01-20', 'YYYY-MM-DD'), 1, 'Initial application pending review');
        
        insert into INSURANCE_APPLICATION (APPLICATION_ID, POLICYHOLDER_ID, INSURANCE_TYPE_ID, APPLICATION_DATE, STATUS, REVIEW_DATE, AGENT_ID, COMMENTS)
        values (2, 2, 2, to_date('2023-02-10', 'YYYY-MM-DD'), 'Approved', to_date('2023-02-15', 'YYYY-MM-DD'), 2, 'Approved after verification');
        
        insert into INSURANCE_APPLICATION (APPLICATION_ID, POLICYHOLDER_ID, INSURANCE_TYPE_ID, APPLICATION_DATE, STATUS, REVIEW_DATE, AGENT_ID, COMMENTS)
        values (3, 3, 3, to_date('2023-03-05', 'YYYY-MM-DD'), 'Rejected', to_date('2023-03-10', 'YYYY-MM-DD'), 3, 'Rejected due to incomplete documentation');
        
        insert into INSURANCE_APPLICATION (APPLICATION_ID, POLICYHOLDER_ID, INSURANCE_TYPE_ID, APPLICATION_DATE, STATUS, REVIEW_DATE, AGENT_ID, COMMENTS)
        values (4, 4, 4, to_date('2023-04-12', 'YYYY-MM-DD'), 'Pending', to_date('2023-04-30', 'YYYY-MM-DD'), 4, 'Application under review');
        
        insert into INSURANCE_APPLICATION (APPLICATION_ID, POLICYHOLDER_ID, INSURANCE_TYPE_ID, APPLICATION_DATE, STATUS, REVIEW_DATE, AGENT_ID, COMMENTS)
        values (5, 5, 5, to_date('2023-05-20', 'YYYY-MM-DD'), 'Approved', to_date('2023-05-25', 'YYYY-MM-DD'), 5, 'Approved and policy issued');
        
        commit;
        DBMS_OUTPUT.PUT_LINE('Records inserted into INSURANCE_APPLICATION table successfully!');
        
    exception 
        when DUP_VAL_ON_INDEX then
            DBMS_OUTPUT.PUT_LINE('Insurance application already exists, check for duplicate application records');
            rollback;
        when E_NOT_NULL_VIOLATION then
            DBMS_OUTPUT.PUT_LINE('Mandatory columns cannot be null in INSURANCE_APPLICATION table');
            rollback;
        when E_FK_VIOLATION then
            DBMS_OUTPUT.PUT_LINE('Foreign key violation, enter valid policyholder, insurance type, or agent ID');
            rollback;
        when others then
            DBMS_OUTPUT.PUT_LINE('Exception occurred while inserting data into INSURANCE_APPLICATION table: ' || SQLERRM);
    end;
    
    -- Insert data into the POLICY table
    begin
        -- Check if records exist in the POLICY table
        ROW_COUNT := 0;
        
        select count(*) 
        into ROW_COUNT
        from policy;
        
        -- If records exist, delete them
        if (ROW_COUNT > 0) then
            delete from policy;
            commit;
            DBMS_OUTPUT.PUT_LINE('All records deleted from POLICY table');
        end if;
        
        -- Insert sample data into the POLICY table
        insert into policy (POLICY_ID, APPLICATION_ID, POLICYHOLDER_ID, PROVIDER_ID, INSURANCE_TYPE_ID, START_DATE, END_DATE, PREMIUM_AMOUNT, COVERAGE_AMOUNT, POLICY_STATUS)
        values (101, 1, 1, 1, 1, to_date('2023-01-15', 'YYYY-MM-DD'), to_date('2024-01-15', 'YYYY-MM-DD'), 1200.00, 10000.00, 'Active');
        
        insert into policy (POLICY_ID, APPLICATION_ID, POLICYHOLDER_ID, PROVIDER_ID, INSURANCE_TYPE_ID, START_DATE, END_DATE, PREMIUM_AMOUNT, COVERAGE_AMOUNT, POLICY_STATUS)
        values (102, 2, 2, 2, 2, to_date('2023-02-10', 'YYYY-MM-DD'), to_date('2024-02-10', 'YYYY-MM-DD'), 900.00, 15000.00, 'Active');
        
        insert into policy (POLICY_ID, APPLICATION_ID, POLICYHOLDER_ID, PROVIDER_ID, INSURANCE_TYPE_ID, START_DATE, END_DATE, PREMIUM_AMOUNT, COVERAGE_AMOUNT, POLICY_STATUS)
        values (103, 3, 3, 3, 3, to_date('2023-03-05', 'YYYY-MM-DD'), to_date('2033-03-05', 'YYYY-MM-DD'), 1500.00, 20000.00, 'Active');
        
        insert into policy (POLICY_ID, APPLICATION_ID, POLICYHOLDER_ID, PROVIDER_ID, INSURANCE_TYPE_ID, START_DATE, END_DATE, PREMIUM_AMOUNT, COVERAGE_AMOUNT, POLICY_STATUS)
        values (104, 4, 4, 4, 4, to_date('2023-04-12', 'YYYY-MM-DD'), to_date('2028-04-12', 'YYYY-MM-DD'), 2000.00, 30000.00, 'Active');
        
        insert into policy (POLICY_ID, APPLICATION_ID, POLICYHOLDER_ID, PROVIDER_ID, INSURANCE_TYPE_ID, START_DATE, END_DATE, PREMIUM_AMOUNT, COVERAGE_AMOUNT, POLICY_STATUS)
        values (105, 5, 5, 5, 5, to_date('2023-05-20', 'YYYY-MM-DD'), null, 500.00, 5000.00, 'Pending');
        
        commit;
        DBMS_OUTPUT.PUT_LINE('Records inserted into POLICY table successfully!');
        
    exception 
        when DUP_VAL_ON_INDEX then
            DBMS_OUTPUT.PUT_LINE('Policy already exists, check for duplicate policy records');
            rollback;
        when E_NOT_NULL_VIOLATION then
            DBMS_OUTPUT.PUT_LINE('Mandatory columns cannot be null in POLICY table ');
            rollback;
        when E_FK_VIOLATION then
            DBMS_OUTPUT.PUT_LINE('Foreign key violation, enter valid application, policyholder, provider, or insurance type ID');
            rollback;
        when others then
            DBMS_OUTPUT.PUT_LINE('Exception occurred while inserting data into POLICY table: ' || SQLERRM);
    end;
    
    -- Insert data into the CLAIM table
    Begin
        -- Check if records exist in the CLAIM table
        Row_Count := 0;
        
        Select Count(*) 
        Into Row_Count
        From Claim;
        
        -- If records exist, delete them
        If (Row_Count > 0) Then
            Delete From Claim;
            Commit;
            Dbms_Output.Put_Line('All records deleted from CLAIM table');
        End If;
        
        -- Insert sample data into the CLAIM table
        Insert Into Claim (Claim_Id, Policy_Id, Agent_Id, Claim_Date, Claim_Type, Claim_Description, Claim_Amount, Claim_Status, Claim_Priority, Estimated_Settlement_Date)
        Values (1, 101, 1, To_Date('2023-06-01', 'YYYY-MM-DD'), 'Accident', 'Minor accident involving rear collision', 2500.00, 'Pending', 'High', To_Date('2023-06-10', 'YYYY-MM-DD'));
        
        Insert Into Claim (Claim_Id, Policy_Id, Agent_Id, Claim_Date, Claim_Type, Claim_Description, Claim_Amount, Claim_Status, Claim_Priority, Estimated_Settlement_Date)
        Values (2, 102, 2, To_Date('2023-06-05', 'YYYY-MM-DD'), 'Theft', 'Stolen vehicle', 15000.00, 'Approved', 'High', To_Date('2023-06-15', 'YYYY-MM-DD'));
        
        Insert Into Claim (Claim_Id, Policy_Id, Agent_Id, Claim_Date, Claim_Type, Claim_Description, Claim_Amount, Claim_Status, Claim_Priority, Estimated_Settlement_Date)
        Values (3, 103, 3, To_Date('2023-06-10', 'YYYY-MM-DD'), 'Fire', 'Fire damage in engine compartment', 5000.00, 'Rejected', 'Medium', Null);
        
        Insert Into Claim (Claim_Id, Policy_Id, Agent_Id, Claim_Date, Claim_Type, Claim_Description, Claim_Amount, Claim_Status, Claim_Priority, Estimated_Settlement_Date)
        Values (4, 104, 4, To_Date('2023-06-12', 'YYYY-MM-DD'), 'Medical', 'Hospitalization after accident', 7000.00, 'Pending', 'High', To_Date('2023-06-20', 'YYYY-MM-DD'));
        
        Insert Into Claim (Claim_Id, Policy_Id, Agent_Id, Claim_Date, Claim_Type, Claim_Description, Claim_Amount, Claim_Status, Claim_Priority, Estimated_Settlement_Date)
        Values (5, 105, 5, To_Date('2023-06-15', 'YYYY-MM-DD'), 'Accident', 'Severe accident with multiple injuries', 20000.00, 'Approved', 'Critical', To_Date('2023-06-25', 'YYYY-MM-DD'));
        
        Commit;
        Dbms_Output.Put_Line('Records inserted into CLAIM table successfully!');
        
    Exception 
        When Dup_Val_On_Index Then
            Dbms_Output.Put_Line('Claim already exists, check for duplicate claim records');
            Rollback;
        When E_Not_Null_Violation Then
            Dbms_Output.Put_Line('Mandatory columns cannot be null in CLAIM table ');
            Rollback;
        When E_Fk_Violation Then
            Dbms_Output.Put_Line('Foreign key violation, enter valid policy or agent ID');
            Rollback;
        When Others Then
            Dbms_Output.Put_Line('Exception occurred while inserting data into CLAIM table: ' || Sqlerrm);
    End;
    
    begin
        -- Check if records exist in the PAYMENT table
        ROW_COUNT := 0;
        
        select count(*) 
        into ROW_COUNT
        from PAYMENT;
        
        -- If records exist, delete them
        if (ROW_COUNT > 0) then
            delete from PAYMENT;
            commit;
            DBMS_OUTPUT.PUT_LINE('All records deleted from PAYMENT table');
        end if;
        
        -- Insert sample data into the PAYMENT table
        insert into PAYMENT (PAYMENT_ID, CLAIM_ID, PAYMENT_DATE, PAYMENT_AMOUNT, PAYMENT_METHOD, PAYMENT_STATUS)
        values (1, 1, to_date('2023-06-15', 'YYYY-MM-DD'), 2500.00, 'Check', 'Completed');
        
        insert into PAYMENT (PAYMENT_ID, CLAIM_ID, PAYMENT_DATE, PAYMENT_AMOUNT, PAYMENT_METHOD, PAYMENT_STATUS)
        values (2, 2, to_date('2023-06-20', 'YYYY-MM-DD'), 15000.00, 'Direct Deposit', 'Completed');
        
        insert into PAYMENT (PAYMENT_ID, CLAIM_ID, PAYMENT_DATE, PAYMENT_AMOUNT, PAYMENT_METHOD, PAYMENT_STATUS)
        values (3, 3, to_date('2023-06-25', 'YYYY-MM-DD'), 5000.00, 'Payment to 3rd Party', 'Partial');
        
        insert into PAYMENT (PAYMENT_ID, CLAIM_ID, PAYMENT_DATE, PAYMENT_AMOUNT, PAYMENT_METHOD, PAYMENT_STATUS)
        values (4, 4, to_date('2023-06-30', 'YYYY-MM-DD'), 7000.00, 'Check', 'Completed');
        
        insert into PAYMENT (PAYMENT_ID, CLAIM_ID, PAYMENT_DATE, PAYMENT_AMOUNT, PAYMENT_METHOD, PAYMENT_STATUS)
        values (5, 5, to_date('2023-07-05', 'YYYY-MM-DD'), 20000.00, 'Direct Deposit', 'Failed');
        
        commit;
        DBMS_OUTPUT.PUT_LINE('Records inserted into PAYMENT table successfully!');
        
    exception 
        when DUP_VAL_ON_INDEX then
            DBMS_OUTPUT.PUT_LINE('Payment already exists, check for duplicate payment records');
            rollback;
        when E_NOT_NULL_VIOLATION then
            DBMS_OUTPUT.PUT_LINE('Mandatory columns cannot be null in PAYMENT table');
            rollback;
        when E_FK_VIOLATION then
            DBMS_OUTPUT.PUT_LINE('Foreign key violation, enter a valid claim ID in PAYMENT table');
            rollback;
        when others then
            DBMS_OUTPUT.PUT_LINE('Exception occurred while inserting data into PAYMENT table: ' || SQLERRM);
    end;

EXCEPTION 
    WHEN OTHERS THEN
        dbms_output.put_line('Exception occured while inserting records into tables');    
END;
