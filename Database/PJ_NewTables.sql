USE [PJ]
GO

/****** Object:  Table [dbo].[ProductGroup]    Script Date: 04/10/2014 22:43:47 ******/
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

/****** Object:  Table [dbo].[Dealer]    Script Date: 04/10/2014 22:43:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Dealer](
	[DealerId] [int] IDENTITY(1,1) NOT NULL,
	[DealerName] [varchar](50) NOT NULL,
	[CompanyName] [varchar](50) NOT NULL,
	[CompanyShortForm] [varchar](10) NULL,
	[Address] [varchar](500) NULL,
	[City] [varchar](20) NULL,
	[State] [varchar](20) NULL,
	[PinCode] [varchar](6) NULL,
	[CompanyVATOrTinNo] [varchar](20) NULL,
 CONSTRAINT [PK_Dealer] PRIMARY KEY CLUSTERED 
(
	[DealerId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


