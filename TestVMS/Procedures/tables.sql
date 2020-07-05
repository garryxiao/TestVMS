SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fleet](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](128) NOT NULL,
	[organization_id] [int] NOT NULL,
 CONSTRAINT [PK_fleet] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vehicle](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[device_id] [uniqueidentifier] NOT NULL,
	[plate_no] [nvarchar](8) NOT NULL,
	[fleet_id] [int] NOT NULL,
	[runtime_id] [bigint] NULL,
	[creation] [datetime] NOT NULL,
	[description] [nvarchar](1280) NULL,
 CONSTRAINT [PK_vehicle] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vehicle_message](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[vehicle_id] [int] NOT NULL,
	[sender] [nvarchar](128) NOT NULL,
	[content] [nvarchar](max) NOT NULL,
	[creation] [datetime] NOT NULL,
	[sent_on] [datetime] NULL,
	[viewed_on] [datetime] NULL,
	[replied_on] [datetime] NULL,
	[deleted_on] [datetime] NULL,
 CONSTRAINT [PK_vehicle_message] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vehicle_runtime](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[vehicle_id] [int] NOT NULL,
	[location] [geography] NULL,
	[speeed] [tinyint] NULL,
	[temperature] [decimal](3, 1) NULL,
	[pressure] [smallint] NULL,
	[creation] [datetime] NOT NULL,
 CONSTRAINT [PK_vehicle_runtime] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_fleet] ON [dbo].[fleet]
(
	[organization_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_vehicle] ON [dbo].[vehicle]
(
	[device_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_vehicle_1] ON [dbo].[vehicle]
(
	[fleet_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_vehicle_2] ON [dbo].[vehicle]
(
	[plate_no] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_vehicle_3] ON [dbo].[vehicle]
(
	[runtime_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_vehicle_message] ON [dbo].[vehicle_message]
(
	[vehicle_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_vehicle_message_1] ON [dbo].[vehicle_message]
(
	[sent_on] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_vehicle_message_2] ON [dbo].[vehicle_message]
(
	[viewed_on] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_vehicle_message_3] ON [dbo].[vehicle_message]
(
	[replied_on] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_vehicle_message_4] ON [dbo].[vehicle_message]
(
	[deleted_on] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_vehicle_runtime] ON [dbo].[vehicle_runtime]
(
	[vehicle_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[vehicle] ADD  CONSTRAINT [DF_vehicle_creation]  DEFAULT (getdate()) FOR [creation]
GO
ALTER TABLE [dbo].[vehicle_message] ADD  CONSTRAINT [DF_vehicle_message_creation]  DEFAULT (getdate()) FOR [creation]
GO
ALTER TABLE [dbo].[vehicle_runtime] ADD  CONSTRAINT [DF_vehicle_runtime_creation]  DEFAULT (getdate()) FOR [creation]
GO
ALTER TABLE [dbo].[vehicle]  WITH CHECK ADD  CONSTRAINT [FK_vehicle_fleet] FOREIGN KEY([fleet_id])
REFERENCES [dbo].[fleet] ([id])
GO
ALTER TABLE [dbo].[vehicle] CHECK CONSTRAINT [FK_vehicle_fleet]
GO
ALTER TABLE [dbo].[vehicle]  WITH CHECK ADD  CONSTRAINT [FK_vehicle_vehicle_runtime] FOREIGN KEY([runtime_id])
REFERENCES [dbo].[vehicle_runtime] ([id])
GO
ALTER TABLE [dbo].[vehicle] CHECK CONSTRAINT [FK_vehicle_vehicle_runtime]
GO
ALTER TABLE [dbo].[vehicle_message]  WITH CHECK ADD  CONSTRAINT [FK_vehicle_message_vehicle] FOREIGN KEY([vehicle_id])
REFERENCES [dbo].[vehicle] ([id])
GO
ALTER TABLE [dbo].[vehicle_message] CHECK CONSTRAINT [FK_vehicle_message_vehicle]
GO
ALTER TABLE [dbo].[vehicle_runtime]  WITH CHECK ADD  CONSTRAINT [FK_vehicle_runtime_vehicle] FOREIGN KEY([vehicle_id])
REFERENCES [dbo].[vehicle] ([id])
GO
ALTER TABLE [dbo].[vehicle_runtime] CHECK CONSTRAINT [FK_vehicle_runtime_vehicle]
GO