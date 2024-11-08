SET SERVEROUTPUT ON;

DECLARE
user_exists integer;

BEGIN
    -- creating user ICPS_ADMIN
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
        execute immediate 'grant ALTER SESSION, CONNECT, RESOURCE, CREATE VIEW, UNLIMITED TABLESPACE to ICPS_ADMIN with ADMIN OPTION';
        dbms_output.put_line('ALTER SESSION, CONNECT, RESOURCE, CREATE VIEW, UNLIMITED TABLESPACE granted to ICPS_ADMIN with ADMIN OPTION');
        execute immediate 'grant CREATE USER, ALTER USER, DROP USER to ICPS_ADMIN';
        dbms_output.put_line('CREATE USER, ALTER USER, DROP USER granted to ICPS_ADMIN');
        execute immediate 'grant CREATE ROLE, ALTER ANY ROLE, DROP ANY ROLE to ICPS_ADMIN';
        dbms_output.put_line('CREATE ROLE, ALTER ANY ROLE, DROP ANY ROLE granted to ICPS_ADMIN');
        execute immediate 'grant GRANT ANY ROLE, DROP ANY ROLE to ICPS_ADMIN with ADMIN OPTION';
        dbms_output.put_line('GRANT ANY ROLE, DROP ANY ROLE granted to ICPS_ADMIN with ADMIN OPTION');
EXCEPTION 
WHEN OTHERS THEN
    dbms_output.put_line('Exception occured while creating ICPS_ADMIN: '||sqlerrm);
END;