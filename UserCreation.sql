set serveroutput on;

declare
user_exists integer;

begin
    -- creating user ICPS_ADMIN
    begin
        user_exists := 0;
        
        select count(*) 
        into user_exists
        from all_users
        where upper(username) = 'ICPS_ADMIN';
    
        if(user_exists = 1) then
            execute immediate 'drop user ICPS_ADMIN cascade';
            dbms_output.put_line('User ICPS_ADMIN dropped'); 
        end if;
        
        execute immediate 'create user ICPS_ADMIN identified by IcpsAdminProject2024#';
        dbms_output.put_line('User ICPS_ADMIN created');
        execute immediate 'grant ALTER SESSION, CONNECT, RESOURCE, UNLIMITED TABLESPACE to ICPS_ADMIN';
        dbms_output.put_line('ALTER SESSION, CONNECT, RESOURCE, UNLIMITED TABLESPACE granted to ICPS_ADMIN');
    exception 
    when others then
        dbms_output.put_line('Exception occured while creating ICPS_ADMIN');
    end;
    
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
        execute immediate 'grant CREATE SESSION, ALTER SESSION to PROVIDER';
        dbms_output.put_line('CREATE SESSION, ALTER SESSION granted to PROVIDER');
    exception 
    when others then
        dbms_output.put_line('Exception occured while creating PROVIDER');
    end;
    
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
        execute immediate 'grant CREATE SESSION, ALTER SESSION to POLICY_HOLDER';
        dbms_output.put_line('CREATE SESSION, ALTER SESSION granted to POLICY_HOLDER');
    exception 
    when others then
        dbms_output.put_line('Exception occured while creating POLICY_HOLDER');
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
        execute immediate 'grant CREATE SESSION, ALTER SESSION to MANAGER';
        dbms_output.put_line('CREATE SESSION, ALTER SESSION granted to MANAGER');
    exception 
    when others then
        dbms_output.put_line('Exception occured while creating MANAGER');
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
        execute immediate 'grant CREATE SESSION, ALTER SESSION to ADJUSTER';
        dbms_output.put_line('CREATE SESSION, ALTER SESSION granted to ADJUSTER');
    exception 
    when others then
        dbms_output.put_line('Exception occured while creating ADJUSTER');
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
        execute immediate 'grant CREATE SESSION, ALTER SESSION to SALESMAN';
        dbms_output.put_line('CREATE SESSION, ALTER SESSION granted to SALESMAN');
    exception 
    when others then
        dbms_output.put_line('Exception occured while creating SALESMAN');
    end;
      
exception 
    when others then
        dbms_output.put_line('Exception occured while creating users');
end;
