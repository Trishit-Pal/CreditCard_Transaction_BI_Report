-- 1. Create cc_detail table

CREATE TABLE cc_detail (
    Client_Num INT,
    Card_Category VARCHAR(20),
    Annual_Fees INT,
    Activation_30_Days INT,
    Customer_Acq_Cost INT,
    Week_Start_Date DATE,
    Week_Num VARCHAR(20),
    Qtr VARCHAR(10),
    current_year INT,
    Credit_Limit DECIMAL(10,2),
    Total_Revolving_Bal INT,
    Total_Trans_Amt INT,
    Total_Trans_Ct INT,
    Avg_Utilization_Ratio DECIMAL(10,3),
    Use_Chip VARCHAR(10),
    Exp_Type VARCHAR(50),
    Interest_Earned DECIMAL(10,3),
    Delinquent_Acc VARCHAR(5)
);

-- 2. Create cc_detail table

CREATE TABLE cust_detail (
    Client_Num INT,
    Customer_Age INT,
    Gender VARCHAR(5),
    Dependent_Count INT,
    Education_Level VARCHAR(50),
    Marital_Status VARCHAR(20),
    State_cd VARCHAR(50),
    Zipcode VARCHAR(20),
    Car_Owner VARCHAR(5),
    House_Owner VARCHAR(5),
    Personal_Loan VARCHAR(5),
    Contact VARCHAR(50),
    Customer_Job VARCHAR(50),
    Income INT,
    Cust_Satisfaction_Score INT
);
drop table cc_detail;

SHOW GLOBAL VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;
LOAD DATA LOCAL INFILE 'C:/Users/trish/OneDrive/Desktop/Projects/PowerBI_Project/credit_card.csv'
INTO TABLE cc_detail
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;
-- (@wsd)
-- SET Week_Start_Date = STR_TO_DATE(TRIM(@wsd), '%d-%m-%Y');

describe cc_detail; 
WITH CTE AS (
    SELECT *, 
           ROW_NUMBER() OVER (
               PARTITION BY Client_Num,
Card_Categpry,
Annual_Fees,
Activation_30_Days,
Customer_Acq_Cost,
Week_Start_Date,
Week_Num,
Qtr,
current_year,
Credit_Limit,
Total_Revolving_Bal,
Total_Trans_Amt,
Total_Trans_Ct,
Avg_Utilization_Ratio,
Use_Chip,
Exp_Type,
Interest_Earned,
Delinquent_Acc
ORDER BY (SELECT NULL)) as row_num
    FROM cc_detail
)
DELETE FROM CTE WHERE row_num > 1;


CREATE TABLE cc_detail_temp AS 
SELECT DISTINCT * FROM cc_detail;

-- 2. Clear out the old table
TRUNCATE TABLE cc_detail;

-- 3. Move the clean data back
INSERT INTO cc_detail 
SELECT * FROM cc_detail_temp;

-- 4. Drop the temporary table
DROP TABLE cc_detail_temp;

select count(*) from cc_detail;
select * from cc_detail ;

LOAD DATA LOCAL INFILE 'C:/Users/trish/OneDrive/Desktop/Projects/PowerBI_Project/customer.csv'
INTO TABLE cust_detail
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

select * from cust_detail;
select * from  cc_detail;

TRUNCATE TABLE cc_detail;
TRUNCATE TABLE cust_detail;


-- copy additional data (week-53) in cc_detail table

LOAD DATA LOCAL INFILE 'C:/Users/trish/OneDrive/Desktop/Projects/PowerBI_Project/cust_add.csv'
INTO TABLE cust_detail
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;


LOAD DATA LOCAL INFILE 'C:/Users/trish/OneDrive/Desktop/Projects/PowerBI_Project/cc_add.csv'
INTO TABLE cc_detail
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;
