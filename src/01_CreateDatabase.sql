--------------------------------------------------------------------------------
-- 01_CreateDatabase.sql
-- Creates the SqlPipelineDemo database if it does not already exist.
-- Idempotent: safe to run multiple times.
--------------------------------------------------------------------------------
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'SqlPipelineDemo')
BEGIN
    CREATE DATABASE [SqlPipelineDemo]
    COLLATE SQL_Latin1_General_CP1_CI_AS;
END
GO

--------------------------------------------------------------------------------
-- Switch to the new database so all subsequent objects are created there.
--------------------------------------------------------------------------------
USE [SqlPipelineDemo]
GO
