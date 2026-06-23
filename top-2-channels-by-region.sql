-- Challenge: Top 2 Sales Channels by Order Count per Region
-- Pattern: Aggregate → RANK() → QUALIFY for top-N filtering, most efficient solution
-- Scenario: Identify highest performing channels by order volume within each region for 2024

WITH channel_region_rank AS (
    SELECT
        region,
        channel,
        SUM(order_count)  AS total_orders,
        SUM(revenue)      AS total_revenue
    FROM channel_sales
    WHERE YEAR(sale_date) = 2024
    GROUP BY region, channel
),

ranked_channel AS (
    SELECT
        region,
        channel,
        total_orders,
        total_revenue,
        RANK() OVER (
            PARTITION BY region
            ORDER BY total_orders DESC
        ) AS rank
    FROM channel_region_rank
)

SELECT
    region,
    rank,
    channel,
    total_orders,
    total_revenue
FROM ranked_channel
QUALIFY rank <= 2
ORDER BY region, rank ASC;
