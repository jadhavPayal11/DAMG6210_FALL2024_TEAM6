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
            VALUES (7, 'Laura', 'Taylor', TO_DATE( '1992-04-30','YYYY-MM-DD'), 'laura.taylor@example.com', '5552223333', 107);
      
            INSERT INTO policyholder (policyholder_id, first_name, last_name, dob, email, contact, address_id)
            VALUES (8, 'Daniel', 'Anderson', TO_DATE( '1986-09-21','YYYY-MM-DD'), 'daniel.anderson@example.com', '5553334444', 108);
      
            INSERT INTO policyholder (policyholder_id, first_name, last_name, dob, email, contact, address_id)
            VALUES (9, 'Jessica', 'Thomas', TO_DATE( '1993-11-05','YYYY-MM-DD'), 'jessica.thomas@example.com', '5554445555', 109);
      
            INSERT INTO policyholder (policyholder_id, first_name, last_name, dob, email, contact, address_id)
            VALUES (10, 'James', 'Martin', TO_DATE( '1979-06-18','YYYY-MM-DD'), 'james.martin@example.com', '5555556666', 110);
        
        commit;
        dbms_output.put_line('Records inserted into POLICYHOLDER table successfully!');
        
    exception 
        when DUP_VAL_ON_INDEX then
            dbms_output.put_line('Policy holder already exists, check for duplicate policy holder records');
            rollback;
        when e_not_null_violation then
            dbms_output.put_line('Mandatory columns cannot be null');
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
        Insert Into Provider (Provider_Id, Provider_Name, Address_Id, Contact_Number, Email, Provider_Type)
        Values (1, 'HealthFirst Insurance', 201, '5551234567', 'contact@healthfirst.com', 'Health');
        
        Insert Into Provider (Provider_Id, Provider_Name, Address_Id, Contact_Number, Email, Provider_Type)
        Values (2, 'AutoSafe Assurance', 202, '5552345678', 'support@autosafe.com', 'Auto');
        
        Insert Into Provider (Provider_Id, Provider_Name, Address_Id, Contact_Number, Email, Provider_Type)
        Values (3, 'LifeSecure Partners', 203, '5553456789', 'info@lifesecure.com', 'Life');
        
        Insert Into Provider (Provider_Id, Provider_Name, Address_Id, Contact_Number, Email, Provider_Type)
        Values (4, 'HomeShield Insurance', 204, '5554567890', 'contact@homeshield.com', 'Home');
        
        Insert Into Provider (Provider_Id, Provider_Name, Address_Id, Contact_Number, Email, Provider_Type)
        Values (5, 'GeneralGuard', 205, '5555678901', 'service@generalguard.com', 'General');
        
        Commit;
        Dbms_Output.Put_Line('Records inserted into PROVIDER table successfully!');
        
    Exception 
        When Dup_Val_On_Index Then
            Dbms_Output.Put_Line('Provider already exists, check for duplicate provider records');
            Rollback;
        When E_Not_Null_Violation Then
            Dbms_Output.Put_Line('Mandatory columns cannot be null');
            Rollback;
        When E_Fk_Violation Then
            Dbms_Output.Put_Line('Foreign key violation, enter a valid address ID');
            Rollback;
        When Others Then
            Dbms_Output.Put_Line('Exception occurred while inserting data into PROVIDER table: ' || Sqlerrm);
    end;


    
EXCEPTION 
    WHEN OTHERS THEN
        dbms_output.put_line('Exception occured while inserting records into tables');    
END;
