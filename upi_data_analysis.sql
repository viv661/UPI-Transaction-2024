
-- UPI Transactions 2024 - Data Analytics Project (PostgreSQL)
-- Description: SQL queries for user targeting & revenue analysis

-- 1. Top Spending Merchant Categories
SELECT merchant_cate, 
       SUM(amount) AS total_spent
FROM upi_transactions_2024
WHERE transaction_status = 'SUCCESS'
GROUP BY merchant_cate
ORDER BY total_spent DESC;

-- 2. High-Value Customers (Top 10)

SELECT sender_state, sender_bank, sender_age_gr,
       SUM(amount) AS total_spent
FROM upi_transactions_2024
WHERE transaction_status = 'SUCCESS'
GROUP BY sender_state, sender_bank, sender_age_gr
ORDER BY total_spent DESC
LIMIT 10;

-- 3. Failed Transactions (Revenue Loss)

SELECT sender_bank, COUNT(*) AS failed_txns, SUM(amount) AS failed_amount
FROM upi_transactions_2024
WHERE transaction_status = 'FAILED'
GROUP BY sender_bank
ORDER BY failed_amount DESC;

-- 4. Transaction Volume by Day of Week

SELECT day_of_we AS day, COUNT(*) AS txn_count, SUM(amount) AS total_amount
FROM upi_transactions_2024
WHERE transaction_status = 'SUCCESS'
GROUP BY day_of_we
ORDER BY txn_count DESC;


-- 5. Weekend vs Weekday Spending

SELECT CASE WHEN is_weekend = 1 THEN 'Weekend' ELSE 'Weekday' END AS period,
       COUNT(*) AS txn_count, SUM(amount) AS total_amount
FROM upi_transactions_2024
WHERE transaction_status = 'SUCCESS'
GROUP BY is_weekend;


-- 6. Bank-Wise Revenue Contribution

SELECT sender_bank, COUNT(*) AS txn_count, SUM(amount) AS total_amount
FROM upi_transactions_2024
WHERE transaction_status = 'SUCCESS'
GROUP BY sender_bank
ORDER BY total_amount DESC;


-- 7. Age Group Spending Trends

SELECT sender_age_gr, SUM(amount) AS total_spent, COUNT(*) AS txn_count
FROM upi_transactions_2024
WHERE transaction_status = 'SUCCESS'
GROUP BY sender_age_gr
ORDER BY total_spent DESC;


-- 8. Most Popular Transaction Types

SELECT transaction_type, COUNT(*) AS txn_count, SUM(amount) AS total_amount
FROM upi_transactions_2024
WHERE transaction_status = 'SUCCESS'
GROUP BY transaction_type
ORDER BY txn_count DESC;


-- 9. Fraud Monitoring (Suspicious Transactions)

SELECT sender_bank, receiver_bank, COUNT(*) AS fraud_txns
FROM upi_transactions_2024
WHERE fraud_flag = 1
GROUP BY sender_bank, receiver_bank
ORDER BY fraud_txns DESC;


-- 10. Revenue Heatmap by Hour of Day

SELECT hour_of_d, COUNT(*) AS txn_count, SUM(amount) AS total_amount
FROM upi_transactions_2024
WHERE transaction_status = 'SUCCESS'
GROUP BY hour_of_d
ORDER BY hour_of_d;


-- Combined CTE Analytics Report (Single Query Output)

WITH top_merchants AS (
    SELECT merchant_cate, SUM(amount) AS total_spent
    FROM upi_transactions_2024
    WHERE transaction_status = 'SUCCESS'
    GROUP BY merchant_cate
    ORDER BY total_spent DESC
    LIMIT 5
),
top_customers AS (
    SELECT sender_state, sender_bank, sender_age_gr, SUM(amount) AS total_spent
    FROM upi_transactions_2024
    WHERE transaction_status = 'SUCCESS'
    GROUP BY sender_state, sender_bank, sender_age_gr
    ORDER BY total_spent DESC
    LIMIT 5
),
peak_hours AS (
    SELECT hour_of_d, SUM(amount) AS total_spent
    FROM upi_transactions_2024
    WHERE transaction_status = 'SUCCESS'
    GROUP BY hour_of_d
    ORDER BY total_spent DESC
    LIMIT 5
)
SELECT 'Top Merchant Categories' AS metric, * FROM top_merchants
UNION ALL
SELECT 'Top High-Value Customers' AS metric, sender_state || ' - ' || sender_bank || ' (' || sender_age_gr || ')' AS category, total_spent FROM top_customers
UNION ALL
SELECT 'Peak Hour Revenue Slots' AS metric, hour_of_d::TEXT AS category, total_spent FROM peak_hours;


-- End of Script

