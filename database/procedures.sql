DROP PACKAGE CHECK_LOG_REG_PACK;
DROP PACKAGE USER_PROCEDURES;
DROP PACKAGE DOC_PROCEDURES;
DROP PACKAGE ADMIN_PROCEDURES;

CREATE OR REPLACE PACKAGE CHECK_LOG_REG_PACK IS
    PROCEDURE CHECK_LOGIN_USER(LOGIN IN USER_.LOGIN%TYPE, RESULT_ OUT NUMBER);
    PROCEDURE CHECK_LOGIN_DOC(LOGIN IN USER_.LOGIN%TYPE, RESULT_ OUT NUMBER);
    PROCEDURE CHECK_EMAIL_USER(EMAIL IN USER_.EMAIL%TYPE, RESULT_ OUT NUMBER);
    PROCEDURE CHECK_EMAIL_DOC(EMAIL IN USER_.EMAIL%TYPE, RESULT_ OUT NUMBER);
    PROCEDURE CHECK_DOC_PASSWORD(LOGIN IN USER_.LOGIN%TYPE, PASSWORD IN USER_.PASSWORD%TYPE, RESULT_ IN OUT NUMBER);
    PROCEDURE CHECK_USER_PASSWORD(LOGIN IN USER_.LOGIN%TYPE, PASSWORD IN USER_.PASSWORD%TYPE, RESULT_ IN OUT NUMBER);
END CHECK_LOG_REG_PACK;

CREATE OR REPLACE PACKAGE BODY CHECK_LOG_REG_PACK IS
    
    PROCEDURE CHECK_LOGIN_USER(
    LOGIN IN USER_.LOGIN%TYPE,
    RESULT_ OUT NUMBER
    )
    IS
    CURSOR USER_LOGIN (LOGIN_ USER_.LOGIN%TYPE) IS SELECT USER_.LOGIN FROM USER_
    WHERE USER_.LOGIN = CREATOR.CRYPTO_VALUE_128(LOGIN_); 
    LOGIN_US USER_.LOGIN%TYPE;
    BEGIN
        OPEN USER_LOGIN(LOGIN);
        FETCH USER_LOGIN INTO LOGIN_US;
        IF USER_LOGIN%ROWCOUNT !=0
        THEN
            RESULT_:=1;
            RETURN;
        ELSE
            RESULT_:=0;
        END IF;
        CLOSE USER_LOGIN;
    END CHECK_LOGIN_USER;
    
    PROCEDURE CHECK_LOGIN_DOC(
    LOGIN IN USER_.LOGIN%TYPE,
    RESULT_ OUT NUMBER
    )
    IS
    CURSOR DOCTOR_LOGIN (LOGIN_ DOCTOR.LOGIN%TYPE) IS SELECT DOCTOR.LOGIN FROM DOCTOR
    WHERE DOCTOR.LOGIN = CREATOR.CRYPTO_VALUE_128(LOGIN_);
    LOGIN_DOC DOCTOR.LOGIN%TYPE;
    BEGIN
        OPEN DOCTOR_LOGIN(LOGIN);
        FETCH DOCTOR_LOGIN INTO LOGIN_DOC;
        IF DOCTOR_LOGIN%ROWCOUNT !=0
        THEN
            RESULT_:=1;
        ELSE
            RESULT_:=0;
        END IF;
        CLOSE DOCTOR_LOGIN;
    END CHECK_LOGIN_DOC;

    PROCEDURE CHECK_EMAIL_USER(
    EMAIL IN USER_.EMAIL%TYPE,
    RESULT_ OUT NUMBER
    )
    IS
    CURSOR USER_EMAIL(EMAIL_ USER_.EMAIL%TYPE) IS SELECT USER_.EMAIL FROM USER_
    WHERE USER_.EMAIL = EMAIL_; 
    EMAIL_US USER_.EMAIL%TYPE;
    BEGIN
        OPEN USER_EMAIL(EMAIL);
        FETCH USER_EMAIL INTO EMAIL_US;
        RESULT_ := USER_EMAIL%ROWCOUNT;
        CLOSE USER_EMAIL;
    END CHECK_EMAIL_USER;    

    PROCEDURE CHECK_EMAIL_DOC(
    EMAIL IN USER_.EMAIL%TYPE,
    RESULT_ OUT NUMBER
    )
    IS
    CURSOR DOCTOR_EMAIL (EMAIL_ DOCTOR.EMAIL%TYPE)IS SELECT DOCTOR.EMAIL FROM DOCTOR
    WHERE DOCTOR.LOGIN = EMAIL_;
    EMAIL_DOC DOCTOR.EMAIL%TYPE;
    BEGIN
        OPEN DOCTOR_EMAIL(EMAIL);
        FETCH DOCTOR_EMAIL INTO EMAIL_DOC;
        RESULT_ := DOCTOR_EMAIL%ROWCOUNT;
        CLOSE DOCTOR_EMAIL;
    END CHECK_EMAIL_DOC;

    PROCEDURE CHECK_DOC_PASSWORD(
                                LOGIN IN USER_.LOGIN%TYPE,
                                PASSWORD IN USER_.PASSWORD%TYPE,
                                RESULT_ IN OUT NUMBER
                                )
    IS
        CURSOR DOCTOR_LOG_PS (LOGIN_ DOCTOR.LOGIN%TYPE, PASSWORD_ DOCTOR.PASSWORD%TYPE)
        IS SELECT DOCTOR.LOGIN FROM DOCTOR WHERE DOCTOR.LOGIN = CREATOR.CRYPTO_VALUE_128(LOGIN_)
        AND DOCTOR.PASSWORD = CREATOR.CRYPTO_VALUE_192(PASSWORD_);
    LOG_PS_DOC DOCTOR_LOG_PS%ROWTYPE;
    BEGIN
        OPEN DOCTOR_LOG_PS(LOGIN, PASSWORD);
        FETCH DOCTOR_LOG_PS INTO LOG_PS_DOC;
        IF DOCTOR_LOG_PS%ROWCOUNT =0
        THEN
            RESULT_:=0;
        ELSE
            RESULT_:=1;
        END IF;
        CLOSE DOCTOR_LOG_PS;
    END CHECK_DOC_PASSWORD;

    PROCEDURE CHECK_USER_PASSWORD(
                                LOGIN IN USER_.LOGIN%TYPE,
                                PASSWORD IN USER_.PASSWORD%TYPE,
                                RESULT_ IN OUT NUMBER
                                )
    IS
    CURSOR USER_LOG_PS (LOGIN_ USER_.LOGIN%TYPE, PASSWORD_ USER_.PASSWORD%TYPE) 
        IS SELECT USER_.LOGIN FROM USER_ WHERE USER_.LOGIN = CREATOR.CRYPTO_VALUE_128(LOGIN_) 
        AND  USER_.PASSWORD = CREATOR.CRYPTO_VALUE_192(PASSWORD_); 
    LOG_PS_US USER_LOG_PS%ROWTYPE;
    BEGIN
        OPEN USER_LOG_PS(LOGIN, PASSWORD);
        FETCH USER_LOG_PS INTO LOG_PS_US;
        IF USER_LOG_PS%ROWCOUNT =0
        THEN
            RESULT_:=0;
            RETURN;
        ELSE
            RESULT_:=1;
        END IF;
        CLOSE USER_LOG_PS;
    END CHECK_USER_PASSWORD;

END CHECK_LOG_REG_PACK;
-----------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE USER_PROCEDURES IS

PROCEDURE CREATE_TICKET(ID_USER USER_.ID_USER%TYPE, ID_DOC DOCTOR.ID_DOCTOR%TYPE, TIME_VIS HEALTH.DATE_TIME_VISITE%TYPE, RESULT_ OUT NUMBER);

PROCEDURE INSERT_HOME_ANALYSES(ID_USER USER_.ID_USER%TYPE, PULSE HOME_ANALYSES.PULSE%TYPE,
TEMPERATURE HOME_ANALYSES.TEMPERATURE%TYPE, BLOOD_PRESS HOME_ANALYSES.BLOOD_PRESS%TYPE,
DATE_ HOME_ANALYSES.DATE_ANALYSE%TYPE, RESULT_ OUT NUMBER);

PROCEDURE DELETE_TICKET_BY_ID(ID_VIS HEALTH.ID_VISITE%TYPE, ID_US USER_.ID_USER%TYPE, RESULT_ OUT NUMBER);

END USER_PROCEDURES;

CREATE OR REPLACE PACKAGE BODY USER_PROCEDURES IS

    PROCEDURE CREATE_TICKET(ID_USER USER_.ID_USER%TYPE,
    ID_DOC DOCTOR.ID_DOCTOR%TYPE, TIME_VIS HEALTH.DATE_TIME_VISITE%TYPE, RESULT_ OUT NUMBER)
    AS
    ID_US DOCTOR.ID_DOCTOR%TYPE;
    BEGIN
        SELECT USER_.ID_USER INTO ID_US FROM USER_ WHERE ID_USER = USER_.ID_USER;
        SELECT DOCTOR.ID_DOCTOR INTO ID_US FROM DOCTOR WHERE ID_DOC = DOCTOR.ID_DOCTOR;
        INSERT INTO HEALTH VALUES(VISITE_ID.NEXTVAL, ID_USER, ID_DOC, TIME_VIS);
        COMMIT;
        RESULT_:= VISITE_ID.CURRVAL;
        EXCEPTION
            WHEN NO_DATA_FOUND 
            THEN RESULT_ := -1; ROLLBACK;
    END CREATE_TICKET;

    PROCEDURE INSERT_HOME_ANALYSES(ID_USER USER_.ID_USER%TYPE, PULSE HOME_ANALYSES.PULSE%TYPE,
    TEMPERATURE HOME_ANALYSES.TEMPERATURE%TYPE, BLOOD_PRESS HOME_ANALYSES.BLOOD_PRESS%TYPE,
    DATE_ HOME_ANALYSES.DATE_ANALYSE%TYPE, RESULT_ OUT NUMBER)
    AS
        ID_US HOME_ANALYSES.ID_ANALYSES%TYPE;
    BEGIN
        SELECT USER_.ID_USER INTO ID_US FROM USER_ WHERE USER_.ID_USER= ID_USER;
        INSERT INTO HOME_ANALYSES VALUES(HOME_ANALYSES_ID.NEXTVAL, ID_US,
        CREATOR.CRYPTO_VALUE_128(PULSE),
        CREATOR.CRYPTO_VALUE_128(TEMPERATURE),
        CREATOR.CRYPTO_VALUE_128(BLOOD_PRESS),
        DATE_);
        COMMIT;
        RESULT_:=HOME_ANALYSES_ID.CURRVAL;
        EXCEPTION
        WHEN NO_DATA_FOUND
        THEN RESULT_:=-1;
    END INSERT_HOME_ANALYSES;

    PROCEDURE DELETE_TICKET_BY_ID(ID_VIS HEALTH.ID_VISITE%TYPE, ID_US USER_.ID_USER%TYPE, RESULT_ OUT NUMBER)
    IS
        /* ���������� ����������. */
        ALREADY_HAVE_DESISION EXCEPTION;
        /* ��� ���������� ����������� � ������� ������. */
        PRAGMA EXCEPTION_INIT (ALREADY_HAVE_DESISION, -2292);
        ID_VISITE_ HEALTH.ID_VISITE%TYPE;
        ID_USER_ USER_.ID_USER%TYPE;
    BEGIN
        SELECT HEALTH.ID_VISITE, HEALTH.ID_USER INTO ID_VISITE_, ID_USER_ FROM HEALTH
        WHERE ID_US = HEALTH.ID_USER AND ID_VIS = HEALTH.ID_VISITE;
        DELETE HEALTH WHERE HEALTH.ID_USER = ID_USER_ AND HEALTH.ID_VISITE = ID_VISITE_;
        RESULT_ := 1;
        COMMIT;
        EXCEPTION
        WHEN NO_DATA_FOUND
        THEN ROLLBACK; RESULT_:=-1;
        WHEN ALREADY_HAVE_DESISION
        THEN ROLLBACK; RESULT_:=-2;
    END DELETE_TICKET_BY_ID;

    
END USER_PROCEDURES;

CREATE OR REPLACE PACKAGE DOC_PROCEDURES IS

    PROCEDURE INSERT_ANALYSES(ID_VIS_ HEALTH.ID_VISITE%TYPE, LAB_ ANALYSES.LABARATORY%TYPE,
        NAME_ANALYSE ANALYSES.NAME_ANALYSE%TYPE, RES_ANALYSE ANALYSES.RESULT_ANALYSE%TYPE,
        TIME_ANALYSE ANALYSES.DATE_TIME_ANALYSE%TYPE, RESULT_ OUT NUMBER);

    PROCEDURE INSERT_DESIASE (ID_VISITE_ HEALTH.ID_VISITE%TYPE, SYMPT DESIASE.SYMPTOMES%TYPE,
        THERAPY DESIASE.THERAPY%TYPE, RES_DESIASE DESIASE.RESULT_DESIASE%TYPE ,RESULT_ OUT NUMBER);

END DOC_PROCEDURES;

CREATE OR REPLACE PACKAGE BODY DOC_PROCEDURES IS

    PROCEDURE INSERT_ANALYSES(ID_VIS_ HEALTH.ID_VISITE%TYPE, LAB_ ANALYSES.LABARATORY%TYPE,
        NAME_ANALYSE ANALYSES.NAME_ANALYSE%TYPE, RES_ANALYSE ANALYSES.RESULT_ANALYSE%TYPE,
        TIME_ANALYSE ANALYSES.DATE_TIME_ANALYSE%TYPE, RESULT_ OUT NUMBER)
    AS
        ID_VIS HEALTH.ID_VISITE%TYPE;
    BEGIN
        SELECT HEALTH.ID_VISITE INTO ID_VIS FROM HEALTH WHERE HEALTH.ID_VISITE = ID_VIS_;
        INSERT INTO ANALYSES VALUES(ANALYSES_ID.NEXTVAL, ID_VIS, LAB_, NAME_ANALYSE, RES_ANALYSE, TIME_ANALYSE);
        COMMIT;
        RESULT_:= ANALYSES_ID.CURRVAL;
        EXCEPTION
        WHEN NO_DATA_FOUND 
        THEN RESULT_:=-1;
    END INSERT_ANALYSES;
    
    PROCEDURE INSERT_DESIASE (ID_VISITE_ HEALTH.ID_VISITE%TYPE, SYMPT DESIASE.SYMPTOMES%TYPE,
        THERAPY DESIASE.THERAPY%TYPE, RES_DESIASE DESIASE.RESULT_DESIASE%TYPE ,RESULT_ OUT NUMBER)
    AS
        ID_VIS NUMBER;
    BEGIN
        SELECT HEALTH.ID_VISITE INTO ID_VIS FROM HEALTH JOIN DESIASE ON DESIASE.ID_VISITE = HEALTH.ID_VISITE 
        WHERE HEALTH.ID_VISITE = ID_VISITE_ 
        AND DESIASE.ID_VISITE != HEALTH.ID_VISITE;
        INSERT INTO DESIASE VALUES(DESIASE_ID.NEXTVAL, ID_VIS, SYMPT, THERAPY, RES_DESIASE);
        COMMIT;
        RESULT_:= DESIASE_ID.CURRVAL;
        EXCEPTION
        WHEN NO_DATA_FOUND 
        THEN RESULT_:=-1;
    END INSERT_DESIASE;
    
END DOC_PROCEDURES;

CREATE OR REPLACE PACKAGE ADMIN_PROCEDURES IS

PROCEDURE INSERT_USER (FULLNAME USER_.FULLNAME%TYPE, BIRTHDATE USER_.BIRTH_DATE%TYPE, EMAIL USER_.EMAIL%TYPE,
        LOGIN USER_.LOGIN%TYPE, PASSWORD_ USER_.PASSWORD%TYPE, RESULT_ OUT NUMBER);

PROCEDURE INSERT_DOCTOR (FULLNAME DOCTOR.FULL_NAME%TYPE, SPECIALITY DOCTOR.SPECIALITY%TYPE, EMAIL DOCTOR.EMAIL%TYPE,
        LOGIN DOCTOR.LOGIN%TYPE, PASSWORD_ DOCTOR.PASSWORD%TYPE,  RESULT_ OUT NUMBER);

PROCEDURE INSERT_WORKDAY (ID_DOC DOCTOR.ID_DOCTOR%TYPE, CAB WORKDAY.CABINET%TYPE,
        BEGIN_DATE WORKDAY.BEGINING%TYPE, END_DATE WORKDAY.ENDING%TYPE, RESULT_ OUT NUMBER);

PROCEDURE DELETE_USER_BY_ID(ID_USER_ USER_.ID_USER%TYPE, RESULT_ OUT NUMBER);

PROCEDURE DELETE_DOC_BY_ID(ID_DOCTOR_ DOCTOR.ID_DOCTOR%TYPE, RESULT_ OUT NUMBER);

END ADMIN_PROCEDURES;

CREATE OR REPLACE PACKAGE BODY ADMIN_PROCEDURES IS

    PROCEDURE INSERT_USER (FULLNAME USER_.FULLNAME%TYPE, BIRTHDATE USER_.BIRTH_DATE%TYPE, EMAIL USER_.EMAIL%TYPE,
            LOGIN USER_.LOGIN%TYPE, PASSWORD_ USER_.PASSWORD%TYPE, RESULT_ OUT NUMBER)
    AS
    BEGIN
        INSERT INTO USER_ VALUES(
            USER_ID.NEXTVAL,
            FULLNAME,
            BIRTHDATE,
            EMAIL,
            CREATOR.CRYPTO_VALUE_128(LOGIN),
            CREATOR.CRYPTO_VALUE_192(PASSWORD_));
        RESULT_ := USER_ID.CURRVAL;
        COMMIT;
        RETURN;
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
                RESULT_ := -1;
                ROLLBACK;
    END INSERT_USER;

    PROCEDURE INSERT_DOCTOR (FULLNAME DOCTOR.FULL_NAME%TYPE, SPECIALITY DOCTOR.SPECIALITY%TYPE, EMAIL DOCTOR.EMAIL%TYPE,
            LOGIN DOCTOR.LOGIN%TYPE, PASSWORD_ DOCTOR.PASSWORD%TYPE,  RESULT_ OUT NUMBER)
    AS
    BEGIN
        INSERT INTO DOCTOR VALUES(
            DOCTOR_ID.NEXTVAL,
            FULLNAME,
            SPECIALITY,
            EMAIL,
            CREATOR.CRYPTO_VALUE_128(LOGIN),
            CREATOR.CRYPTO_VALUE_192(PASSWORD_));
        RESULT_ := DOCTOR_ID.CURRVAL;
        COMMIT;
        RETURN;
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
                RESULT_ := -1;
                ROLLBACK;
    END INSERT_DOCTOR;

    PROCEDURE INSERT_WORKDAY (ID_DOC DOCTOR.ID_DOCTOR%TYPE, CAB WORKDAY.CABINET%TYPE,
        BEGIN_DATE WORKDAY.BEGINING%TYPE, END_DATE WORKDAY.ENDING%TYPE, RESULT_ OUT NUMBER)
    AS
    ID_DC DOCTOR.ID_DOCTOR%TYPE;
    BEGIN
        SELECT DOCTOR.ID_DOCTOR INTO ID_DC FROM DOCTOR WHERE DOCTOR.ID_DOCTOR = ID_DOC;
        INSERT INTO WORKDAY VALUES(WORKDAY_ID.NEXTVAL, ID_DOC, CAB ,BEGIN_DATE, END_DATE);
        COMMIT;
        RESULT_:=WORKDAY_ID.CURRVAL;
        EXCEPTION 
        WHEN NO_DATA_FOUND
        THEN RESULT_:=-1;
    END INSERT_WORKDAY;

    PROCEDURE DELETE_USER_BY_ID(ID_USER_ USER_.ID_USER%TYPE, RESULT_ OUT NUMBER)
    IS
        STILL_HAVE_DATA EXCEPTION;
        PRAGMA EXCEPTION_INIT (STILL_HAVE_DATA, -2292);
        USER_ID USER_.ID_USER%TYPE;
    BEGIN
        SELECT USER_.ID_USER INTO USER_ID FROM USER_ WHERE USER_.ID_USER = ID_USER_;
        DELETE USER_ WHERE USER_.ID_USER = ID_USER;
        RESULT_:=1;
        COMMIT;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN RESULT_:=-1;
        WHEN STILL_HAVE_DATA THEN
        DELETE (SELECT * FROM ANALYSES JOIN HEALTH ON ANALYSES.ID_VISITE = HEALTH.ID_VISITE WHERE HEALTH.ID_USER = ID_USER_);
        DELETE (SELECT * FROM DESIASE JOIN HEALTH ON DESIASE.ID_VISITE = HEALTH.ID_VISITE WHERE HEALTH.ID_USER = ID_USER_);
        DELETE HEALTH WHERE HEALTH.ID_USER = ID_USER_;
        DELETE HOME_ANALYSES WHERE HOME_ANALYSES.ID_USER = ID_USER;
        DELETE USER_ WHERE USER_.ID_USER = ID_USER_;
        RESULT_ :=1;
    END DELETE_USER_BY_ID;
    
    PROCEDURE DELETE_DOC_BY_ID(ID_DOCTOR_ DOCTOR.ID_DOCTOR%TYPE, RESULT_ OUT NUMBER)
    IS
        STILL_HAVE_DATA EXCEPTION;
        PRAGMA EXCEPTION_INIT (STILL_HAVE_DATA, -2292);
        DOCTOR_ID DOCTOR.ID_DOCTOR%TYPE;
    BEGIN
        SELECT DOCTOR.ID_DOCTOR INTO DOCTOR_ID FROM DOCTOR WHERE DOCTOR.ID_DOCTOR = ID_DOCTOR_;
        DELETE DOCTOR WHERE DOCTOR.ID_DOCTOR = ID_DOCTOR;
        RESULT_:=1;
        COMMIT;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN RESULT_:=-1;
        WHEN STILL_HAVE_DATA THEN 
        DELETE WORKDAY WHERE WORKDAY.ID_DOCTOR = ID_DOCTOR_;
        RESULT_ :=-2;
    END DELETE_DOC_BY_ID;
    
END ADMIN_PROCEDURES;





