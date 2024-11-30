SET SERVEROUTPUT ON;

DECLARE
user_exists integer;

BEGIN
    -- creating user PROVIDER
    begin
        user_exists := 0;
        
        select count(*) 
        into user_exists
        from all_users
        where upper(username) = 'PROVIDER';
    
        if(user_exists = 1) then
            execute immediate 'drop user PROVIDER cascade';
            dbms_output.put_line('User PROVIDER dropped'); 
        end if;
        
        execute immediate 'create user PROVIDER identified by IcpsProProject2024#';
        dbms_output.put_line('User PROVIDER created');
        execute immediate 'grant CONNECT, ALTER SESSION to PROVIDER';
        dbms_output.put_line('CONNECT, ALTER SESSION granted to PROVIDER');
    exception 
    when others then
        dbms_output.put_line('Exception occured while creating PROVIDER: '||sqlerrm);
    end;
    
    -- creating user ICPS_CORE
    BEGIN
        SELECT COUNT(*)
        INTO user_exists
        FROM all_users
        WHERE UPPER(username) = 'ICPS_CORE';

        -- Drop the user if it exists
        IF user_exists = 1 THEN
            EXECUTE IMMEDIATE 'DROP USER ICPS_CORE CASCADE';
            DBMS_OUTPUT.PUT_LINE('User ICPS_CORE dropped');
        END IF;

        -- Create the user
        EXECUTE IMMEDIATE 'CREATE USER ICPS_CORE IDENTIFIED BY IcpsCoreProject2024#';
        DBMS_OUTPUT.PUT_LINE('User ICPS_CORE created');

        -- Grant basic privileges to the user
        EXECUTE IMMEDIATE 'GRANT CONNECT, RESOURCE, ALTER SESSION, CREATE VIEW, UNLIMITED TABLESPACE TO ICPS_CORE';
        DBMS_OUTPUT.PUT_LINE('Basic privileges granted to ICPS_CORE');

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Exception occurred while creating ICPS_CORE: ' || SQLERRM);
            RAISE; -- Re-raise exception to halt execution
    END;

    
    -- creating user POLICY_HOLDER
    begin
        user_exists := 0;
        
        select count(*) 
        into user_exists
        from all_users
        where upper(username) = 'POLICY_HOLDER';
    
        if(user_exists = 1) then
            execute immediate 'drop user POLICY_HOLDER cascade';
            dbms_output.put_line('User POLICY_HOLDER dropped'); 
        end if;
        
        execute immediate 'create user POLICY_HOLDER identified by PolicyHolderProject2024#';
        dbms_output.put_line('User POLICY_HOLDER created');
        execute immediate 'grant CONNECT, ALTER SESSION to POLICY_HOLDER';
        dbms_output.put_line('CONNECT, ALTER SESSION granted to POLICY_HOLDER');
    exception 
    when others then
        dbms_output.put_line('Exception occured while creating POLICY_HOLDER: '||sqlerrm);
    end;
    
    -- creating user MANAGER
    begin
        user_exists := 0;
        
        select count(*) 
        into user_exists
        from all_users
        where upper(username) = 'MANAGER';
    
        if(user_exists = 1) then
            execute immediate 'drop user MANAGER cascade';
            dbms_output.put_line('User MANAGER dropped'); 
        end if;
        
        execute immediate 'create user MANAGER identified by IcpsManProject2024#';
        dbms_output.put_line('User MANAGER created');
        execute immediate 'grant CONNECT, ALTER SESSION to MANAGER';
        dbms_output.put_line('CONNECT, ALTER SESSION granted to MANAGER');
    exception 
    when others then
        dbms_output.put_line('Exception occured while creating MANAGER: '||sqlerrm);
    end;
    
    -- creating user ADJUSTER
    begin
        user_exists := 0;
        
        select count(*) 
        into user_exists
        from all_users
        where upper(username) = 'ADJUSTER';
    
        if(user_exists = 1) then
            execute immediate 'drop user ADJUSTER cascade';
            dbms_output.put_line('User ADJUSTER dropped'); 
        end if;
        
        execute immediate 'create user ADJUSTER identified by IcpsAdjProject2024#';
        dbms_output.put_line('User ADJUSTER created');
        execute immediate 'grant CONNECT, ALTER SESSION to ADJUSTER';
        dbms_output.put_line('CONNECT, ALTER SESSION granted to ADJUSTER');
    exception 
    when others then
        dbms_output.put_line('Exception occured while creating ADJUSTER: '||sqlerrm);
    end;
    
    -- creating user SALESMAN
    begin
        user_exists := 0;
        
        select count(*) 
        into user_exists
        from all_users
        where upper(username) = 'SALESMAN';
    
        if(user_exists = 1) then
            execute immediate 'drop user SALESMAN cascade';
            dbms_output.put_line('User SALESMAN dropped'); 
        end if;
        
        execute immediate 'create user SALESMAN identified by IcpsSalesProject2024#';
        dbms_output.put_line('User SALESMAN created');
        execute immediate 'grant CONNECT, ALTER SESSION to SALESMAN';
        dbms_output.put_line('CONNECT, ALTER SESSION granted to SALESMAN');
    exception 
    when others then
        dbms_output.put_line('Exception occured while creating SALESMAN: '||sqlerrm);
    end;
      
EXCEPTION 
    WHEN OTHERS THEN
        dbms_output.put_line('Exception occured while creating users: '||sqlerrm);
END;
