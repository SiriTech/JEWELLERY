USE [PJ]
GO

/****** Object:  Table [dbo].[Barcode]    Script Date: 04/27/2014 01:20:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Barcode](
	[BarcodeId] [int] IDENTITY(10000,1) NOT NULL,
	[BarcodeNumber] [int] NOT NULL,
	[LotId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[NoOfPieces] [int] NOT NULL,
	[NetWeight] [decimal](18, 2) NOT NULL,
	[GrossWeight] [decimal](18, 2) NOT NULL,
	[WeightMeasure] [char](2) NOT NULL,
	[Price] [decimal](18, 0) NOT NULL,
	[IsSubmitted] [bit] NOT NULL,
	[Notes] [varchar](100) NULL,
 CONSTRAINT [PK_Barcode] PRIMARY KEY CLUSTERED 
(
	[BarcodeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Barcode]  WITH CHECK ADD  CONSTRAINT [FK_Barcode_Lot] FOREIGN KEY([LotId])
REFERENCES [dbo].[Lot] ([LotId])
GO

ALTER TABLE [dbo].[Barcode] CHECK CONSTRAINT [FK_Barcode_Lot]
GO

ALTER TABLE [dbo].[Barcode]  WITH CHECK ADD  CONSTRAINT [FK_Barcode_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
GO

ALTER TABLE [dbo].[Barcode] CHECK CONSTRAINT [FK_Barcode_Product]
GO


USE [PJ]
GO

/****** Object:  View [dbo].[LotUserMappingView]    Script Date: 04/27/2014 01:20:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[LotUserMappingView]
AS
SELECT     L.LotId,L.LotName, U.UserName,LUM.UserId, LS.EnumValue AS Status,LUM.StatusId,L.InstanceId
FROM         dbo.LotUserMapping AS LUM INNER JOIN
                      dbo.Lot AS L ON L.LotId = LUM.LotId INNER JOIN
                      dbo.[User] AS U ON U.Id = LUM.UserId INNER JOIN
                      dbo.LotStatus AS LS ON LS.StatusId = LUM.StatusId





GO


USE [PJ]
GO

/****** Object:  View [dbo].[ViewLotDetails]    Script Date: 04/27/2014 01:20:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[ViewLotDetails]
AS
SELECT		L.LotId, 
			L.InstanceId, 
			L.LotName, 
			ISNULL(L.Weight, 0) Weight, 
			ISNULL(L.NoOfPieces,0) NoOfPieces, 
			L.ProductGroupId, 
			PG.ProductGroup, 
			L.DealerId, 
			ISNULL(L.IsMRP, 0) IsMRP, 
			ISNULL(L.MRP, 0) MRP,  
			ISNULL(L.DiffAllowed,0) DiffAllowed
FROM         dbo.Lot AS L INNER JOIN
                      dbo.ProductGroup AS PG ON PG.Id = L.ProductGroupId


GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "L"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 203
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PG"
            Begin Extent = 
               Top = 6
               Left = 241
               Bottom = 125
               Right = 401
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewLotDetails'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewLotDetails'
GO


USE [PJ]
GO

/****** Object:  View [dbo].[GetCompletedButNotSubmittedProducts]    Script Date: 04/27/2014 01:20:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[GetCompletedButNotSubmittedProducts]
AS
SELECT	B.BarcodeId, 
		b.BarcodeNumber, 
		b.LotId, 
		ISNULL(b.NetWeight, 0) NetWeight, 
		ISNULL(b.NoOfPieces,0) NoOfPieces, 
		b.Notes, 
		ISNULL(b.Price,0) Price, 
		b.ProductId, 
		ISNULL(b.WeightMeasure, 0) WeightMeasure,
		P.ProductName ,
		ISNULL(B.GrossWeight,0) GrossWeight,
		ISNULL(B.IsSubmitted, 0) IsSubmitted
FROM Barcode B
JOIN Product P ON P.Id = B.ProductId
--SELECT * FROM Barcode 

GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "B"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 203
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "P"
            Begin Extent = 
               Top = 6
               Left = 241
               Bottom = 125
               Right = 444
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'GetCompletedButNotSubmittedProducts'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'GetCompletedButNotSubmittedProducts'
GO


