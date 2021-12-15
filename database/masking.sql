alter session set nls_date_format='dd-mm-yyyy';
alter session set nls_language = 'american';
-------------------USERS MASKING -----------------------------------
begin
DBMS_REDACT.DROP_POLICY(
    object_schema =>'CREATOR',
    object_name => 'USER_',
    policy_name => 'redact_user'
);
end;

BEGIN
DBMS_REDACT.ADD_POLICY(
    object_schema => 'CREATOR',
    object_name => 'USER_',
    column_name => 'BIRTH_DATE',
    policy_name => 'redact_user',
    function_type => DBMS_REDACT.PARTIAL,
    function_parameters => 'm01d01y2021',
    expression => 'SYS_CONTEXT(''SYS_SESSION_ROLES'',''USERS_ROLE'') = ''FALSE'''
);
END;

BEGIN
DBMS_REDACT.ALTER_POLICY(
     object_schema         => 'CREATOR',
     object_name           => 'USER_',
     column_name           => 'EMAIL',
     policy_name           => 'redact_user',
     function_type => dbms_redact.partial, 
     function_parameters => 'VVVVVVVVVV,VVVVVVVVVV,*,5,10',
     regexp_position => DBMS_REDACT.RE_BEGINNING,
     regexp_occurrence => DBMS_REDACT.RE_FIRST,
     expression            => 'SYS_CONTEXT(''SYS_SESSION_ROLES'',''USERS_ROLE'') = ''FALSE''',
     action                => DBMS_REDACT.ADD_COLUMN);
END;

BEGIN
DBMS_REDACT.ALTER_POLICY(
     object_schema         => 'CREATOR',
     object_name           => 'USER_',
     column_name           => 'FULLNAME',
     policy_name           => 'redact_user',
     function_type => dbms_redact.partial, 
     function_parameters => 'VVVVVVVVVVVVVVV,VVVVVVVVVVVVVVV,#,5,15',
     regexp_position => DBMS_REDACT.RE_BEGINNING,
     regexp_occurrence => DBMS_REDACT.RE_FIRST,
     expression            => 'SYS_CONTEXT(''SYS_SESSION_ROLES'',''USERS_ROLE'') = ''FALSE''',
     action                => DBMS_REDACT.ADD_COLUMN);
END;
-------------------USERS MASKING -----------------------------------


SELECT * FROM CREATOR.USER_;

CREATE USER URSULA IDENTIFIED BY sssss
default tablespace med_center;
grant create session, select any table to URSULA;
