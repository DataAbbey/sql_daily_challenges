-- Challenge: Top 3 Products by Revenue per Category (Product Analyst-flavored)
-- Pattern: Aggregate in CTE, then RANK() in second CTE, filter in final SELECT
-- Scenario: Identify top performing products by revenue within each category for 2024

WITH product_revenue AS (
    SELECT
        category,
        product_name,
        SUM(revenue) AS total_revenue
    FROM product_sales
    WHERE YEAR(sale_date) = 2024
    GROUP BY category, product_name
),
product_rev_rank AS (
    SELECT
        category,
        product_name,
        total_revenue,
        RANK() OVER (
            PARTITION BY category
            ORDER BY total_revenue DESC
        ) AS category_product_rank
    FROM product_revenue
)
SELECT
    category,
    category_product_rank AS rank,
    product_name,
    total_revenue
FROM product_rev_rank
WHERE category_product_rank <= 3
ORDER BY category, rank ASC;
