set serveroutput on;

declare
user_exists integer;

begin
    select count(*) 
    into user_exists
    from all_users
    where upper(username) = 'ICPS_ADMIN';

    if(user_exists = 1) then
        execute immediate 'drop user ICPS_ADMIN cascade';
        dbms_output.put_line('User ICPS_ADMIN dropped'); 
    else
        execute immediate 'create user ICPS_ADMIN identified by IcpsAdminProject2024#';
        dbms_output.put_line('User ICPS_ADMIN created');
        execute immediate 'grant ALTER SESSION, CONNECT, RESOURCE, UNLIMITED TABLESPACE to ICPS_ADMIN';
        dbms_output.put_line('ALTER SESSION, CONNECT, RESOURCE, UNLIMITED TABLESPACE granted to ICPS_ADMIN');
        
    end if;
    
exception 
    when others then
        dbms_output.put_line('Exception occured: '||sqlerrm);
end;
