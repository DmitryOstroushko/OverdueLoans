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

2. To create the table: just run the SQL script from the file [CreateTable.sql](https://github.com/DmitryOstroushko/OverdueLoans/blob/main/CreateTable.sql).  
In the case the table PDCL will be dropped from a server if exists and then will be created again with required structure.  

3. To fill the table with data: just run the SQL script from the file [TableData.sql](https://github.com/DmitryOstroushko/OverdueLoans/blob/main/TableData.sql).  
After that the table PDCL will be filled with tha data.  

4. To get a report: just run the SQL script from the file [GetOverdueLoans.sql](https://github.com/DmitryOstroushko/OverdueLoans/blob/main/GetOverdueLoans.sql).  
As a result (for the example above) the script creates a table below:  


|  Deal  | AfterCurrentRowAmount | RunningOverdue | OverduePeriod |  
|:--------:|-----------------------:|:----------------:|---------------:|  
|111111|6900 |2009-12-12|4033 |  
|222221|5000 |2009-12-20|4025 |   

This project is a very simple. However it includes a number of useful features: Organize Complex Queries (WITH) and Window Functions with a condition.  
