BACKUP DATABASE [Tfs_<collection>] TO  DISK = N'<Backup file path>' WITH NOFORMAT, INIT,  NAME = N'Full Database Backup Name', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
