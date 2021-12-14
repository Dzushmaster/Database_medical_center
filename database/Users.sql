DROP USER USERS_;
DROP USER DOCTOR;
DROP USER ADMIN_;
DROP USER REG_LOG_USER;

DROP PROFILE PROFILE_USER;
DROP PROFILE PROFILE_DOCTOR;
DROP PROFILE PROFILE_ADMIN;
----------------------------------- USERS ----------------------------------------------
CREATE USER USERS_ IDENTIFIED BY ZGC7cejB
DEFAULT TABLESPACE Med_Center 
PROFILE PROFILE_USER
ACCOUNT UNLOCK;

CREATE USER DOCTOR IDENTIFIED BY w2AK08E0dt2D
DEFAULT TABLESPACE Med_Center
PROFILE PROFILE_DOCTOR
ACCOUNT UNLOCK;

CREATE USER ADMIN_ IDENTIFIED BY Ryb9rOYE71R2PBR
DEFAULT TABLESPACE Med_Center
PROFILE PROFILE_ADMIN
ACCOUNT UNLOCK;

CREATE USER REG_LOG_USER IDENTIFIED BY ZGRyPBRw2A
DEFAULT TABLESPACE Med_Center 
PROFILE PROFILE_USER
ACCOUNT UNLOCK;
----------------------------------- USERS ----------------------------------------------
----------------------------------- PROFILES -------------------------------------------
CREATE PROFILE PROFILE_USER LIMIT
FAILED_LOGIN_ATTEMPTS 5
PASSWORD_LOCK_TIME 1
IDLE_TIME 120;

CREATE PROFILE PROFILE_DOCTOR LIMIT
PASSWORD_LIFE_TIME 120
FAILED_LOGIN_ATTEMPTS 5
PASSWORD_LOCK_TIME 1
IDLE_TIME 120;

CREATE PROFILE PROFILE_ADMIN LIMIT
PASSWORD_LIFE_TIME 30
SESSIONS_PER_USER 3 
FAILED_LOGIN_ATTEMPTS 3
PASSWORD_LOCK_TIME 1
CONNECT_TIME 180
IDLE_TIME 120;
----------------------------------- PROFILES -------------------------------------------
----------------------------------- ROLES ----------------------------------------------
DROP ROLE USERS_ROLE;
DROP ROLE DOCTORS_ROLE;
DROP ROLE ADMINS_ROLE;
DROP ROLE REG_LOG_ROLE;


CREATE ROLE USERS_ROLE;
CREATE ROLE DOCTORS_ROLE;
CREATE ROLE ADMINS_ROLE;
CREATE ROLE REG_LOG_ROLE;

GRANT CREATE SESSION TO USERS_ROLE;
GRANT EXECUTE ON USER_PROCEDURES TO USERS_ROLE;
GRANT EXECUTE ON USERS_FUNCTION TO USERS_ROLE;

GRANT CREATE SESSION TO DOCTORS_ROLE;
GRANT EXECUTE ON DOC_PROCEDURES TO DOCTORS_ROLE;
GRANT EXECUTE ON DOC_FUNCTIONS TO USERS_ROLE;

GRANT CREATE SESSION TO ADMINS_ROLE;
GRANT EXECUTE ON ADMIN_PROCEDURES TO ADMINS_ROLE;

GRANT CREATE SESSION TO REG_LOG_ROLE;
GRANT EXECUTE ON CHECK_LOG_REG_PACK TO REG_LOG_ROLE;

GRANT USERS_ROLE TO USERS_;
GRANT DOCTORS_ROLE TO DOCTOR;
GRANT ADMINS_ROLE TO ADMIN_;
GRANT REG_LOG_ROLE TO REG_LOG_USER;

----------------------------------- ROLES ----------------------------------------------