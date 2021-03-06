IF OBJECT_ID ( 'ep_search_get_page_json', 'P' ) IS NOT NULL 
    DROP PROCEDURE ep_search_get_page_json;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ep_search_get_page_json]
-- ================================================
--
-- Get query paging JSON dynamic SQL statement
-- 
-- ================================================
	@tables varchar(max),               -- Join tables
	@fields varchar(max),               -- Fields to read
	@key_field varchar(50),             -- Key field name
	@conditons nvarchar(max),           -- Query conditions
	@e_order_by varchar(256),           -- Order clause
	
	@e_current_page int,                -- Current page
	@e_max_per_page smallint,           -- Max per page
	@e_count_total bit = NULL,          -- Whether to read total

	@search_sql nvarchar(max) OUTPUT    -- Query SQL Command
AS
BEGIN
	-- No count result returned
	SET NOCOUNT ON;

	-- Default order
	IF @e_order_by IS NULL
		SET @e_order_by = @key_field + ' DESC';
	ELSE IF CHARINDEX(@key_field, @e_order_by) = 0
		SET @e_order_by = @e_order_by + ', ' + @key_field + ' DESC'
	
	-- The current page number is NULL or the number of records per page is NULL or 0, indicating that all data is read
	IF @e_current_page IS NULL OR @e_max_per_page IS NULL OR @e_max_per_page = 0
		BEGIN
			-- Easy way
			SET @search_sql = 'SELECT ' + @fields + ' FROM ' + @tables + ' WHERE ' + @conditons + ' ORDER BY ' + @e_order_by + ' FOR JSON PATH';
		END
	ELSE
		BEGIN
			-- Speed up the first page visit
			IF @e_current_page = 1
				BEGIN
					SET @search_sql = 'SELECT TOP ' + CAST(@e_max_per_page AS varchar(12)) + ' ' + @fields + ' FROM ' + @tables + ' WHERE ' + @conditons + ' ORDER BY ' + @e_order_by + ' FOR JSON PATH';
				END
			ELSE
				BEGIN
					DECLARE @read_records_start int = (@e_current_page - 1) * @e_max_per_page;
					SET @search_sql = 'SELECT ' + @fields + ', NULL AS ROWNUM FROM ' + @tables + ' WHERE ' + @conditons + ' ORDER BY '+ @e_order_by + ' OFFSET ' + CAST(@read_records_start AS varchar(12)) + ' ROWS FETCH NEXT ' + CAST(@e_max_per_page AS varchar(12)) + ' ROWS ONLY FOR JSON PATH'
				END
		END

	-- Combined output
	SET @search_sql = 'SELECT (' + @search_sql + ') AS items, (SELECT * FROM @layouts FOR JSON PATH) AS layouts' + IIF(@e_count_total = 1, ', (SELECT COUNT(*) FROM ' + @tables + ' WHERE ' + @conditons + ') AS records', '') + ' FOR JSON PATH, WITHOUT_ARRAY_WRAPPER'
END
GO