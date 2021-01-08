# DBMS-Bash-Script

## Project Notes : 

The Project aim to develop DBMS, that will enable users to store and retrieve the data from Hard-disk.

## The Project Features:
## The Application will be CLI Menu based app, that will provide user to use this Menu items:
### Main Menu:
- List Databases
- Connect To Databases
- Create Database
- Drop Database
- Rename Database
- Back up Database
- Use SQL Mode
- Exit 

### Up on user Connect to Specific Database, there will be new Screen with this Menu: 
- List Tables
- Create Table  
- Drop Table 
- Update Table 
  - Cell with PK selection
  - Multi-Row-Values with PK selection
  - Multi-Col-Values without PK selection
- Insert into Table 
  - Insert New Record Values 
  - Alter Add Column(s)
- Delete From Table  
  - Delete Entire Row with PK selection
  - Alter Drop Column
  - Truncate Table
- Select From Table
  - Select Entire Row with PK selection
  - Select Cell with PK selection
  - Select Multi-Cell with PK selection
  - Select Column without PK selection
  - All
- Display Table (Meta Data)
- Back to MainMenu 

## SQL Query Mode : 
- SQL Query mode allows the user to access the DBMS using SQL queries.
- All the SQL queries implemented are case insensitive.
- It accepts one single query per input, if the user entered multiple queries in the same line or anything else other than a single query the application will output **Invalid command**.
- The queries has to be written as will be shown below, if there is any variation in spaces will output **Invalid**.
- The first column in a table is always selected as the PRIMARY KEY for that table.
- To go back from the table mode of operations to the database mode of operation press **b** or **B**.
- To exit from SQL mode, in the database mode of operations press **q** or **Q**.
- SQL Queries implemented:

   #### **1. Create database:**
    ``` sql
    CREATE DATABASE db_name;
    ```
  #### **2. Drop database:**
    ``` sql
    DROP DATABASE db_name;
    ```
  #### **3. Show databases:**
  - Lists the available databases.
   ``` sql
   SHOW DATABASES;
   ```
  #### **4. Use database:**
  - open the database to use for table operations.
  ``` sql
  USE DATABASE;
  ```
  #### **5. Create table:**
  - There has to be atleast one column to create the table.
  ``` sql
  CREATE TABLE tbl_name (col1 dataype size, col2 dataype size);
  ```
  #### **6. Show tables:**
  - lists the avaiable tables in the currently opened database.
  ``` sql
  SHOW TABLES;
  ```
  #### **7. Drop table:**
  ``` sql
  DROP TABLE tbl_name;
  ```
  #### **8. Desc table:**
  - lists the metadata information about that table.
  ``` sql
  DESC tbl_name;
  ```
  #### **9. Select from table:**
  - select all records from a table.
  ``` sql
  SELECT * FROM tbl_name;
  ```
  - select specific columns from a table.
  ``` sql
  SELECT col1, col2 FROM tbl_name;
  ```
  - select a specific record or records.
  ``` sql
  SELECT * FROM tbl_name WHERE col = value;
  ```
  #### **10. Delete from table:**
  - deletes a specific record or records from a table;
  ``` sql
  DELETE FROM tbl_name WHERE col = value;
  ```
  #### **11. Insert into table:**
  - inserts a record in a table.
  - all the column values has to be included.
  ``` sql
  INSERT INTO tbl_name VALUES (val1, val2, val3);
  ```
  #### **12. Update table:**
  - updates the values of a certain cell or cells in a table.
  ``` sql
  UPDATE tbl_name set col1 = value1 WHERE col2 = value2;
  ```




####  Hints:
- The Database will store as Directory on Current Script Path 
- The Tables Is Store In files, which is in CSV format 
- The Database will Backed up as Directory on Current Script Path in .Tar format with DateTime Info 
- The Meta-data in the same file table .
- There is assumption that First Column is Primary Key, which used for Delete Rows.
- The Select of Rows displayed in screen/terminal in Accepted/Good Format
- Any Naming Rule (DataBase or Table or Column) must be like [ begin with Char or _ and then Char or _ or Int   ]
- Keeping track of Data Types (Digits or Strings) and Size of Each Column and Validated user input based on it on every Stage of menu 
- String DataType accept any value except ,  



### Future Plans :
- Make the App to accept GUI and make UI more fiendly 
- Enhance and add more features
