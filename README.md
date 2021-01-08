# DBMS-Bash-Script

## Project Notes : 

The Project aim to develop DBMS, that will enable users to store and retrieve the data from Hard-disk.

## The Project Features:
## The Application will be CLI Menu based app, that will provide to user this Menu items:
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
        - with Column (Name + DataType ( int ot string ) + Size) and PK in the 1st Column (Default)
- Drop Table
- Updata Table
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

### SQL Mode : 
-


####  Hints:
- The Database will store as Directory on Current Script Path 
- The Tables Is Store In files, which is in CSV format 
- The Database will Backed up as Directory on Current Script Path in .Tar format with DateTime Info 
- The Meta-data in the same file table .
- There is assumption that First Column is Primary Key, which used for Delete Rows.
- The Select of Rows displayed in screen/terminal in Accepted/Good Format
- Any Naming Rule (DataBase or Table or Column) must be like [ begin with Char or _ and then Char or Int or _  ]
- Keeping track of Data Types (Digits or Strings) and Size of Each Column and Validated user input based on it on every Stage of menu 
- String DataType accept any value except ,  



### Future Plans :
- Make the App to accept GUI and make UI more fiendly 
- Enhance and add more features
