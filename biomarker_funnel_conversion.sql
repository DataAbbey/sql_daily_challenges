-- Challenge: Funnel Conversion Analysis
-- Pattern: Progressive CTEs - each step filters survivors of the previous step
-- Scenario: Track users through biomarker_test_ordered -> results_viewed -> consultation_booked
-- within a 30-day window, anchored to first occurrence of step 1

WITH step1_users AS (
    -- Anchor point: first time each user ordered a biomarker test
    SELECT
        user_id,
        MIN(event_timestamp) AS step1_time
    FROM events
    WHERE event_name = 'biomarker_test_ordered'
    GROUP BY user_id
),

step2_users AS (
    -- Find first results_viewed event after step1, within 30 days of step1
    SELECT
        s1.user_id,
        s1.step1_time,
        MIN(e.event_timestamp) AS step2_time
    FROM step1_users s1
    JOIN events e
        ON s1.user_id = e.user_id
        AND e.event_name = 'biomarker_results_viewed'
        AND e.event_timestamp >= s1.step1_time
        AND e.event_timestamp <= DATEADD('day', 30, s1.step1_time)
    GROUP BY s1.user_id, s1.step1_time
),

step3_users AS (
    -- Find first consultation_booked event after step2, still within 30 days of step1
    SELECT
        s2.user_id,
        s2.step1_time,
        s2.step2_time,
        MIN(e.event_timestamp) AS step3_time
    FROM step2_users s2
    JOIN events e
        ON s2.user_id = e.user_id
        AND e.event_name = 'consultation_booked'
        AND e.event_timestamp >= s2.step2_time
        AND e.event_timestamp <= DATEADD('day', 30, s2.step1_time)
    GROUP BY s2.user_id, s2.step1_time, s2.step2_time
)

-- Final: count users at each step and calculate conversion rates
SELECT
    'biomarker_test_ordered'      AS event_name,
    (SELECT COUNT(*) FROM step1_users)  AS num_users,
    100.0                                AS conversion_from_previous,
    100.0                                AS overall_conversion

UNION ALL

SELECT
    'biomarker_results_viewed',
    (SELECT COUNT(*) FROM step2_users),
    ROUND(100.0 * (SELECT COUNT(*) FROM step2_users) 
        / (SELECT COUNT(*) FROM step1_users), 2),
    ROUND(100.0 * (SELECT COUNT(*) FROM step2_users) 
        / (SELECT COUNT(*) FROM step1_users), 2)

UNION ALL

SELECT
    'consultation_booked',
    (SELECT COUNT(*) FROM step3_users),
    ROUND(100.0 * (SELECT COUNT(*) FROM step3_users) 
        / (SELECT COUNT(*) FROM step2_users), 2),
    ROUND(100.0 * (SELECT COUNT(*) FROM step3_users) 
        / (SELECT COUNT(*) FROM step1_users), 2);
