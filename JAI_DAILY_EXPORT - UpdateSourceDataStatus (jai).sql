-- ========================================
-- Run this on the repossess_jai database
-- ========================================
USE [repossess_jai]
GO

-- Step 1: Create the User-Defined Table Type
IF EXISTS (SELECT * FROM sys.types WHERE is_table_type = 1 AND name = 'IdList' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    DROP TYPE dbo.IdList;
END
GO

CREATE TYPE dbo.IdList AS TABLE
(
    ID BIGINT NOT NULL
);
GO

-- Step 2: Create the stored procedure
CREATE OR ALTER PROCEDURE [dbo].[usp_UpdateSourceDataStatus]
    @TableName NVARCHAR(255),
    @PkColumnName NVARCHAR(255),
    @Status INT,
    @Ids dbo.IdList READONLY
AS
BEGIN
    SET NOCOUNT ON;

    -- Exit if there are no IDs to process
    IF NOT EXISTS (SELECT 1 FROM @Ids)
    BEGIN
        RETURN;
    END

    -- Build the dynamic SQL UPDATE statement
    DECLARE @sql NVARCHAR(MAX);
    SET @sql = N'UPDATE ' + QUOTENAME(@TableName) +
               N' SET Status_code = @Status, ' +
               N' exported_date = CASE WHEN @Status = 2210 THEN GETDATE() ELSE exported_date END, ' +
               N' sent_date = CASE WHEN @Status = 2220 THEN GETDATE() ELSE sent_date END ' +
               N' WHERE ' + QUOTENAME(@PkColumnName) + N' IN (SELECT ID FROM @Ids);';

    -- Execute the dynamic SQL
    EXEC sp_executesql @sql,
        N'@Status INT, @Ids dbo.IdList READONLY',
        @Status = @Status,
        @Ids = @Ids;
END
GO
