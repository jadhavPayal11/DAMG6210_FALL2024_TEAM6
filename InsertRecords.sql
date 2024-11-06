set serveroutput on;

declare
table_exists integer;

BEGIN

    -- Insert data into the ADDRESS table
    Begin
       If (Select Count(*) From Address) = 0 Then
          Insert Into Address (Address_Id, Address_Line_1, Address_Line_2, City, State, Zipcode, Country)
          Values (101, '123 Main St', 'Apt 4B', 'New York', 'New York', 10001, 'USA');
          
          Insert Into Address (Address_Id, Address_Line_1, Address_Line_2, City, State, Zipcode, Country)
          Values (102, '456 Elm St', 'Suite 5', 'Los Angeles', 'California', 90001, 'USA');
          
          Insert Into Address (Address_Id, Address_Line_1, Address_Line_2, City, State, Zipcode, Country)
          Values (103, '789 Maple Ave', Null, 'Chicago', 'Illinois', 60601, 'USA');
          
          Insert Into Address (Address_Id, Address_Line_1, Address_Line_2, City, State, Zipcode, Country)
          Values (104, '101 Oak Rd', 'Building 3', 'Houston', 'Texas', 77001, 'USA');
          
          Insert Into Address (Address_Id, Address_Line_1, Address_Line_2, City, State, Zipcode, Country)
          Values (105, '202 Pine St', Null, 'Phoenix', 'Arizona', 85001, 'USA');
       end if;
    exception 
        when others then
            dbms_output.put_line('Exception occured while inserting data into ADDRESS table: '||sqlerrm);
        
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
END;
