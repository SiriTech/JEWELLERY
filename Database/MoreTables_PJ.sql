

/****** Object:  Table [dbo].[ProductCategory]    Script Date: 04/16/2014 23:32:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ProductCategory](
	[ProductCategoryId] [int] IDENTITY(1,1) NOT NULL,
	[ProductCategoryName] [varchar](30) NOT NULL,
 CONSTRAINT [PK_ProductCategory] PRIMARY KEY CLUSTERED 
(
	[ProductCategoryId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

/****** Object:  Table [dbo].[ProductGroup]    Script Date: 04/16/2014 23:32:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ProductGroup](
	[ProductGroupId] [int] IDENTITY(1,1) NOT NULL,
	[ProductGroupName] [varchar](20) NOT NULL,
	[DisplayName] [nvarchar](20) NULL,
 CONSTRAINT [PK_ProductGroup] PRIMARY KEY CLUSTERED 
(
	[ProductGroupId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


/****** Object:  Table [dbo].[Product]    Script Date: 04/16/2014 23:33:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Product](
	[ProductId] [bigint] IDENTITY(1,1) NOT NULL,
	[ProductName] [varchar](40) NOT NULL,
	[ShortForm] [varchar](10) NOT NULL,
	[ValueAddedByPerc] [decimal](18, 3) NULL,
	[ValueAddedFixed] [decimal](18, 3) NULL,
	[MakingChargesPerGram] [decimal](18, 3) NULL,
	[MakingChargesFixed] [decimal](18, 3) NULL,
	[IsStone] [bit] NOT NULL,
	[IsWeightless] [bit] NOT NULL,
	[ProductCategoryId] [int] NOT NULL,
	[ProductGroupId] [int] NOT NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_ProductCategory] FOREIGN KEY([ProductCategoryId])
REFERENCES [dbo].[ProductCategory] ([ProductCategoryId])
GO

ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [FK_Product_ProductCategory]
GO

ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_ProductGroup] FOREIGN KEY([ProductGroupId])
REFERENCES [dbo].[ProductGroup] ([ProductGroupId])
GO

ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [FK_Product_ProductGroup]
GO

ALTER TABLE [dbo].[Product] ADD  CONSTRAINT [DF_Product_IsStone]  DEFAULT ((0)) FOR [IsStone]
GO

ALTER TABLE [dbo].[Product] ADD  CONSTRAINT [DF_Product_IsWeightless]  DEFAULT ((0)) FOR [IsWeightless]
GO




/****** Object:  Table [dbo].[Stone]    Script Date: 04/16/2014 23:31:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Stone](
	[StoneId] [int] IDENTITY(1,1) NOT NULL,
	[StoneName] [varchar](30) NOT NULL,
	[StoneShortForm] [varchar](10) NOT NULL,
	[StonePerCarat] [int] NOT NULL,
	[IsStoneWeightless] [bit] NOT NULL,
 CONSTRAINT [PK_Stone] PRIMARY KEY CLUSTERED 
(
	[StoneId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Stone] ADD  CONSTRAINT [DF_Stone_IsStoneWeightless]  DEFAULT ((0)) FOR [IsStoneWeightless]
GO



/****** Object:  Table [dbo].[Customer]    Script Date: 04/16/2014 23:34:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Customer](
	[CustomerId] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerNumber] [nvarchar](12) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[MiddleName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[Address] [nvarchar](300) NOT NULL,
	[ContactNo] [nvarchar](50) NULL,
	[State] [nvarchar](50) NULL,
	[City] [nvarchar](50) NULL,
	[Pincode] [nvarchar](10) NULL,
	[TierId] [int] NULL,
	[IsPending] [bit] NULL,
	[ImagePath] [nvarchar](50) NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Customer] ADD  CONSTRAINT [DF_Customer_IsPending]  DEFAULT ((0)) FOR [IsPending]
GO