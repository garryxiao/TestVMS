-- ================================
-- Order field item
-- ================================

IF TYPE_ID ( N'et_order_fields' ) IS NOT NULL 
    DROP TYPE et_order_fields;
GO

CREATE TYPE dbo.et_order_fields AS TABLE 
(
	id tinyint IDENTITY(1,1) PRIMARY KEY CLUSTERED, -- Row id
	field varchar(256)                              -- Field, for example 'name' or 'name *, birthday *' or 'birthday ASC, name *'
)
GO