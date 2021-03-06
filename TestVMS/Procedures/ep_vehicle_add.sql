IF OBJECT_ID ( 'ep_vehicle_add', 'P' ) IS NOT NULL 
    DROP PROCEDURE ep_vehicle_add;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ep_vehicle_add]
-- ================================================
--
-- Add a vehicle
-- 
-- ================================================
	@user_application_id int,               -- Current user id

	@device_id uniqueidentifier,            -- Device id
	@plate_no nvarchar(8),                  -- Plate no.
	@fleet_id int = NULL,                   -- Fleet id
	@description nvarchar(1280) = NULL      -- Description
AS
BEGIN
	-- No count result returned
	SET NOCOUNT ON;

	-- Permission check if necessary

	-- Unique plate no. check
	IF EXISTS (SELECT * FROM vehicle WHERE plate_no = @plate_no)
		BEGIN
			SELECT -1 AS error_code, 'plate_no' AS field, 'The plate no. exists' AS [message], 'id_have' AS m_id;
			RETURN;
		END

	-- Unique device id check
	IF EXISTS (SELECT * FROM vehicle WHERE device_id = @device_id)
		BEGIN
			SELECT -1 AS error_code, 'device_id' AS field, 'The device id exists' AS [message], 'id_have' AS m_id;
			RETURN;
		END
	
	-- Create fleet if necessary
	IF @fleet_id IS NULL
		BEGIN
			-- Try to read one
			SELECT @fleet_id = id FROM fleet ORDER BY id DESC;
			IF @fleet_id IS NULL
				BEGIN
					-- Fleet id table
					DECLARE @fleetTable TABLE(id int);

					-- Insert a fleet
					INSERT fleet(name, organization_id)
						OUTPUT inserted.id INTO @fleetTable
					VALUES('Default fleet', 1);

					-- Get the inserted fleet id
					SELECT @fleet_id = id FROM @fleetTable;
				END
		END

	-- Id table
	DECLARE @idTable TABLE(id int);

	-- Insert
	INSERT vehicle (device_id, plate_no, fleet_id, description)
		OUTPUT inserted.id INTO @idTable
	VALUES(@device_id, UPPER(@plate_no), @fleet_id, @description);

	-- New device id
	DECLARE @id int;
	SELECT @id = id FROM @idTable;

	-- Return
	SELECT 0 AS error_code, @id AS id;
END
GO