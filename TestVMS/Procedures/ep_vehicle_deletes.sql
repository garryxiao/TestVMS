IF OBJECT_ID ( 'ep_vehicle_deletes', 'P' ) IS NOT NULL 
    DROP PROCEDURE ep_vehicle_deletes;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ep_vehicle_deletes]
-- ================================================
--
-- View vehicle
-- 
-- ================================================
	@user_application_id int,               -- Current user id
	@ids varchar(max)                       -- Vehicle's id(s), rush solution, better replaced with table parameter
AS
BEGIN
	-- No count result returned
	SET NOCOUNT ON;

	-- Permission check if necessary

	-- Delete the items
	DELETE vehicle WHERE id IN (SELECT CAST(RTRIM(LTRIM(value)) AS int) FROM STRING_SPLIT(@ids, ','));
END
GO