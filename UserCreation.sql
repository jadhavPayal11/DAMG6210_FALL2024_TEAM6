set serveroutput on;

declare
user_exists integer;

begin
    select count(*) 
    into user_exists
    from all_users
    where upper(username) = 'ICPS_ADMIN';

    if(user_exists = 1) then
        execute immediate 'drop user ICPS_ADMIN';
        dbms_output.put_line('User ICPS_ADMIN dropped'); 
    else
        execute immediate 'create user ICPS_ADMIN identified by IcpsAdminProject2024#';
        dbms_output.put_line('User ICPS_ADMIN created');
    end if;
    
exception when others then
dbms_output.put_line('Exception occured:'||sqlerrm);
end;
