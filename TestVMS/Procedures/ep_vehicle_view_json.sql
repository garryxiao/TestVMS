IF OBJECT_ID ( 'ep_vehicle_view_json', 'P' ) IS NOT NULL 
    DROP PROCEDURE ep_vehicle_view_json;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ep_vehicle_view_json]
-- ================================================
--
-- View vehicle
-- 
-- ================================================
	@user_application_id int,               -- Current user id
	@id int                                 -- Vehicle's id
AS
BEGIN
	-- No count result returned
	SET NOCOUNT ON;

	-- Permission check if necessary

	-- Return view data
	SELECT
		device_id,
		plate_no,
		description,
		creation
	FROM vehicle
		WHERE id = @id
	FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;
END
GO