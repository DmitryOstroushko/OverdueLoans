# OverdueLoans

## About project
This repository includes three 'sql' files:  
  1. [CreateTable.sql](https://github.com/DmitryOstroushko/OverdueLoans/blob/main/CreateTable.sql) ia s script to create a table PDCL with required structure.  
  2. [TableData.sql](https://github.com/DmitryOstroushko/OverdueLoans/blob/main/TableData.sql) is a script to add data into the table PDCL.  
  3. [GetOverdueLoans.sql](https://github.com/DmitryOstroushko/OverdueLoans/blob/main/GetOverdueLoans.sql) - is a script to get result table about overdue loans.  

## How it works
To get result you should to login on your SQL server and then to run the SQL scripts consequentially: [CreateTable.sql](https://github.com/DmitryOstroushko/OverdueLoans/blob/main/CreateTable.sql), [TableData.sql](https://github.com/DmitryOstroushko/OverdueLoans/blob/main/TableData.sql), [GetOverdueLoans.sql](https://github.com/DmitryOstroushko/OverdueLoans/blob/main/GetOverdueLoans.sql).  

There is an example for PostrgeSQL server:  

1. To login the server for username `clianne`:  

sudo -u clianne psql  

2. To create the table:  

DROP TABLE IF EXISTS PDCL;  
CREATE TABLE IF NOT EXISTS PDCL  
(  
    Date DATE,  
    Customer INT,  
    Deal INT,  
    Currency VARCHAR(3),  
    Sum FLOAT  
);  

3. To fill the table with data:  

INSERT INTO PDCL(Date,Customer,Deal,Currency,Sum) VALUES('12.12.2009',111110,111111,'RUR',12000);  
INSERT INTO PDCL(Date,Customer,Deal,Currency,Sum) VALUES('25.12.2009',111110,111111,'RUR',5000);  
INSERT INTO PDCL(Date,Customer,Deal,Currency,Sum) VALUES('12.12.2009',111110,122222,'RUR',10000);  
INSERT INTO PDCL(Date,Customer,Deal,Currency,Sum) VALUES('12.01.2010',111110,111111,'RUR',-10100);  
INSERT INTO PDCL(Date,Customer,Deal,Currency,Sum) VALUES('20.11.2009',220000,222221,'RUR',25000);  
INSERT INTO PDCL(Date,Customer,Deal,Currency,Sum) VALUES('20.12.2009',220000,222221,'RUR',20000);  
INSERT INTO PDCL(Date,Customer,Deal,Currency,Sum) VALUES('31.12.2009',220001,222221,'RUR',-10000);  
INSERT INTO PDCL(Date,Customer,Deal,Currency,Sum) VALUES('29.12.2009',111110,122222,'RUR',-10000);  
INSERT INTO PDCL(Date,Customer,Deal,Currency,Sum) VALUES('27.11.2009',220001,222221,'RUR',-30000);  


4. To get a report:  

WITH transactions AS (
  SELECT tmptab.Deal, tmptab.Date, tmptab.Sum, tmptab.AfterCurrentRowAmount, tmptab.RowNum,
	CASE
          WHEN (
            COALESCE (
              LAG(tmptab.AfterCurrentRowAmount) OVER (PARTITION BY tmptab.Deal ORDER BY tmptab.Deal, tmptab.Date), 0) <= 0
          ) THEN tmptab.Date
          ELSE NULL
        END AS OverDueDate
  FROM (
      SELECT PDCL.Deal, PDCL.Date, PDCL.Sum,
	SUM(PDCL.Sum) OVER (PARTITION BY Deal ORDER BY Date) AS AfterCurrentRowAmount,
	ROW_NUMBER() OVER (PARTITION BY Deal ORDER BY Date DESC) AS RowNum
      FROM PDCL
    ) tmptab
)
SELECT *, date_part('day', current_timestamp - final_tbl.RunningOverDue::timestamp) OverDuePeriod
FROM (
SELECT transwrk.Deal, transwrk.AfterCurrentRowAmount,
  CASE
      WHEN transwrk.OverDueDate IS NOT NULL THEN transwrk.OverDueDate
      WHEN transwrk.AfterCurrentRowAmount <= 0 THEN NULL
      ELSE (SELECT max(tmptab_2.OverDueDate)
              FROM transactions tmptab_2
              WHERE transwrk.Deal = tmptab_2.Deal
                AND tmptab_2.Date <= transwrk.Date
            )
      END AS RunningOverDue
FROM transactions transwrk
WHERE transwrk.RowNum = 1
  AND transwrk.AfterCurrentRowAmount <> 0
ORDER BY transwrk.Deal, transwrk.Date) AS final_tbl;



This project is a very simple one with simultaneously 
