

#Dùng SQL để tính tỉ lệ số lượng đơn hàng hoàn trả theo sản phẩm

use demo
Select Distinct *
from dbo.Orders
 INNER JOIN dbo.Returns on dbo.Orders.[Order ID]=dbo.Returns.[Order ID]


#Tính tỉ lệ % đơn hàng hoàn trả theo sản phẩm

WITH product_summary([Product ID],order_number,return_number)
AS
(
  Select demo1.*,demo2.return_number
  from  (Select [Product ID],sum([Quantity]) as order_number
		 from dbo.Orders
          Group By [Product ID]) as demo1
 Inner Join ( Select dbo.Orders.[Product ID],sum([Quantity]) as return_number
		 from dbo.Orders INNER JOIN dbo.Returns on dbo.Orders.[Order ID]=dbo.Returns.[Order ID]
         Group By dbo.Orders.[Product ID] ) as demo2
		 On demo1.[Product ID]=demo2.[Product ID]
)
Select Distinct p.[Product ID],p.order_number,p.return_number,(return_number/order_number)*100 as Rate,dbo.Orders.Category,dbo.Orders.[Sub-Category]

From product_summary as p inner Join dbo.Orders on p.[Product ID]=dbo.Orders.[Product ID]
						 
Order by 4 desc


#Tạo bảng tạm

Drop table if exists #return_summary
Create Table  #return_summary
(
[Product ID] Nvarchar(20),
order_number numeric,
return_number numeric
)
insert into #return_summary
Select demo1.*,demo2.return_number
  from  (Select [Product ID],sum([Quantity]) as order_number
		 from dbo.Orders
          Group By [Product ID]) as demo1
 Inner Join ( Select dbo.Orders.[Product ID],sum([Quantity]) as return_number
		 from dbo.Orders INNER JOIN dbo.Returns on dbo.Orders.[Order ID]=dbo.Returns.[Order ID]
         Group By dbo.Orders.[Product ID] ) as demo2
		 On demo1.[Product ID]=demo2.[Product ID]
Select *
From #return_summary



#Create_View

create view product_summary as
With product_summary ([Product ID],order_number,return_number) 
AS
(
  Select demo1.*,demo2.return_number
  from  (Select [Product ID],sum([Quantity]) as order_number
		 from dbo.Orders
          Group By [Product ID]) as demo1
 Inner Join ( Select dbo.Orders.[Product ID],sum([Quantity]) as return_number
		 from dbo.Orders INNER JOIN dbo.Returns on dbo.Orders.[Order ID]=dbo.Returns.[Order ID]
         Group By dbo.Orders.[Product ID] ) as demo2
		 On demo1.[Product ID]=demo2.[Product ID]
)
Select Distinct p.[Product ID],p.order_number,p.return_number,(return_number/order_number)*100 as Rate,dbo.Orders.Category,dbo.Orders.[Sub-Category]
From product_summary as p inner Join dbo.Orders on p.[Product ID]=dbo.Orders.[Product ID]



