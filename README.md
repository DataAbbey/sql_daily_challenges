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
| 6/27 | Channel health report | MULTII-CONCEPT REVIEW: aggregation + CASE WHEN pivot + RANK() + derived metrics  |
---

## 7 day Checkin
> "Start where you are, use what you have, do what you can" - Anon

## The analyst's mindset — start with the blank audit

Often in analytics the data isn't perfect, the requirements aren't crystal clear, and the current business process looks different depending on which stakeholder, region, or purpose you're viewing it from. That doesn't mean there isn't valuable information to uncover. The best move is to start with a blank audit of where the business's knowledge actually stands — what don't they know that would change how they're currently doing something. Remember: small wins add up to bigger ones.

The hardest part of analytics isn't writing the query — it's knowing which question is actually worth answering. Most businesses are making decisions based on incomplete information without realizing it. They're not ignoring data, they're just measuring the wrong things, or measuring the right things at the wrong grain, or trusting a number that nobody has validated in two years. Your job as an analyst isn't just to answer the question they asked — it's to surface the question they didn't know they should be asking.

**Example — The metric that looked healthy:**

A retail operations team was tracking cancellation rate nationally and feeling good about the trend. The number was holding steady. But nobody had asked *why* people were canceling, or whether all cancellations were the same. When the data was pulled at the order level, one-third of cancellations were customers reordering the same item within 48 hours — not true cancellations at all, just friction in the ordering process. The "healthy" metric was masking a customer experience problem that was costing the business real revenue. One audit question — *"what does a cancellation actually mean in this data?"* — changed the entire conversation.

The pattern: the business wasn't failing. The data wasn't broken. The question was just slightly wrong — and nobody had stopped to ask whether the thing they were measuring was actually the thing that mattered. That's the blank audit. Not a data quality project. Not a dashboard rebuild. Just one honest question:

> *"What don't we know that would change how we're doing this?"*

Small wins. One question at a time. They add up.
