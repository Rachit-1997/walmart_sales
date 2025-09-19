-- Walmart Sales Analysis Queries
-- Project: Retail Analytics for Walmart Stores

-- =============================================
-- 1. PAYMENT METHOD ANALYSIS
-- =============================================

-- Q1: Payment method distribution and quantity sold
SELECT 
    payment_method, 
    COUNT(*) AS transaction_count,
    SUM(quantity) AS total_quantity_sold
FROM walmart
GROUP BY payment_method
ORDER BY transaction_count DESC;

-- =============================================
-- 2. PRODUCT CATEGORY ANALYSIS
-- =============================================

-- Q2: Highest-rated category in each branch
WITH category_ratings AS (
    SELECT 
        branch,
        category, 
        ROUND(AVG(rating)::NUMERIC, 2) AS avg_rating,
        RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) AS rating_rank
    FROM walmart
    GROUP BY branch, category
)
SELECT 
    branch,
    category,
    avg_rating
FROM category_ratings
WHERE rating_rank = 1;

-- Q5: Rating statistics by city and category
SELECT 
    city, 
    category, 
    ROUND(MIN(rating)::NUMERIC, 2) AS min_rating,
    ROUND(MAX(rating)::NUMERIC, 2) AS max_rating,
    ROUND(AVG(rating)::NUMERIC, 2) AS avg_rating
FROM walmart
GROUP BY city, category
ORDER BY city, avg_rating DESC;

-- Q6: Total profit by category
SELECT 
    category, 
    ROUND(SUM(unit_price * quantity * profit_margin)::NUMERIC, 2) AS total_profit
FROM walmart 
GROUP BY category
ORDER BY total_profit DESC;

-- =============================================
-- 3. TEMPORAL ANALYSIS (TIME/DAY)
-- =============================================

-- Q3: Busiest day for each branch
WITH daily_transactions AS (
    SELECT 
        branch, 
        TO_CHAR(TO_DATE(date, 'DD/MM/YY'), 'Day') AS day_name, 
        COUNT(*) AS transaction_count,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS day_rank
    FROM walmart
    GROUP BY branch, TO_CHAR(TO_DATE(date, 'DD/MM/YY'), 'Day')
)
SELECT 
    branch,
    TRIM(day_name) AS busiest_day,
    transaction_count
FROM daily_transactions
WHERE day_rank = 1;

-- Q8: Sales distribution by time of day
SELECT 
    branch, 
    CASE 
        WHEN EXTRACT(HOUR FROM (time::TIME)) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM (time::TIME)) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening' 
    END AS time_period,
    COUNT(*) AS invoice_count
FROM walmart
GROUP BY branch, 
    CASE 
        WHEN EXTRACT(HOUR FROM (time::TIME)) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM (time::TIME)) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening' 
    END
ORDER BY branch, invoice_count DESC;

-- =============================================
-- 4. BRANCH PERFORMANCE ANALYSIS
-- =============================================

-- Q7: Most common payment method by branch
WITH branch_payments AS (
    SELECT 
        branch,
        payment_method, 
        COUNT(*) AS payment_count,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS payment_rank
    FROM walmart
    GROUP BY branch, payment_method
)
SELECT 
    branch,
    payment_method AS preferred_payment_method,
    payment_count
FROM branch_payments
WHERE payment_rank = 1;

-- Q9: Top 5 branches with highest revenue decrease (2022 vs 2023)
-- Method 1: Using window functions
WITH yearly_revenue AS (
    SELECT 
        branch, 
        EXTRACT(YEAR FROM TO_DATE(date, 'DD/MM/YY')) AS year,
        SUM(unit_price * quantity) AS revenue
    FROM walmart
    GROUP BY branch, EXTRACT(YEAR FROM TO_DATE(date, 'DD/MM/YY'))
),
revenue_comparison AS (
    SELECT 
        *,
        (revenue - LEAD(revenue) OVER(PARTITION BY branch ORDER BY year)) / revenue * 100.0 AS decrease_percentage
    FROM yearly_revenue
    WHERE year IN (2022, 2023)
)
SELECT 
    branch,
    ROUND(decrease_percentage::NUMERIC, 2) AS revenue_decrease_percent
FROM revenue_comparison
WHERE decrease_percentage IS NOT NULL
ORDER BY decrease_percentage DESC 
LIMIT 5;

-- Method 2: Using CTEs with joins (alternative approach)
WITH revenue_2022 AS (
    SELECT 
        branch,
        SUM(unit_price * quantity) AS revenue_2022
    FROM walmart
    WHERE EXTRACT(YEAR FROM TO_DATE(date, 'DD/MM/YY')) = 2022  
    GROUP BY branch
),
revenue_2023 AS (
    SELECT 
        branch,
        SUM(unit_price * quantity) AS revenue_2023
    FROM walmart
    WHERE EXTRACT(YEAR FROM TO_DATE(date, 'DD/MM/YY')) = 2023
    GROUP BY branch
)
SELECT 
    r22.branch,
    r22.revenue_2022,
    r23.revenue_2023,
    ROUND(
        (r22.revenue_2022 - r23.revenue_2023)::NUMERIC /
        r22.revenue_2022::NUMERIC * 100, 
        2
    ) AS revenue_decrease_percent
FROM revenue_2022 AS r22
JOIN revenue_2023 AS r23 ON r22.branch = r23.branch
WHERE r22.revenue_2022 > r23.revenue_2023
ORDER BY revenue_decrease_percent DESC
LIMIT 5;

-- =============================================
-- 5. BASIC AGGREGATIONS
-- =============================================

-- Q4: Total quantity sold by payment method
SELECT 
    payment_method, 
    SUM(quantity) AS total_quantity_sold
FROM walmart
GROUP BY payment_method
ORDER BY total_quantity_sold DESC;