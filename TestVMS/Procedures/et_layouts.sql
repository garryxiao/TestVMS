-- ================================
-- Search result columns layout
-- ================================

IF TYPE_ID ( N'et_layouts' ) IS NOT NULL 
    DROP TYPE et_layouts;
GO

CREATE TYPE dbo.et_layouts AS TABLE 
(
	id tinyint IDENTITY(1,1) NOT NULL, -- Id
	align tinyint,                     -- Text alignment
	field varchar(50) NOT NULL,        -- Data field name
	[label] nvarchar(128),             -- Label
	sort tinyint,                      -- Order index
	[type] tinyint NOT NULL,           -- Data type
	width smallint,                    -- Width
	widthmax smallint,                 -- Max width
	widthmin smallint                  -- Min width
)
GO