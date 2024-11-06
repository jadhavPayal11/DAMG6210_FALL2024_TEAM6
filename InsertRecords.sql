SET SERVEROUTPUT ON;

DECLARE
    row_count integer;
    e_check_addr_type_violation EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_check_addr_type_violation, -02290);
    e_not_null_violation EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_not_null_violation, -01400);

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
        Values (101, '123 Main St', 'Apt 4B', 'POLICYHOLDER', 'New York', 'New York', 10001, 'USA');
        
        Insert Into Address (address_id, address_line_1, address_line_2, address_type, city, state, zipcode, country)
        Values (102, '122 Main St', 'Apt 4B', 'POLICYHOLDER', 'New York', 'New York', 10001, 'USA');
        
        Insert Into Address (address_id, address_line_1, address_line_2, address_type, city, state, zipcode, country)
        Values (103, '456 Elm St', 'Suite 5', 'PROVIDER', 'Los Angeles', 'California', 90001, 'USA');
        
        Insert Into Address (address_id, address_line_1, address_line_2, address_type, city, state, zipcode, country)
        Values (104, '789 Maple Ave', Null, 'POLICYHOLDER', 'Chicago', 'Illinois', 60601, 'USA');
        
        Insert Into Address (address_id, address_line_1, address_line_2, address_type, city, state, zipcode, country)
        Values (105, '101 Oak Rd', 'Building 3', 'PROVIDER', 'Houston', 'Texas', 77001, 'USA');
        
        Insert Into Address (address_id, address_line_1, address_line_2, address_type, city, state, zipcode, country)
        Values (106, '202 Pine St', Null, Null, 'Phoenix', 'Arizona', 85001, 'USA');
        
        commit;
        dbms_output.put_line('Records inserted into ADDRESS table successfully!');
          
    exception 
        when DUP_VAL_ON_INDEX then
            dbms_output.put_line('Address already exists, check for duplicate address records');
            rollback;
        when e_check_addr_type_violation then
            dbms_output.put_line('Invalid Address type. Address type should be PROVIDER or POLICYHOLDER');
            rollback;
        when e_not_null_violation then
            dbms_output.put_line('Address line 1, city, state, zipcode, country cannot be null');
            rollback;
        when others then
            dbms_output.put_line('Exception occured while inserting data into ADDRESS table: '||sqlerrm);
            rollback;
    end;
    
    -- Insert sample data into the INSURANCE_TYPE table
    begin
       if (select count(*) from insurance_type) = 0 then
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
       end if;
       
       exception 
        when others then
            dbms_output.put_line('Exception occured while inserting data into INSURANCE_TYPE table: '||sqlerrm);
        
    end;
    
    -- Insert sample data into the POLICYHOLDER table
    
    
EXCEPTION 
    WHEN OTHERS THEN
        dbms_output.put_line('Exception occured while inserting records into tables');    
END;
