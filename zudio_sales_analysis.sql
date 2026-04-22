create database Pratice;
use Pratice;

select * from zudio_sales;

alter table zudio_sales add column Sales decimal(10,2)
generated always as (Price * Quantity) stored
after Quantity;

-- Data cleaning and validation
select * from zudio_sales
where Price is null or Quantity is null or Sales is null or Store_Open_Date is null;

-- creating metrics 
select Price, Quantity, Sales, Sales_Profit, (Sales_Profit / Sales) * 100 as Profit_Margin
from zudio_sales;

-- Trend Analysis
describe zudio_sales;

select year(str_to_date(Store_Open_Date, '%d-%m-%Y')) as Year,
sum(Sales) as Total_Sales from zudio_sales 
group by year(str_to_date(Store_Open_Date, '%d-%m-%Y'));

-- Year-over-Year (YoY) Growth
-- changing date format
update zudio_sales set Store_Open_Date = str_to_date(Store_Open_Date, '%d-%m-%Y');
alter table zudio_sales modify column Store_Open_Date date;

select Year,Total_Sales, Prev_Year_Sales, ((Total_Sales - Prev_Year_Sales) / Prev_Year_Sales) * 100 as Growth_Rate
from ( select Year, Total_Sales,
lag(Total_Sales) over (order by Year) as Prev_Year_Sales
from ( select year(Store_Open_Date) as Year,
sum(Sales) as Total_Sales
from zudio_sales
group by year(Store_Open_Date)) t1)t2;

-- Product Analysis
select Clothing_Type, sum(Sales) as Total_Sales, round(sum(Sales_Profit),2) as Total_Profit
from zudio_sales group by Clothing_Type order by Total_Sales desc;

-- Category / Segment Analysis
select Category, round(sum(Sales),2) as Total_Sales, round(sum(Sales_Profit),2) as Profit
from zudio_sales group by Category;

-- Customer Analysis 
select Customer_ID,sum(Sales) as Total_Sales from zudio_sales
group by Customer_ID order by Total_Sales Desc;

-- Regional / Location Analysis
select City,State, sum(Sales) as Total_Sales from zudio_sales group by City,State;

-- Profitability Analysis
select Clothing_Type, round(sum(Sales_Profit),2) as Profit,
sum(Sales) as Total_sales,round((sum(Sales_Profit) / sum(Sales)) * 100,2) as Profit_Margin
from zudio_sales group by Clothing_Type;

-- Order - Level Insights
select Order_ID, sum(Sales) as Order_Value
from zudio_sales group by Order_ID;

-- Data Aggregation for Power BI
create view sales_summary as
select 
    Store_Open_Date,
    Clothing_Type,
    Category,
    City,
    State,
    SUM(Sales) as Total_Sales,
    SUM(sales_profit) as Total_Profit
from zudio_sales
group by Store_Open_Date, Clothing_Type, Category, City,State;

select * from sales_summary;

