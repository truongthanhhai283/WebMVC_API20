USE [ShopOnline]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[GetRevenueStatistic]
		@fromDate = N'01/01/2016',
		@toDate = N'01/01/2021'

SELECT	'Return Value' = @return_value

GO
