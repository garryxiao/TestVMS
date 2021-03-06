IF OBJECT_ID ( 'ep_vehicle_search_json', 'P' ) IS NOT NULL 
    DROP PROCEDURE ep_vehicle_search_json;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ep_vehicle_search_json]
-- ================================================
--
-- Search vehicle
-- 
-- ================================================
	@user_application_id int,               -- Current user id

	@id int = NULL,                         -- Entity id

	@e_order_index smallint = NULL,         -- Order field index. Positive numbers indicate ascending order, negative numbers indicate descending order
	@e_field varchar(30) = NULL,            -- View fields model
	@e_sc nvarchar(50) = NULL,              -- Fuzzy query condition
	@e_current_page int = 1,                -- Current page
	@e_max_per_page smallint = 8,           -- Records per page
	@e_count_total bit = NULL,              -- Whether to read the total
	@e_has_layout bit = NULL                -- Whether to provide layout definition
AS
BEGIN
	-- No count result returned
	SET NOCOUNT ON;

	-- Permission check if necessary
	
	-- Join SQL Command
	DECLARE @sql nvarchar(max) = '1 = 1';

	IF @e_sc IS NOT NULL AND @id IS NULL
		BEGIN
			IF ISNUMERIC(@e_sc) = 1
				SET @e_sc = ' AND v.id = @e_sc';
			ELSE
				BEGIN
					SET @e_sc = '%' + @e_sc + '%';
					SET @sql = @sql + ' AND (v.plate_no LIKE @e_sc OR v.description LIKE @e_sc)';
				END
		END

	-- Tables
	DECLARE @tables nvarchar(max) = 'vehicle AS v'

	-- Fields
	DECLARE @fields nvarchar(max) = 'v.id, v.device_id, v.plate_no, v.description, CONVERT(varchar(20), v.creation, 111) AS creation';

	-- Sort fields
	DECLARE @orderFields AS et_order_fields;
	INSERT @orderFields(field) VALUES('v.plate_no'), ('v.id');

	-- Layouts
	DECLARE @layouts AS et_layouts;
	IF @e_has_layout = 1
		INSERT @layouts (align, [field], [label], sort, [type], width, widthmax, widthmin) VALUES(NULL, 'plate_no', NULL, 0, 1, NULL, 120, 100),
			(NULL, 'device_id', NULL, NULL, 1, 320, NULL, NULL),
			(NULL, 'description', NULL, NULL, 1, NULL, NULL, NULL),
			(NULL, 'creation', NULL, 1, 5, 128, NULL, NULL)

	-- Calculate order by clause
	DECLARE @e_order_by varchar(256) = dbo.ef_get_order_by(@orderFields, @e_order_index);

	-- Generate SQL command
	DECLARE @search_sql nvarchar(max);
	EXEC ep_search_get_page_json
		@tables,
		@fields,
		'v.id',
		@sql,
		@e_order_by,
				
		@e_current_page,
		@e_max_per_page,
		@e_count_total,
	
		@search_sql OUTPUT
	;

	-- Parameters
	DECLARE @parameters nvarchar(max) = '@layouts AS et_layouts READONLY, @e_sc nvarchar(50)';

	-- Execution
	EXECUTE sp_executesql @search_sql, @parameters, @layouts, @e_sc;
END
GO