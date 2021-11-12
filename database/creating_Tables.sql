ALTER SESSION SET NLS_LANGUAGE = 'AMERICAN';
create tablespace Med_Center
datafile 'C:\database_labs\Medical_Center\Med_Cent.dbf'
size 300m
autoextend on next 10m
maxsize 600m
extent management local;

DROP TABLE USER_;
CREATE TABLE USER_(
                    ID_USER NUMBER(5, 0) PRIMARY KEY NOT NULL,
                    NAME NVARCHAR2(10) NOT NULL,
                    SECOND_NAME NVARCHAR2(20) NOT NULL,
                    MIDDLE_NAME NVARCHAR2(20) NOT NULL,
                    BIRTH_DATE DATE NOT NULL,
                    EMAIL NVARCHAR2(100) NOT NULL,
                    LOGIN VARCHAR2(20) NOT NULL,
                    PASSWORD VARCHAR2(20) NOT NULL
                    ) tablespace Med_Center;

DROP TABLE HOME_ANALYSES;
CREATE TABLE HOME_ANALYSES(
                            ID_ANALYSES NUMBER (10, 0) PRIMARY KEY NOT NULL,
                            ID_USER NUMBER(5,0) NOT NULL,
                            PULSE NUMBER (3, 0) NULL,
                            TEMPERATURE NUMBER(4,2) NULL,
                            BLOOD_PRESS VARCHAR2(7) NULL,
                            DATE_ANALYSE DATE,
                            CONSTRAINT FK_ID_USER FOREIGN KEY (ID_USER) REFERENCES USER_(ID_USER) 
                            ) tablespace Med_Center;

DROP TABLE DOCTOR;
CREATE TABLE DOCTOR(
                    ID_DOCTOR NUMBER(5, 0) PRIMARY KEY NOT NULL,
                    FULL_NAME NVARCHAR2(50) NOT NULL,
                    SPECIALITY NVARCHAR2(45) NOT NULL,
                    EMAIL NVARCHAR2(100) NULL,
                    LOGIN VARCHAR2(20) NOT NULL,
                    PASSWORD VARCHAR2(20) NOT NULL
                    ) tablespace Med_Center;

CREATE TABLE WORKDAY(
                     ID_WORKDAY NUMBER (10, 0) PRIMARY KEY NOT NULL,
                     ID_DOCTOR NUMBER(5,0) NOT NULL,
                     CABINET NUMBER(4,0) NOT NULL,
                     BEGINING DATE,
                     ENDING DATE,
                     CONSTRAINT PK_WORKDAY FOREIGN KEY (ID_DOCTOR) REFERENCES DOCTOR(ID_DOCTOR)
                    ) TABLESPACE MED_CENTER;

CREATE TABLE HEALTH(
                     ID_VISITE NUMBER (15, 0) PRIMARY KEY NOT NULL,
                     ID_PREV_VISITE NUMBER (15, 0) NOT NULL,
                     ID_USER NUMBER(5,0) NOT NULL,
                     ID_DOCTOR NUMBER(5,0) NOT NULL,
                     DATE_TIME_VISITE DATE NOT NULL,
                     CONSTRAINT FK_DOCTOR FOREIGN KEY (ID_DOCTOR) REFERENCES DOCTOR(ID_DOCTOR),
                     CONSTRAINT FK_USER FOREIGN KEY (ID_USER) REFERENCES USER_(ID_USER)
                     ) TABLESPACE MED_CENTER;

CREATE TABLE ANALYSES(
                     ID_ANALYSE NUMBER(15, 0) PRIMARY KEY NOT NULL,
                     ID_VISITE NUMBER (15, 0) NOT NULL,
                     LABARATORY VARCHAR2(4) NOT NULL,
                     NAME_ANALYSE NVARCHAR2(50) NOT NULL,
                     RESULT_ANALYSE NVARCHAR2(100) NULL,
                     DATE_TIME_ANALYSE DATE NOT NULL,
                     CONSTRAINT FK_VISITE FOREIGN KEY (ID_VISITE) REFERENCES HEALTH(ID_VISITE)
                     ) TABLESPACE MED_CENTER;

CREATE TABLE DESIASE(
                        ID_DESIASE NUMBER(15, 0) PRIMARY KEY NOT NULL,
                        ID_VISITE NUMBER(15, 0) NOT NULL,
                        SYMPTOMES NVARCHAR2(200),
                        THERAPY NVARCHAR2(200),
                        RESULT_DESIASE NVARCHAR2(200),
                        CONSTRAINT FK_VISIT FOREIGN KEY (ID_VISITE) REFERENCES HEALTH(ID_VISITE)
                        ) TABLESPACE MED_CENTER;

SELECT * FROM USER_;
