-- Multi-dimensional company ranking using window functions
WITH company_metrics AS (
    SELECT
        company,
        category,
        year,
        revenue,
        net_income,
        market_cap_b,
        roe,
        roa,
        net_profit_margin,
        cfo,
        debt_equity_ratio,
        eps
    FROM financials
    WHERE revenue > 0 AND net_income IS NOT NULL
),
ranked AS (
    SELECT *,
        -- Global rankings per year
        RANK() OVER (
            PARTITION BY year
            ORDER BY revenue DESC)              AS revenue_rank,
        RANK() OVER (
            PARTITION BY year
            ORDER BY net_income DESC)           AS profit_rank,
        RANK() OVER (
            PARTITION BY year
            ORDER BY market_cap_b DESC
            NULLS LAST)                         AS mktcap_rank,
        RANK() OVER (
            PARTITION BY year
            ORDER BY roe DESC)                  AS roe_rank,
        -- Sector rankings per year
        RANK() OVER (
            PARTITION BY category, year
            ORDER BY net_profit_margin DESC)    AS margin_rank_in_sector,
        -- Running totals
        ROUND(SUM(revenue) OVER (
            PARTITION BY company
            ORDER BY year
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW)
            ::NUMERIC, 2)                       AS cumulative_revenue,
        -- YoY EPS growth
        LAG(eps) OVER (
            PARTITION BY company
            ORDER BY year)                      AS prev_eps,
        ROUND(((eps - LAG(eps) OVER (
            PARTITION BY company
            ORDER BY year)) * 100.0 /
            NULLIF(LAG(eps) OVER (
                PARTITION BY company
                ORDER BY year), 0))
            ::NUMERIC, 2)                       AS eps_growth_pct,
        -- 3-year avg ROE
        ROUND(AVG(roe) OVER (
            PARTITION BY company
            ORDER BY year
            ROWS BETWEEN 2 PRECEDING
            AND CURRENT ROW)
            ::NUMERIC, 4)                       AS rolling_3yr_roe
    FROM company_metrics
)
SELECT *
FROM ranked
ORDER BY 
	year DESC, 
	revenue_rank;