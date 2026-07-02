/* 
Creation of Database & Schemas

WARNING: Running this script will drop the DB 'DataWarehouse' if it already exists. 
All data in the DB will be deleted permanently. Proceed with caution and ensure
you have backups before running this script.
*/

USE master;
GO

--Drop & Recreate 'DataWarehouse' database.

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO

--Creation of 'DataWarehouse' Database

CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

--Creation of layer schemas

CREATE SCHEMA bronze_layer;
GO

CREATE SCHEMA silver_layer;
GO

CREATE SCHEMA gold_layer;
GO
