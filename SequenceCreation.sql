SET SERVEROUTPUT ON;

ALTER SESSION SET CURRENT_SCHEMA = ICPS_CORE;


DECLARE
seq_exists integer;

BEGIN
    
    --ADDRESS_SEQ sequence
    begin
        seq_exists := 0;
        select count(*)
        into seq_exists
        from user_sequences
        where upper(sequence_name) = 'ADDRESS_SEQ';
        
        if(seq_exists = 1)then
            execute immediate 'drop sequence ADDRESS_SEQ';
            dbms_output.put_line('Sequence ADDRESS_SEQ dropped'); 
         end if;
         execute immediate 'CREATE SEQUENCE ADDRESS_SEQ
                            START WITH 1
                            INCREMENT BY 1
                            MAXVALUE 10000
                            NOCACHE
                            NOCYCLE';
         
         dbms_output.put_line('Sequence ADDRESS_SEQ created');
       
    exception 
        when others then
            dbms_output.put_line('Exception occured while creating ADDRESS_SEQ sequence: ' || sqlerrm);
    end;
    
    --INS_TYPE_SEQ sequence
    begin
        seq_exists := 0;
        select count(*)
        into seq_exists
        from user_sequences
        where upper(sequence_name) = 'INS_TYPE_SEQ';
        
        if(seq_exists = 1)then
            execute immediate 'drop sequence INS_TYPE_SEQ';
            dbms_output.put_line('Sequence INS_TYPE_SEQ dropped'); 
         end if;
         execute immediate 'CREATE SEQUENCE INS_TYPE_SEQ
                            START WITH 1
                            INCREMENT BY 1
                            MAXVALUE 10000
                            NOCACHE
                            NOCYCLE';
         
         dbms_output.put_line('Sequence INS_TYPE_SEQ created');
       
    exception 
        when others then
            dbms_output.put_line('Exception occured while creating INS_TYPE_SEQ sequence: ' || sqlerrm);
    end;
    
    --POLICY_HOLDER_SEQ sequence
    begin
        seq_exists := 0;
        select count(*)
        into seq_exists
        from user_sequences
        where upper(sequence_name) = 'POLICY_HOLDER_SEQ';
        
        if(seq_exists = 1)then
            execute immediate 'drop sequence POLICY_HOLDER_SEQ';
            dbms_output.put_line('Sequence POLICY_HOLDER_SEQ dropped'); 
         end if;
         execute immediate 'CREATE SEQUENCE POLICY_HOLDER_SEQ
                            START WITH 1
                            INCREMENT BY 1
                            MAXVALUE 10000
                            NOCACHE
                            NOCYCLE';
         
         dbms_output.put_line('Sequence POLICY_HOLDER_SEQ created');
       
    exception 
        when others then
            dbms_output.put_line('Exception occured while creating POLICY_HOLDER_SEQ sequence: ' || sqlerrm);
    end;
    
    --PROVIDER_SEQ sequence
    begin
        seq_exists := 0;
        select count(*)
        into seq_exists
        from user_sequences
        where upper(sequence_name) = 'PROVIDER_SEQ';
        
        if(seq_exists = 1)then
            execute immediate 'drop sequence PROVIDER_SEQ';
            dbms_output.put_line('Sequence PROVIDER_SEQ dropped'); 
         end if;
         execute immediate 'CREATE SEQUENCE PROVIDER_SEQ
                            START WITH 1
                            INCREMENT BY 1
                            MAXVALUE 10000
                            NOCACHE
                            NOCYCLE';
         
         dbms_output.put_line('Sequence PROVIDER_SEQ created');
       
    exception 
        when others then
            dbms_output.put_line('Exception occured while creating PROVIDER_SEQ sequence: ' || sqlerrm);
    end;
    
    --AGENT_SEQ sequence
    begin
        seq_exists := 0;
        select count(*)
        into seq_exists
        from user_sequences
        where upper(sequence_name) = 'AGENT_SEQ';
        
        if(seq_exists = 1)then
            execute immediate 'drop sequence AGENT_SEQ';
            dbms_output.put_line('Sequence AGENT_SEQ dropped'); 
         end if;
         execute immediate 'CREATE SEQUENCE AGENT_SEQ
                            START WITH 1
                            INCREMENT BY 1
                            MAXVALUE 10000
                            NOCACHE
                            NOCYCLE';
         
         dbms_output.put_line('Sequence AGENT_SEQ created');
       
    exception 
        when others then
            dbms_output.put_line('Exception occured while creating AGENT_SEQ sequence: ' || sqlerrm);
    end;
    
    --INS_APPL_SEQ sequence
    begin
        seq_exists := 0;
        select count(*)
        into seq_exists
        from user_sequences
        where upper(sequence_name) = 'INS_APPL_SEQ';
        
        if(seq_exists = 1)then
            execute immediate 'drop sequence INS_APPL_SEQ';
            dbms_output.put_line('Sequence INS_APPL_SEQ dropped'); 
         end if;
         execute immediate 'CREATE SEQUENCE INS_APPL_SEQ
                            START WITH 1
                            INCREMENT BY 1
                            MAXVALUE 10000
                            NOCACHE
                            NOCYCLE';
         
         dbms_output.put_line('Sequence INS_APPL_SEQ created');
       
    exception 
        when others then
            dbms_output.put_line('Exception occured while creating INS_APPL_SEQ sequence: ' || sqlerrm);
    end;
    
    --POLICY_SEQ sequence
    begin
        seq_exists := 0;
        select count(*)
        into seq_exists
        from user_sequences
        where upper(sequence_name) = 'POLICY_SEQ';
        
        if(seq_exists = 1)then
            execute immediate 'drop sequence POLICY_SEQ';
            dbms_output.put_line('Sequence POLICY_SEQ dropped'); 
         end if;
         execute immediate 'CREATE SEQUENCE POLICY_SEQ
                            START WITH 1
                            INCREMENT BY 1
                            MAXVALUE 10000
                            NOCACHE
                            NOCYCLE';
         
         dbms_output.put_line('Sequence POLICY_SEQ created');
       
    exception 
        when others then
            dbms_output.put_line('Exception occured while creating POLICY_SEQ sequence: ' || sqlerrm);
    end;
    
    --CLAIM_SEQ sequence
    begin
        seq_exists := 0;
        select count(*)
        into seq_exists
        from user_sequences
        where upper(sequence_name) = 'CLAIM_SEQ';
        
        if(seq_exists = 1)then
            execute immediate 'drop sequence CLAIM_SEQ';
            dbms_output.put_line('Sequence CLAIM_SEQ dropped'); 
         end if;
         execute immediate 'CREATE SEQUENCE CLAIM_SEQ
                            START WITH 1
                            INCREMENT BY 1
                            MAXVALUE 10000
                            NOCACHE
                            NOCYCLE';
         
         dbms_output.put_line('Sequence CLAIM_SEQ created');
       
    exception 
        when others then
            dbms_output.put_line('Exception occured while creating CLAIM_SEQ sequence: ' || sqlerrm);
    end;
    
    --PAYMENT_SEQ sequence
    begin
        seq_exists := 0;
        select count(*)
        into seq_exists
        from user_sequences
        where upper(sequence_name) = 'PAYMENT_SEQ';
        
        if(seq_exists = 1)then
            execute immediate 'drop sequence PAYMENT_SEQ';
            dbms_output.put_line('Sequence PAYMENT_SEQ dropped'); 
         end if;
         execute immediate 'CREATE SEQUENCE PAYMENT_SEQ
                            START WITH 1
                            INCREMENT BY 1
                            MAXVALUE 10000
                            NOCACHE
                            NOCYCLE';
         
         dbms_output.put_line('Sequence PAYMENT_SEQ created');
       
    exception 
        when others then
            dbms_output.put_line('Exception occured while creating PAYMENT_SEQ sequence: ' || sqlerrm);
    end;
    
    
EXCEPTION 
    WHEN OTHERS THEN
        dbms_output.put_line('Exception occured while creating sequences');    
END;
/