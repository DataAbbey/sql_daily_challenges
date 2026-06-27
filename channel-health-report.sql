-- Challenge: Channel Health Report
-- Pattern: Multi-concept — aggregation + CASE WHEN pivot + RANK() + derived metrics
-- Scenario: Full channel performance report with ranking and MoM growth for 2024
-- Grade: A-

WITH revenue_results AS (
    -- aggregate all channel metrics in one CTE
    -- CASE WHEN pivot for Nov and Dec revenue avoids needing LAG
    SELECT
        channel,
        COUNT(DISTINCT order_id)                        AS total_orders,
        SUM(order_amount)                               AS total_revenue,
        SUM(CASE 
            WHEN MONTH(order_date) = 11 
            THEN order_amount ELSE 0 END)               AS nov_revenue,
        SUM(CASE 
            WHEN MONTH(order_date) = 12 
            THEN order_amount ELSE 0 END)               AS dec_revenue
    FROM orders
    WHERE status = 'completed'
      AND YEAR(order_date) = 2024
    GROUP BY channel
)

-- apply ranking and derived metrics on already-aggregated data
SELECT
    channel,
    total_orders,
    total_revenue,
    ROUND(DIV0(total_revenue, total_orders), 2)         AS avg_order_value,
    RANK() OVER (ORDER BY total_revenue DESC)           AS revenue_rank,
    nov_revenue,
    dec_revenue,
    ROUND(
        DIV0(dec_revenue - nov_revenue, nov_revenue) * 100
    , 2)                                                AS mom_growth_pct
FROM revenue_results
ORDER BY revenue_rank ASC;

-- Key concepts combined:
-- 1. CASE WHEN pivot — pull specific months into columns without LAG
-- 2. RANK() with no PARTITION BY — global ranking across all channels
-- 3. DIV0 — safe division for AOV and MoM growth
-- 4. Derived metrics (AOV, MoM) calculated in final SELECT from CTE aliases
--
-- RANK() vs DENSE_RANK() here:
-- RANK() is appropriate for a leaderboard where gaps communicate meaning
-- DENSE_RANK() would be better if segmenting into tiers afterward
