# SQL Practice Log

Daily SQL practice — one query a day, real product analytics scenarios.
Goal: build muscle memory, not perfection.

## Practice Log

| Date | Challenge | Pattern Practiced |
|------|-----------|-------------------|
| 6/20 | Funnel conversion | Progressive CTEs |
| 6/20 | Cohort threshold | Aggregate then classify |
| 6/20 | Churn flag | QUALIFY + ROW_NUMBER |
| 6/20 | WoW subscriber growth | Aggregate then LAG |
| 6/21 | Support resolution efficiency | Derived metric + aggregate-then-LAG |
| 6/22 | Top 3 products by category | Aggregate → RANK() → filter, two-CTE pattern |
| 6/22 | Top 2 channels by region | Aggregate → RANK() → QUALIFY, most efficient solution |
| 6/23 | Avg days between consecutive orders | LAG() for sequential row comparison + cohort threshold |
| 6/23 | First purchase attribution by channel | MIN() first event + cohort threshold +
| 6/25 | Weekly retention by cohort | Separate cohort size CTE + activity CTE, different grains |
| 6/26 | Cumulative revenue by channel | SUM() OVER running total — ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW vs no ROWS BETWEEN |
---

## 7 day Checkin
> "Start where you are, use what you have, do what you can" - Anon

Often in analytics the data isn't perfect, the requirements aren't 
crystal clear, and the current business process looks different 
depending on which stakeholder, region, or purpose you're viewing it 
from. That doesn't mean there isn't valuable information to uncover. 
The best move is to start with a blank audit of where the business's 
knowledge actually stands — what don't they know that would change 
how they're currently doing something. Remember: small wins add up 
to bigger ones.
