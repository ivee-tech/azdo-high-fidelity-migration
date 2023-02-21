
/*
This script creates the TFS <collection> DB and restores the backup and transaction log files.
The backup file is <backup file name>
RUN EACH STEP SEPARATELY AND VERIFY IF THE EXECUTION SUCCEEDED.
*/

-- Create Tfs_<collection> DB
USE master;
GO  
CREATE DATABASE Tfs_Configuration  
ON   
(NAME = Tfs_Configuration_data,  
    FILENAME = 'C:\Data\TFS\Tfs_Configuration.mdf',  
    SIZE = 10,  
    MAXSIZE = 50,  
    FILEGROWTH = 5)
LOG ON
(NAME = Tfs_Configuration_log,  
    FILENAME = 'C:\Data\TFS\Tfs_Configuration.ldf',  
    SIZE = 5MB,  
    MAXSIZE = 25MB,  
    FILEGROWTH = 5MB);
GO  


-- Get the backup file list to be used for RESTORE 
RESTORE FILELISTONLY FROM DISK = 'C:\Data\Backup\Tfs_Configuration.bak' 

-- Restore backup (change the script to use the correct files)

RESTORE DATABASE Tfs_Configuration FROM DISK = 'C:\Data\Backup\Tfs_Configuration.bak' WITH NORECOVERY, 
      MOVE 'Tfs_Configuration' TO 'C:\Data\TFS\Tfs_Configuration.mdf',
      MOVE 'Tfs_Configuration_log' TO 'C:\Data\TFS\Tfs_Configuration.ldf',
      REPLACE
GO


-- Recover DB

RESTORE DATABASE Tfs_Configuration WITH RECOVERY
GO




