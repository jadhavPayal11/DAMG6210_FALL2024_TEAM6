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
            execute immediate 'drop table address cascade constraints';
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

END;