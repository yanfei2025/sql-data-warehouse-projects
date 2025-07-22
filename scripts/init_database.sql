/*
===============================================================
Create Database and Schemas
===============================================================
Script Purpose:
This script creates a new database named 'Datawarehouse' after checking if it already exists.
If the database exists, it is dropped and recreated. Additionally the script sets up three schemas
within the database:'bronze','silver', and 'gold'.

WARNING:
Running this script will drop the entire 'Datawarehouse' database if it exists.
All data in the database will be permanently deleted. Proceed with caution 
and ensure you have proper backups before running this script.
*/

--Create Database 'Data Warehouse'

USE master;
GO

--Drop and recreate the 'Datawarehouse' database
IF EXISTS(SELECT 1 FROM sys.database WHERE name = 'Datawarehouse')
BEGIN
   ALTER Database Datawarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
   DROP Database Datawarehouse;
END;
GO

CREATE DATABASE Datawarehouse;
GO

USE Datawarehouse;
GO

--Create the Schemas

CREATE SCHEMA Bronze;
GO
CREATE SCHEMA Silver;
GO
CREATE SCHEMA Gold;
GO
