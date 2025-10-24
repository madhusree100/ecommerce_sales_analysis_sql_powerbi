create database project;
use project;

CREATE TABLE ECOMMERCE_SALES (
    Order_ID INT,
    Order_Date DATE,
    Customer_Name VARCHAR(255),
    Region VARCHAR(50),
    City VARCHAR(50),
    Category VARCHAR(100),
    Sub_Category VARCHAR(100),
    Product_Name VARCHAR(255),
    Quantity INT,
    Unit_Price INT,
    Discount INT,
    Sales DECIMAL(10, 2),
    Profit DECIMAL(10, 2),
    Payment_Mode VARCHAR(50)
);

#complete view of the table
select*from ECOMMERCE_SALES;

# total profit in each subcategory
SELECT Category, Sub_Category, SUM(Profit) AS Total_Profit
FROM ECOMMERCE_SALES
GROUP BY Category,Sub_Category 
ORDER BY Category, Total_Profit DESC;

#TOTAL PROFIT IN EACH CATEGORY
SELECT Category,SUM(Profit) AS Total_Profit 
FROM ECOMMERCE_SALES
GROUP BY Category                   
ORDER BY Total_Profit DESC;  

#TOTAL NO OF UNITS SOLD IN EACH DISCOUNT RANGE
SELECT DISCOUNT, SUM(QUANTITY) AS TOTAL_UNITS
FROM ECOMMERCE_SALES
GROUP BY DISCOUNT
ORDER BY TOTAL_UNITS DESC;

#PROFITS IN EACT EACH DISCOUNT RANGE
SELECT DISCOUNT, SUM(PROFIT) AS TOTAL_PROFIT
FROM ECOMMERCE_SALES
GROUP BY DISCOUNT
ORDER BY TOTAL_PROFIT DESC;

#PROFIT AND TOTAL SALES ANALYSIS
SELECT DISCOUNT, SUM(PROFIT) AS TOTAL_PROFIT,SUM(QUANTITY) AS TOTAL_UNITS
FROM ECOMMERCE_SALES
GROUP BY DISCOUNT
ORDER BY TOTAL_PROFIT DESC; 

#top ten performing products
SELECT Product_Name,SUM(Quantity) AS Total_Quantity_Sold,SUM(Profit) AS Total_Profit,(SUM(Profit) / SUM(Quantity)) AS Profit_Per_Unit -- The core metric for value
FROM ECOMMERCE_SALES
GROUP BY Product_Name
HAVING SUM(Quantity) > 10 -- Filter out low-volume items for a meaningful average
ORDER BY Profit_Per_Unit DESC
LIMIT 10;

#top performing cities in India
Select city,sum(profit) as city_profit
from ecommerce_sales
group by city
order by city_profit DESC;

#top performing cities in each category
SELECT t1.Category, t1.City, SUM(t1.Profit) AS Total_City_Profit, t2.Overall_Category_Profit
FROM ECOMMERCE_SALES AS t1
JOIN ( SELECT Category, SUM(Profit) AS Overall_Category_Profit
	   FROM ECOMMERCE_SALES
	   GROUP BY Category) AS t2
ON t1.Category = t2.Category
GROUP BY t1.Category, t1.City, t2.Overall_Category_Profit
ORDER BY t2.Overall_Category_Profit DESC, Total_City_Profit DESC;

SELECT date_format(order_date,'%Y-%m') AS Sales_Month, -- Extracts year and month from the YYYY-MM-DD string
    Category,
    SUM(Quantity) AS Total_Units_Sold
FROM ECOMMERCE_SALES
GROUP BY Sales_Month,category
ORDER BY Sales_Month ASC,Total_Units_Sold DESC;
    
#average daily demand of sub categories
SELECT Sub_Category, CAST(SUM(Quantity) AS REAL) / COUNT(DISTINCT Order_Date) AS Avg_Daily_Demand
FROM ECOMMERCE_SALES
GROUP BY Sub_Category
ORDER BY Avg_Daily_Demand DESC;


#relation between payment method ,order , average order value and average profit
SELECT Payment_Mode, COUNT(DISTINCT Order_ID) AS Total_Orders,AVG(Sales) AS Avg_Order_Value,
    AVG(Profit) AS Avg_Profit_Per_Line_Item
FROM ECOMMERCE_SALES
GROUP BY Payment_Mode
ORDER BY Avg_Order_Value DESC;

