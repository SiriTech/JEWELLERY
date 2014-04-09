USE [PJ]
GO
/****** Object:  Table [dbo].[ProductGroup]    Script Date: 04/09/2014 09:28:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductGroup]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ProductGroup](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductGroup] [varchar](100) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[EditedBy] [int] NULL,
	[EditedDate] [datetime] NULL,
	[Status] [bit] NULL,
 CONSTRAINT [PK_ProductGroup] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[ProductGroup] ON
INSERT [dbo].[ProductGroup] ([Id], [ProductGroup], [CreatedBy], [CreatedDate], [EditedBy], [EditedDate], [Status]) VALUES (1, N'Test', 1, CAST(0x0000A30800000000 AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[ProductGroup] OFF
