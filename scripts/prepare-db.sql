/*
This script prepares the collection DB for import.
The following steps are performed:
 - set the DB recovery mode to SIMPLE
 - create user TfsImport and add it to TFSEXECROLE -> this user is required in the import connection string

Run each step individually.

*/

ALTER DATABASE [Tfs_<collection>] SET RECOVERY SIMPLE;
GO


USE [Tfs_<collection>]
CREATE LOGIN TfsImport WITH PASSWORD = '<password>'
CREATE USER TfsImport FOR LOGIN TfsImport WITH DEFAULT_SCHEMA=[dbo]
EXEC sp_addrolemember @rolename='TFSEXECROLE', @membername='TfsImport'
GO

