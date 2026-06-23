-- Challenge: First Purchase Attribution by Marketing Channel
-- Pattern: MIN() for first event + cohort threshold + channel aggregation
-- Scenario: % of users who converted within 7 days of signup by acquisition channel

WITH acq_total_stat AS (
    SELECT
        u.acquisition_channel,
        COUNT(DISTINCT u.user_id) AS total_users
    FROM users u
    GROUP BY 1
),

fast_converters AS (
    SELECT
        u.user_id,
        u.acquisition_channel
    FROM users u
    LEFT JOIN orders o
        ON u.user_id = o.user_id
        AND o.status = 'completed'
    GROUP BY u.user_id, u.acquisition_channel, u.signup_date
    HAVING DATEDIFF('day', u.signup_date, MIN(o.order_date)) <= 7
)

SELECT
    ats.acquisition_channel,
    ats.total_users,
    COUNT(DISTINCT fc.user_id)                          AS fast_converters,
    ROUND(
        DIV0(COUNT(DISTINCT fc.user_id), ats.total_users) * 100
    , 2)                                                AS pct_fast_converters
FROM acq_total_stat ats
LEFT JOIN fast_converters fc
    ON ats.acquisition_channel = fc.acquisition_channel
GROUP BY ats.acquisition_channel, ats.total_users
ORDER BY pct_fast_converters DESC;
