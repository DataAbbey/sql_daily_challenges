-- Challenge: Weekly Retention by Signup Cohort
-- Pattern: Separate cohort size CTE + activity CTE, different grains joined at the end
-- Scenario: Q1 2024 signup cohorts, retention tracked week 0-12

WITH weekly_retention AS (
    -- retained users per cohort month per week
    -- DATEDIFF('week') calculates how many weeks since signup
    SELECT
        DATE_TRUNC('month', u.signup_date)          AS cohort_month,
        DATEDIFF('week', u.signup_date,
            s.session_date)                          AS weeks_since_signup,
        COUNT(DISTINCT s.user_id)                   AS users_retained
    FROM users u
    LEFT JOIN sessions s
        ON u.user_id = s.user_id
        AND DATEDIFF('week', u.signup_date,
            s.session_date) BETWEEN 0 AND 12
    WHERE QUARTER(u.signup_date) = 1
      AND YEAR(u.signup_date) = 2024
    GROUP BY 1, 2
),

cohort_sizes AS (
    -- total users per cohort month regardless of session activity
    -- this is the denominator — ALL Q1 signups, not just active ones
    SELECT
        DATE_TRUNC('month', signup_date)            AS cohort_month,
        COUNT(DISTINCT user_id)                     AS cohort_size
    FROM users
    WHERE QUARTER(signup_date) = 1
      AND YEAR(signup_date) = 2024
    GROUP BY 1
)

-- join and calculate retention rate
SELECT
    wr.cohort_month,
    wr.weeks_since_signup,
    wr.users_retained,
    cs.cohort_size,
    ROUND(
        DIV0(wr.users_retained, cs.cohort_size) * 100
    , 2)                                            AS retention_rate_pct
FROM weekly_retention wr
LEFT JOIN cohort_sizes cs
    ON wr.cohort_month = cs.cohort_month
WHERE wr.weeks_since_signup IS NOT NULL
ORDER BY wr.cohort_month, wr.weeks_since_signup ASC;
