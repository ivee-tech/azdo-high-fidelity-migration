
/*
This script creates the TFS <collection> DB and restores the backup and transaction log files.
The backup file is <backup file name>
RUN EACH STEP SEPARATELY AND VERIFY IF THE EXECUTION SUCCEEDED.
*/

-- Create Tfs_<collection> DB
USE master;
GO  
CREATE DATABASE Tfs_<collection>  
ON   
(NAME = Tfs_<collection>_data,  
    FILENAME = 'C:\Data\TFS\Tfs_<collection>.mdf',  
    SIZE = 10,  
    MAXSIZE = 50,  
    FILEGROWTH = 5)
LOG ON
(NAME = Tfs_<collection>_log,  
    FILENAME = 'C:\Data\TFS\Tfs_<collection>.ldf',  
    SIZE = 5MB,  
    MAXSIZE = 25MB,  
    FILEGROWTH = 5MB);
GO  


-- Get the backup file list to be used for RESTORE 
RESTORE FILELISTONLY FROM DISK = 'C:\Data\Backups\Tfs_<collection>.bak' 

-- Restore backup (change the script to use the correct files)

RESTORE DATABASE Tfs_<collection> FROM DISK = 'C:\Data\Backups\Tfs_<collection>.bak' WITH NORECOVERY, 
      MOVE 'Tfs_<collection>' TO 'C:\Data\TFS\Tfs_<collection>.mdf',
      MOVE 'Tfs_<collection>_log' TO 'C:\Data\TFS\Tfs_<collection>.ldf',
      REPLACE
GO


-- Recover DB

RESTORE DATABASE Tfs_<collection> WITH RECOVERY
GO




