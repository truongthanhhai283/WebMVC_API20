USE [ShopOnline]
GO
/****** Object:  StoredProcedure [dbo].[GetRevenueStatistic]    Script Date: 5/6/2020 5:21:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[GetRevenueStatistic]
    @fromDate [nvarchar](max),
    @toDate [nvarchar](max)
AS
BEGIN
    
    select
    o.CreatedDate as Date,
    sum(od.Quantity*od.Price) as Revenues,
    sum((od.Quantity*od.Price)-(od.Quantity*p.OriginalPrice)) as Benefit
    from Orders o
    inner join OrderDetails od
    on o.ID = od.OrderId
    inner join Products p
    on od.ProductID  = p.ID
    where o.CreatedDate <= cast(@toDate as date) and o.CreatedDate >= cast(@fromDate as date)
    group by o.CreatedDate
END