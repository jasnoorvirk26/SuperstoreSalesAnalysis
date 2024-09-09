-- Step 1: Create Database
CREATE DATABASE sales_order_management;

-- Step 2: Use Database
USE sales_order_management;

-- Step 3: Select Data from Orders
SELECT *
FROM Orders;

-- Step 4: Modify Orders Table
-- Alter Row ID column to be NOT NULL
ALTER TABLE Orders
ALTER COLUMN [Row ID] INT NOT NULL;

-- Alter Order ID column to be NOT NULL with CHAR(14) type
ALTER TABLE Orders
ALTER COLUMN [Order ID] CHAR(14) NOT NULL;

-- Alter Order Date column to be of DATE type
ALTER TABLE Orders
ALTER COLUMN [Order Date] DATE;

-- Alter Ship Date column to be of DATE type
ALTER TABLE Orders
ALTER COLUMN [Ship Date] DATE;

-- Alter Customer ID column to be NOT NULL with CHAR(8) type
ALTER TABLE Orders
ALTER COLUMN [Customer ID] CHAR(8) NOT NULL;

-- Alter Postal Code column to be of CHAR(5) type
ALTER TABLE Orders
ALTER COLUMN [Postal Code] CHAR(5);

-- Alter Sales, Discount, Profit columns to be of decimal(10,2) type
ALTER TABLE Orders
ALTER COLUMN Sales Decimal(10,2);

ALTER TABLE Orders
ALTER COLUMN Discount decimal(10,2);

ALTER TABLE Orders
ALTER COLUMN Profit decimal(10,2);

-- Alter Quantity column to be of int type
ALTER TABLE Orders
ALTER COLUMN Quantity int;

-- Alter [Product ID] column to be of CHAR(15) type
ALTER TABLE Orders
ALTER COLUMN [Product ID] CHAR(15) NOT NULL;

---Checking for Missing values
SELECT COUNT(*) AS Missing_Order_IDs FROM Orders WHERE [Order ID] IS NULL;
SELECT COUNT(*) AS Missing_Order_Dates FROM Orders WHERE [Order Date] IS NULL;
SELECT COUNT(*) AS Missing_Ship_Dates FROM Orders WHERE [Ship Date] IS NULL;
SELECT COUNT(*) AS Missing_Customer_IDs FROM Orders WHERE [Customer ID] IS NULL;
SELECT COUNT(*) AS Missing_Product_IDs FROM Orders WHERE [Product ID] IS NULL;
SELECT COUNT(*) AS Missing_Sales FROM Orders WHERE Sales IS NULL;
SELECT COUNT(*) AS Missing_Quantity FROM Orders WHERE Quantity IS NULL;
SELECT COUNT(*) AS Missing_Profit FROM Orders WHERE Profit IS NULL;

--Checking Duplicates
--Checking for Duplicate Orders with Same [Order ID], [Product ID], [Ship Date], and [Ship Mode]:

select [Order ID],[Product ID],  [Ship Date], [Ship Mode],count(*) as dupl_vals
from Orders
group by [Order ID],[Product ID], [Ship Date], [Ship Mode]
having count(*)>1;

--Checking for Different Quantities with Same [Order ID], [Product ID], [Ship Date], [Ship Mode]:
select [Order ID],[Product ID],Quantity,  [Ship Date], [Ship Mode] ,count(*) as dupl_vals
from Orders
group by [Order ID],[Product ID],Quantity,  [Ship Date], [Ship Mode]
having count(*)>1;


select *
from Orders 
where [Order ID]='CA-2016-140571' and [Product ID]='OFF-PA-10001954';

--deleting duplicates
WITH CTE AS (
    SELECT ROW_NUMBER() OVER(PARTITION BY [Order ID], [Product ID], Quantity ORDER BY [ROW ID]) AS RowNum
    FROM Orders
)
DELETE FROM CTE
WHERE RowNum > 1;

--Checking inconsistencies
--Order Date should not be after Ship Date
SELECT *
FROM Orders
WHERE [Order Date] > [Ship Date];

--checking Outliers
SELECT * FROM Orders WHERE Sales < 0;
SELECT * FROM Orders WHERE Quantity < 0;

--Discount within Expected range[0-1]
SELECT * FROM Orders WHERE Discount < 0 OR Discount > 1;

-- Create the [sales_orders] table
CREATE TABLE [dbo].[sales_orders](
	[Order ID] [char](14) NOT NULL,
	[Order Date] [date] NULL,
	[Ship Date] [date] NULL,
	[Ship Mode] [nvarchar](255) NULL,
	[Customer ID] [char](8) NOT NULL,
	[Customer Name] [nvarchar](255) NULL,
	[Segment] [nvarchar](255) NULL,
	[Country] [nvarchar](255) NULL,
	[City] [nvarchar](255) NULL,
	[State] [nvarchar](255) NULL,
	[Postal Code] [char](5) NULL,
	[Region] [nvarchar](255) NULL,
	[Product ID] [char](15) NOT NULL,
	[Category] [nvarchar](255) NULL,
	[Sub-Category] [nvarchar](255) NULL,
	[Product Name] [nvarchar](255) NULL,
	[Sales] [decimal](10, 2) NULL,
	[Quantity] [int] NULL,
	[Discount] [decimal](10, 2) NULL,
	[Profit] [decimal](10, 2) NULL
) 

-- Insert aggregated data into [sales_orders]
INSERT INTO [sales_orders] (
    [Order ID],
    [Order Date],
    [Ship Date],
    [Ship Mode],
    [Customer ID],
    [Customer Name],
    Segment,
    Country,
    City,
    State,
   [Postal Code],
    Region,
    [Product ID],
    Category,
    [Sub-Category],
    [Product Name],
    Quantity,
    Sales,
	Discount,
    Profit)
SELECT 
    [Order ID],
    [Order Date],
    [Ship Date],
    [Ship Mode],
    [Customer ID],
    [Customer Name],
    Segment,
    Country,
    City,
    State,
   [Postal Code],
    Region,
    [Product ID],
    Category,
    [Sub-Category],
    [Product Name],
    SUM(Quantity) AS TotalQuantity,
    SUM(Sales) AS TotalSales,
	Discount,
    SUM(Profit) AS TotalProfit
FROM 
    Orders  
GROUP BY 
    [Order ID],
    [Order Date],
    [Ship Date],
    [Ship Mode],
    [Customer ID],
    [Customer Name],
   Segment,
    Country,
    City,
    State,
   [Postal Code],
    Region,
    [Product ID],
    Category,
    [Sub-Category],
    [Product Name],
	Discount;


select *
from [sales_orders];

select top 10 [Customer id],[customer name],segment,sum(profit)/sum(sales) as profit_margin
from [sales_orders]
group by [customer id],[customer name],segment
order by 4 desc;


ALTER TABLE [dbo].[sales_orders]
ADD CONSTRAINT PK_sales_orders PRIMARY KEY ([Order ID], [Product ID]);

--1)Find the top 5 customers with the highest lifetime value (LTV). 
--LTV is calculated as the sum of their profits divided by the number of years they have been a customer.

WITH CustomerLifetimeData AS (
    SELECT 
        [Customer ID],[Customer Name],
		DATEDIFF(YEAR, MIN([Order Date]), MAX([Order Date])) + 1 as YearsAsCustomer,
        SUM(Profit) AS TotalProfit
    FROM 
        [sales_orders]
    GROUP BY 
        [Customer ID],[Customer Name]
)

-- Select Top 5 Customers by LTV
SELECT TOP 10 
    [Customer ID],[Customer Name] as Customer,
    CONVERT(decimal(10,2), (TotalProfit *1.0) / YearsAsCustomer) AS LTV
FROM 
    CustomerLifetimeData
ORDER BY 
    LTV DESC;





--2)Create a pivot table to show total sales by product category and sub-category.
SELECT 
    Category,
    [Sub-Category],
    ROUND(SUM(Sales), 2) AS total_sales
FROM 
    [sales_orders] 
GROUP BY 
    Category, [Sub-Category]
ORDER BY 
    Category, total_sales;

---or

SELECT Category,
       COALESCE([Furnishings], 0) AS Furnishings,
       COALESCE([Bookcases], 0) AS Bookcases,
       COALESCE([Tables], 0) AS [Tables],
       COALESCE([Chairs], 0) AS Chairs,
       COALESCE([Fasteners], 0) AS Fasteners,
       COALESCE([Labels], 0) AS Labels,
       COALESCE([Envelopes], 0) AS Envelopes,
       COALESCE([Art], 0) AS Art,
       COALESCE([Supplies], 0) AS Supplies,
       COALESCE([Paper], 0) AS Paper,
       COALESCE([Appliances], 0) AS Appliances,
       COALESCE([Binders], 0) AS Binders,
       COALESCE([Storage], 0) AS Storage,
       COALESCE([Copiers], 0) AS Copiers,
       COALESCE([Accessories], 0) AS Accessories,
       COALESCE([Machines], 0) AS Machines,
       COALESCE([Phones], 0) AS Phones
FROM (
    SELECT Category, [Sub-Category], Sales
    FROM [sales_orders]
) AS ord
PIVOT (
    SUM(Sales)
    FOR [Sub-Category] IN ([Supplies],[Storage],[Phones],[Fasteners],[Copiers],[Chairs],[Bookcases],[Machines],[Art],[Envelopes],[Binders],[Labels],[Furnishings],[Accessories],[Appliances],[Paper],[Tables]
)
) AS pivoted_table
ORDER BY Category;


---3)Find the customer who has made the maximum number of orders in each category.
WITH MaxOrdersPerCategory AS (
    SELECT 
        Category,
        [Customer Name],
        COUNT([Order ID]) AS n_orders,
        ROW_NUMBER() OVER (PARTITION BY Category ORDER BY COUNT([Order ID]) DESC) AS rn
    FROM 
        [sales_orders]
    GROUP BY 
        Category, [Customer Name]
)
SELECT 
    Category,
    [Customer Name] as Customer,
    n_orders
FROM 
    MaxOrdersPerCategory
WHERE 
    rn = 1
ORDER BY
    [Category];

--4)Find the top 3 products in each category based on their sales.

WITH RankedProducts AS (
    SELECT 
        Category,
        [Product Name],
        ROUND(SUM(Sales), 2) AS Sales,
        DENSE_RANK() OVER (PARTITION BY Category ORDER BY SUM(Sales) DESC) AS SalesRank
    FROM 
        [sales_orders]
    GROUP BY 
        Category, [Product Name]
)
SELECT 
    Category,
    [Product Name] as Product,
    Sales
FROM 
    RankedProducts
WHERE 
    SalesRank <= 3
ORDER BY
    [Category], SalesRank;


--5) Analyzing Customer Orders

--Step 1: Create the Function to Calculate Days Between Dates

CREATE FUNCTION dbo.DaysBetweenDates (
    @StartDate DATE,
    @EndDate DATE
)
RETURNS INT
AS
BEGIN
    DECLARE @DaysDiff INT;
    SET @DaysDiff = DATEDIFF(DAY, @StartDate, @EndDate);
    RETURN @DaysDiff;
END;

-- Step 2: Create the Stored Procedure Get_Customer_Orders
Alter PROCEDURE Get_Customer_Orders
    @CustomerID char(8)
AS
BEGIN
    -- Declare variables to store aggregated values
    DECLARE @TotalOrders INT;
    DECLARE @AvgAmount DECIMAL(18, 2);
    DECLARE @LastOrderDate DATE;
    DECLARE @DaysSinceLastOrder INT;

    -- Calculate the total number of orders,average total amount,most recent order date
    SELECT @TotalOrders = COUNT(*),@AvgAmount = AVG(Sales),@LastOrderDate = MAX([Order Date])
    FROM [sales_orders]
    WHERE [Customer ID] = @CustomerID;

    -- Calculate the number of days since the most recent order
    SELECT @DaysSinceLastOrder = dbo.DaysBetweenDates(@LastOrderDate, GETDATE());

    -- Select the results
    SELECT
        [Order Date],
        SUM(Sales) AS TotalAmount,
        @TotalOrders AS TotalOrders,
        @AvgAmount AS AvgAmount,
        @LastOrderDate AS LastOrderDate,
        @DaysSinceLastOrder AS DaysSinceLastOrder
    FROM [sales_orders]
    WHERE [Customer ID] = @CustomerID
    GROUP BY [Order Date]
    ORDER BY [Order Date];
END;


EXEC Get_Customer_Orders 'CG-12520';







