-- Revenue and profitability trends by company and year
WITH profitability AS (
    SELECT
        company,
        category,
        year,
        ROUND(revenue::NUMERIC, 2)              AS revenue,
        ROUND(gross_profit::NUMERIC, 2)         AS gross_profit,
        ROUND(net_income::NUMERIC, 2)           AS net_income,
        ROUND(ebitda::NUMERIC, 2)               AS ebitda,
        ROUND(market_cap_b::NUMERIC, 2)         AS market_cap_b,
        ROUND((gross_profit / NULLIF(
            revenue, 0) * 100)::NUMERIC, 2)     AS gross_margin_pct,
        ROUND((net_income / NULLIF(
            revenue, 0) * 100)::NUMERIC, 2)     AS net_margin_pct,
        ROUND((ebitda / NULLIF(
            revenue, 0) * 100)::NUMERIC, 2)     AS ebitda_margin_pct
    FROM financials
    WHERE revenue > 0
),
with_growth AS (
    SELECT *,
        LAG(revenue) OVER (
            PARTITION BY company ORDER BY year) AS prev_revenue,
        ROUND((revenue - LAG(revenue) OVER (
                PARTITION BY company
                ORDER BY year)) * 100.0 /
            NULLIF(LAG(revenue) OVER (
                PARTITION BY company
                ORDER BY year), 0) ::NUMERIC, 2) AS revenue_growth_pct
    FROM profitability
)
SELECT *
FROM with_growth
ORDER BY 
	company, 
	year;