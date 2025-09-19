# Walmart Data Analysis: End-to-End SQL + Python Project  

## Overview
This project analyzes retail sales data to extract business insights using Python and SQL. It demonstrates data cleaning, analysis, and database management skills relevant to analytics roles.

---

## Tech Stack
- **Python**: Data processing and analysis
- **PostgreSQL**: Database management and complex queries
- **Libraries**: pandas, numpy, sqlalchemy, psycopg2

  **Tools Used**: Visual Studio Code (VS Code), Python, SQL (PostgreSQL)

---

## Project Workflow

### 1. Data Collection
- Downloaded retail sales dataset from Kaggle using API
- Dataset contains 10K+ sales transactions with customer and product details

### 2. Data Cleaning & Preparation
- Removed duplicate records and handled missing values
- Fixed data types and formatted currency columns
- Created calculated fields (total amount = unit_price × quantity)
- Validated data quality after cleaning

### 3. Database Setup
- Connected to PostgreSQL using SQLAlchemy
- Created database schema and loaded cleaned data
- Set up proper indexing for query performance

### 4. SQL Analysis
Wrote queries to answer key business questions:
- **Revenue Analysis**: Sales performance by branch, category, and time periods
- **Product Performance**: Best-selling categories and profit margins
- **Customer Insights**: Payment preferences and rating patterns
- **Branch Comparison**: Performance metrics across different locations

### 5. Key Findings
- Identified top-performing product categories
- Found peak sales hours and seasonal trends
- Analyzed customer satisfaction by branch and payment method
- Discovered revenue optimization opportunities

---

## Files Structure
```
C:\Users\YourName\Documents\Projects\walmart-sales-analysis\
├── data\
│   ├── raw\
│   └── processed\
├── sql_queries\
├── notebooks\
├── docs\

---

## Setup Instructions
1. Clone the repository
2. Install requirements: `pip install pandas numpy sqlalchemy psycopg2`
3. Set up PostgreSQL connection
4. Run data processing pipeline
5. Execute SQL analysis queries

---

## Skills Demonstrated
- **Data Cleaning**: Handling real-world messy data
- **SQL**: Complex queries, window functions, aggregations
- **Python**: Data manipulation with pandas
- **Database Management**: Schema design and optimization
- **Business Analysis**: Translating data into actionable insights

---

## Why This Project?
Chose retail sales data to understand customer behavior patterns and revenue optimization - areas where data can directly impact business decisions.

This project showcases practical data analysis skills and SQL proficiency for analyst (business intelligence etc.) roles.
