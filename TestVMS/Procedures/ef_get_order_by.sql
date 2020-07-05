-- ================================================
--
-- Get order field
--
-- ================================================
IF OBJECT_ID ( 'ef_get_order_by', 'FN' ) IS NOT NULL 
    DROP FUNCTION ef_get_order_by;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION dbo.ef_get_order_by 
(
	@fields AS dbo.et_order_fields READONLY,   -- Sort fields
	@order_index smallint                      -- Field index
)
RETURNS varchar(256)
WITH SCHEMABINDING AS
BEGIN
	IF @order_index IS NULL OR @order_index = 0
		RETURN NULL;

	DECLARE @field varchar(256);
	SELECT @field = field FROM @fields WHERE id = ABS(@order_index);

	IF @field IS NOT NULL
		BEGIN
			DECLARE @flag varchar(4) = IIF(@order_index > 0, 'ASC', 'DESC');
			IF CHARINDEX('*', @field) > 0 OR CHARINDEX(',', @field) > 0
				SET @field = REPLACE(@field, '*', @flag);
			ELSE
				SET @field = @field + ' ' + @flag;

			RETURN @field;
		END

	RETURN NULL;
END