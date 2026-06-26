-- Challenge: Cumulative Revenue by Channel (Running Total)
-- Pattern: Aggregate in CTE, then SUM() OVER with explicit window frame
-- Scenario: Monthly and cumulative completed order revenue by channel for 2024
-- Grade: A-

WITH monthly_total AS (
    -- Step 1: aggregate completed order revenue by month and channel
    SELECT
        DATE_TRUNC('month', order_date)     AS month,
        channel,
        SUM(order_amount)                   AS monthly_revenue
    FROM orders
    WHERE status = 'completed'
      AND YEAR(order_date) = 2024
    GROUP BY 1, 2
)

-- Step 2: apply running total window function on already-aggregated data
SELECT
    month,
    channel,
    monthly_revenue,
    SUM(monthly_revenue) OVER (
        PARTITION BY channel
        ORDER BY month ASC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    )                                       AS cumulative_revenue
FROM monthly_total
ORDER BY channel, month ASC;

-- Key concept: ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
-- means "from the very first row in the partition up to and including
-- the current row" — this is what makes it a running total, not a
-- total of the whole partition.
--
-- Common frame patterns:
-- Running total:    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
-- Rolling 3-month:  ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
-- Full partition:   ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
