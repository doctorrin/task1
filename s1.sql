CREATE TABLE EMPLOYEES
   (
	EMPLOYEE_ID INTEGER CONSTRAINT EMPLOYEE_ID_PK PRIMARY KEY, 
	FULL_NAME VARCHAR(30), 
	EMAIL VARCHAR(25),   
	JOB_ID VARCHAR(10),
	HIRE_DATE DATE,
	SALARY INTEGER, 
	DEPARTMENT_ID INTEGER 
	);
INSERT INTO EMPLOYEES 
	VALUES  (1, 'Steven King', 's.king@gmail', 'DEV_PROG', '2015-06-16', 78000, 100),
		    (2, 'David Chen', 'd.chen@gmail', 'PUR_MAN', '2022-03-01', 66000, 101),
		    (3, 'David	Austin', 'd.austin@gmail', 'PUR_DES', '2022-06-16', 80000, 101),
		    (4, 'Daniel	Faviet', 'd.faviet@gmail', 'LOG_REP', '2022-03-03', 80000, 100),
            (5, 'Bruce	Ernst', 'b.ernst@gmail', 'PUR_MAN', '2010-09-09', 70000, 101),
            (6, 'Nancy	Greenberg', 'ngree@gmail', 'SAL_MAN', '2022-01-01', 200000, 103),
            (7, 'James	Marlow', 'jma@gmail', 'LOG_MAN', '2022-05-19', 10000, 102),
            (8, 'Peter	Vargas', 'pvar@gmail', 'SAL_REP', '2022-04-19', 20000, 103);


CREATE TABLE DEPARTMENTS
   (
	DEPARTMENT_ID INTEGER CONSTRAINT DEPARTMENT_ID_PK PRIMARY KEY, 
	DEPARTMENT_NAME VARCHAR(30),
	LOCATION_ID INTEGER
	);
INSERT INTO DEPARTMENTS 
	VALUES  (100, 'Development', 1500),
			(101, 'Purchasing', 2300),
			(102, 'Logistics', 1700),
			(103, 'Sales', 2300);

CREATE TABLE JOBS
   (
	JOB_ID VARCHAR(10) CONSTRAINT JOB_ID_PK PRIMARY KEY, 
	JOB_TITLE VARCHAR(35)
	);
INSERT INTO JOBS 
	VALUES  ('DEV_PROG', 'Programmer'),
			('PUR_MAN', 'Manager'),
			('PUR_DES', 'Designer'),
			('LOG_REP', 'Representative'),
			('SAL_MAN', 'Manager'),
			('LOG_MAN', 'Manager'),
			('SAL_REP', 'Representative');

CREATE TABLE LOCATIONS
   (
	LOCATION_ID INTEGER CONSTRAINT LOCATION_ID_PK PRIMARY KEY, 
	STREET_ADDRESS VARCHAR(40), 
	COUNTRY_ID CHAR(2)
 	);
INSERT INTO LOCATIONS 
	VALUES  (1200,'1297 Via Cola di Rie', 'AR'),
			(1500, '12-98 Victoria Street', 'AU'),
			(1700, '2007 Zagora St', 'BE'),
			(2300, '93091 Calle della Testa', 'CA');
   
CREATE TABLE COUNTRIES
   (
	COUNTRY_ID CHAR(2) CONSTRAINT COUNTRY_C_ID_PK PRIMARY KEY, 
	COUNTRY_NAME VARCHAR(40)
	);
INSERT INTO COUNTRIES 
	VALUES	('AR', 'Argentina'),
			('AU', 'Australia'),
			('BE', 'Belgium'),	
			('CA', 'Canada');
	
ALTER TABLE EMPLOYEES ADD CONSTRAINT EMP_DEP_FK FOREIGN KEY (DEPARTMENT_ID)
	  REFERENCES  DEPARTMENTS (DEPARTMENT_ID);
	
ALTER TABLE EMPLOYEES ADD CONSTRAINT EMP_JOB_FK FOREIGN KEY (JOB_ID)
	  REFERENCES JOBS (JOB_ID);
	
ALTER TABLE DEPARTMENTS ADD CONSTRAINT DEPT_LOC_FK FOREIGN KEY (LOCATION_ID)
	  REFERENCES LOCATIONS (LOCATION_ID);
	
ALTER TABLE LOCATIONS ADD CONSTRAINT LOC_C_ID_FK FOREIGN KEY (COUNTRY_ID)
	  REFERENCES COUNTRIES (COUNTRY_ID);
	  
--ЗАДАНИЯ
	  
--1)Сделать выборку всех работников с именем “Давид” из отдела “Снабжение” с полями ФИО, зп, должность

SELECT FULL_NAME, SALARY, JOB_TITLE FROM EMPLOYEES
JOIN DEPARTMENTS ON EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
JOIN JOBS ON EMPLOYEES.JOB_ID = JOBS.JOB_ID

WHERE DEPARTMENT_NAME = 'Purchasing' AND FULL_NAME LIKE 'David%';

--2)Посчитать среднюю заработную плату работников по отделам

SELECT DEPARTMENT_NAME, AVG(SALARY) FROM EMPLOYEES
JOIN DEPARTMENTS ON EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
GROUP BY DEPARTMENT_NAME

/*3)Сделать выборку по должностям, в результате которой отобразятся данные, 
больше ли средняя ЗП по должности, чем средняя ЗП по всем работникам.*/

SELECT JOB_TITLE, AVG(SALARY) AVG_BY_JOB, 
CASE
	WHEN AVG(SALARY) > (SELECT AVG(SALARY) FROM EMPLOYEES) THEN 'YES'
	ELSE 'NO'
	END AS GREATER
	
FROM EMPLOYEES
JOIN JOBS ON EMPLOYEES.JOB_ID = JOBS.JOB_ID
GROUP BY JOB_TITLE;

/*4)Сделать представление, в котором собраны данные по должностям 
(Должность, в каких отделах встречается эта должность (в виде массива), 
список сотрудников, начавших работать в этом отделе не раньше 2021 года 
(Сгруппировать по отделам) (в формате JSON), средняя заработная плата по должности)*/


CREATE VIEW JOINS AS 
	SELECT FULL_NAME, HIRE_DATE, SALARY, DEPARTMENT_NAME, JOB_TITLE FROM EMPLOYEES
	JOIN DEPARTMENTS ON EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
	JOIN JOBS ON EMPLOYEES.JOB_ID = JOBS.JOB_ID
	WHERE HIRE_DATE > '2022-01-01'

SELECT JOB_TITLE, ARRAY_AGG(DEPARTMENT_NAME), AVG(SALARY) FROM JOINS
GROUP BY JOB_TITLE 

SELECT JSON_BUILD_OBJECT(DEPARTMENT_NAME, JSON_AGG(FULL_NAME)) FROM JOINS
GROUP BY DEPARTMENT_NAME



