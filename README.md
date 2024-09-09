# Superstore Sales Analysis

## Project Overview
This project focuses on analyzing sales data from a US Superstore using SQL and Power BI to derive insights into customer behavior, product performance, and profitability. The project is divided into two main sections:
- **Section A**: SQL-based analysis, including data cleaning and queries for customer lifetime value, sales pivot tables, and more.
- **Section B**: Power BI dashboard for visualizing key metrics, trends, and performance indicators.

## Section A: SQL Queries

### Overview
The SQL analysis includes data cleaning and various queries for detailed analysis. All SQL queries and procedures are contained in the `Superstore-Sales-SQL-Analysis.sql` file.

### Data Cleaning
- **Data Cleaning**: The dataset was cleaned using SQL to handle issues such as missing values, duplicates, and inconsistencies. This ensured that the analysis was based on accurate and reliable data.

### SQL Queries and Data Cleaning
The `Superstore-Sales-SQL-Analysis.sql` file includes:

1. **Top 5 Customers by Lifetime Value (LTV)**: Calculates the top 5 customers based on their Lifetime Value.
2. **Pivot Table for Total Sales by Product Category and Sub-Category**: Generates a pivot table showing total sales by category and sub-category.
3. **Customer with Maximum Orders in Each Category**: Identifies the customer who has placed the most orders in each category.
4. **Top 3 Products by Sales in Each Category**: Finds the top 3 products in each category based on sales.
5. **Stored Procedure: Get Customer Orders**: A stored procedure that retrieves details of customer orders based on the input `CustomerID`.
6. **User-Defined Function: Date Difference**: Calculates the number of days between two dates.

You can download the full SQL file here:
- [Superstore Sales SQL Analysis](Superstore-Sales-SQL-Analysis.sql)

## Section B: Power BI Dashboard

### Dashboard Overview
The Power BI dashboard visualizes key aspects of the sales data. Key analyses include:

1. **Product Category Performance**: Evaluates the performance of different product categories and identifies those driving growth and profitability.
2. **Repeat Orders vs New Orders**: Analyzes the proportion of repeat versus new customer orders and calculates the retention rate.
3. **Average Profit Margin**: Displays the average profit margin for each product sub-category.
4. **Cumulative Sales by Sub-Category**: Shows cumulative total sales for each product sub-category over time.
5. **Sales Trend Over Time**: Highlights the trend in sales revenue over time, including variations by month, quarter, or year.

### Data Analysis with DAX
- **Measures in Power BI**: Custom measures were created using DAX (Data Analysis Expressions) to enhance the analysis and visualization capabilities of the Power BI dashboard. This includes calculations for metrics like profit margins and cumulative sales.

The full Power BI dashboard file is available here:
- [Sales Orders Dashboard](Superstore-Sales-Analysis-Dashboard.pbix.pbix)

## Data Source
The analysis uses a sample sales orders dataset with the following columns:
- Order ID, Order Date, Customer ID, Product Category, Sub-Category, Sales, Profit, Quantity, etc.

You can find the data used for this analysis here: [Data](Orders.csv)

## Presentation

### Overview
The presentation provides an overview of the project, including insights, recommendations, and key findings from the analysis. It summarizes the SQL queries, Power BI dashboard features, and actionable recommendations for improving sales and customer engagement.

You can view the presentation here:
- [Superstore Sales Analysis Presentation](Superstore-Analysis-Presentation.pptx)

## How to Run This Project

### SQL Queries
- Import the sales orders data into your SQL environment (e.g., MySQL, SQL Server) and run the provided SQL scripts to perform the analyses.

### Power BI Dashboard
- Open the `.pbix` file in Power BI Desktop to explore the dashboard and perform further analyses.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Issues and Discussions
Feel free to open an issue or start a discussion if you have any questions or suggestions about this project.


