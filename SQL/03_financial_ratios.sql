-- Key financial ratios by company and sector
WITH ratio_analysis AS (
    SELECT
        company,
        category,
        year,
        ROUND(current_ratio::NUMERIC, 4)        AS current_ratio,
        ROUND(debt_equity_ratio::NUMERIC, 4)    AS debt_equity_ratio,
        ROUND(roe::NUMERIC, 4)                  AS roe,
        ROUND(roa::NUMERIC, 4)                  AS roa,
        ROUND(roi::NUMERIC, 4)                  AS roi,
        ROUND(net_profit_margin::NUMERIC, 4)    AS net_profit_margin,
        ROUND(eps::NUMERIC, 4)                  AS eps,
        ROUND(market_cap_b::NUMERIC, 2)         AS market_cap_b
    FROM financials
),
sector_avg AS (
    SELECT
        category,
        year,
        ROUND(AVG(current_ratio)::NUMERIC, 4)   AS sector_avg_current_ratio,
        ROUND(AVG(roe)::NUMERIC, 4)             AS sector_avg_roe,
        ROUND(AVG(roa)::NUMERIC, 4)             AS sector_avg_roa,
        ROUND(AVG(net_profit_margin)::NUMERIC, 4) AS sector_avg_margin
    FROM financials
    GROUP BY 
		category, 
		year
)
SELECT
    r.*,
    s.sector_avg_roe,
    s.sector_avg_roa,
    s.sector_avg_margin,
    ROUND((r.roe - s.sector_avg_roe)
          ::NUMERIC, 4)                         AS roe_vs_sector,
    RANK() OVER (
        PARTITION BY r.category, r.year
        ORDER BY r.roe DESC)                    AS roe_rank_in_sector
FROM ratio_analysis r
JOIN sector_avg s
    ON r.category = s.category
    AND r.year = s.year
ORDER BY 
	r.company, 
	r.year;