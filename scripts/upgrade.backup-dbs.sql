BACKUP DATABASE [Tfs_DefaultCollection] TO  DISK = N'C:\Data\Backup\Tfs_DefaultCollection.bak' WITH NOFORMAT, INIT,  NAME = N'Tfs_DefaultCollection-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

BACKUP DATABASE [Tfs_Configuration] TO  DISK = N'C:\Data\Backup\Tfs_Configuration.bak' WITH NOFORMAT, INIT,  NAME = N'Tfs_Configuration-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
