IF OBJECT_ID ( 'ep_vehicle_edit', 'P' ) IS NOT NULL 
    DROP PROCEDURE ep_vehicle_edit;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ep_vehicle_edit]
-- ================================================
--
-- Edit vehicle
-- 
-- ================================================
	@user_application_id int,               -- Current user id

	@id int,                                -- Vehicle's id
	@device_id uniqueidentifier = NULL,     -- Device id
	@plate_no nvarchar(8) = NULL,           -- Plate no.
	@fleet_id int = NULL,                   -- Fleet id
	@description nvarchar(1280) = NULL      -- Description
AS
BEGIN
	-- No count result returned
	SET NOCOUNT ON;

	-- Permission check if necessary

	-- Unique plate no. check
	IF @plate_no IS NOT NULL AND EXISTS (SELECT * FROM vehicle WHERE id <> @id AND plate_no = @plate_no)
		BEGIN
			SELECT -1 AS error_code, 'plate_no' AS field, 'The plate no. exists' AS [message], 'id_have' AS m_id;
			RETURN;
		END

	-- Unique device id check
	IF @device_id IS NOT NULL AND EXISTS (SELECT * FROM vehicle WHERE id <> @id AND device_id = @device_id)
		BEGIN
			SELECT -1 AS error_code, 'device_id' AS field, 'The device id exists' AS [message], 'id_have' AS m_id;
			RETURN;
		END

	-- Update fields seperately
	IF LEN(@plate_no) > 0
		UPDATE vehicle SET plate_no = @plate_no WHERE id = @id AND plate_no <> @plate_no;

	IF LEN(@device_id) > 0
		UPDATE vehicle SET device_id = @device_id WHERE id = @id AND device_id <> @device_id;

	IF @description IS NOT NULL
		BEGIN
			IF @description = ''
				UPDATE vehicle SET description = NULL WHERE id = @id AND description IS NOT NULL;
			ELSE
				UPDATE vehicle SET description = @description WHERE id = @id AND (description IS NULL OR description <> @description);
		END

	-- Return
	SELECT 0 AS error_code, @id AS id;
END
GO