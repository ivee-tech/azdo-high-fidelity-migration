/*
This script moves the tempdb files to Z: drive.
RUN EACH STEP SEPARATELY AND VERIFY IF THE EXECUTION SUCCEEDED.
For more information, see this link:
https://docs.microsoft.com/en-au/azure/devops/articles/migration-import?utm_source=ms&utm_medium=guide&utm_campaign=vstsdataimportguide&view=vsts#importing-large-collections
*/

-- Determine the logical file names of the tempdb database and their current location on the disk.
SELECT name, physical_name AS CurrentLocation  
FROM sys.master_files  
WHERE database_id = DB_ID(N'tempdb');  
GO 

-- Create the SQLData and SQLLog directories on Z: drive (in command prompt or PowerShell console)
/*
md Z:\SQLData
md Z:\SQLLog
*/

-- Change the location of each file by using ALTER DATABASE.
USE master;
GO  
ALTER DATABASE tempdb   
MODIFY FILE (NAME = tempdev, FILENAME = 'Z:\SQLData\tempdb.mdf');  
GO  
ALTER DATABASE tempdb   
MODIFY FILE (NAME = templog, FILENAME = 'Z:\SQLLog\templog.ldf');  
GO  

-- Stop and restart the instance of SQL Server (in command prompt or PowerShell console)
/*
for default instance
NET STOP MSSQLSERVER
NET START MSSQLSERVER

for named instance
NET STOP MSSQL$instancename
NET START MSSQL$instancename

*/
-- Verify the file change.

SELECT name, physical_name AS CurrentLocation, state_desc  
FROM sys.master_files  
WHERE database_id = DB_ID(N'tempdb');  


-- Delete the tempdb.mdf and templog.ldf files from the original location.
