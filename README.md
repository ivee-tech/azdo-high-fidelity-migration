# Introduction
## Overview
This document highlights the main steps required for TFS to Azure DevOps Services migration.
This summary plan is based on the TFS to Azure DevOps Services Migration Guide, available here: 
[https://www.microsoft.com/en-us/download/confirmation.aspx?id=54274](https://www.microsoft.com/en-us/download/confirmation.aspx?id=54274)
The following assumptions have been made:
 - Data Centre selected
 - Visual Studio subscriptions / licences are available
 - TFS Migrator tool is available and the migrators are familiar with it
 - The desired Azure DevOps Services organisation name has been reserved* 
 - An Azure AD tenant is available for organisation
 - Azure AD synchronisation with the on-premises environment is implemented
 - Optionally, but highly recommended, Multi-Factor Authentication and Conditional Access is enabled for the team
 - TFS Upgraded to Azure DevOps Server 2019.X
Code does not contain sensitive information, such as passwords in clear-text**
* The import of a TFS collection will always create a new organisation, which can be renamed post-import; for example, if the reserved organisation is XYZ, with the URL https://dev.azure.com/XYZ, the organisation used for migration can be something like XYZ-temp, then renamed to XYZ after the import is successful.
** If this is the case, it is highly recommended to use dedicated tools like Azure Key Vault to store encryption keys, secrets and certificates.


## Migration Steps
### Summary of migration steps
The following main steps are required for import:
Validate TFS Server
 - Run validation using the TFS migrator tool
 - Review logs and fix errors
 - Repeat validation checks
Get Ready for Import
 - Assign, activate, and map Azure DevOps Services subscriptions
 - Generate import settings
 - Provide the configurable settings
 - Review the Identity Map log file
 - Create an Azure Storage Container in the same selected Data Centre
Import
 - Dry-run of end-to-end import
 - Detach the team project collection
 - Create portable backup
 - Upload SQL database backup*
 - Generate SAS key for Azure Storage container and use it in the import settings file**
 - Delete previously dry-run organisations
 - Rename imported organisation
 - Set-up billing***
 - Reconnect build and deployment servers to new organisation
* Depending on the collection size, there are two options to import the collection database:
 1. using a DACPAC file, if the size is less than 30 GB;
 2. setup a separate SQL Server in the selected Data Centre, restore the DB there and update the import settings with the corresponding connection string
** Treat SAS (Shared-Access Signature) key as a secret, preferably stored in Azure Key Vault.
*** This step is required for marketplace extensions, like Code Search, Package Management, Test & Feedback, etc.
