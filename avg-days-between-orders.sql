-- Challenge: Average Days Between Consecutive Orders per User
-- Pattern: LAG() for sequential row comparison + DATEDIFF + cohort threshold
-- Scenario: Calculate average time between repeat orders for users with 2+ orders in 2024

WITH multi_order_users AS (
    SELECT
        user_id,
        COUNT(DISTINCT order_id) AS order_count
    FROM orders
    WHERE YEAR(order_date) = 2024
    GROUP BY user_id
    HAVING COUNT(DISTINCT order_id) >= 2
),

user_time_log AS (
    SELECT
        user_id,
        order_id,
        order_date,
        LAG(order_date) OVER (
            PARTITION BY user_id
            ORDER BY order_date ASC
        ) AS previous_order_date
    FROM orders
),

avg_user_time_log AS (
    SELECT
        user_id,
        AVG(DATEDIFF('day', previous_order_date, order_date)) AS avg_days_between_orders
    FROM user_time_log
    WHERE previous_order_date IS NOT NULL
    GROUP BY user_id
)

SELECT
    mou.user_id,
    ROUND(autl.avg_days_between_orders, 2) AS avg_days_between_orders,
    mou.order_count                        AS total_orders
FROM multi_order_users mou
LEFT JOIN avg_user_time_log autl
    ON mou.user_id = autl.user_id
ORDER BY avg_days_between_orders ASC;
