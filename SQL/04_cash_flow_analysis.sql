-- Cash flow health analysis
WITH cash_flow AS (
    SELECT
        company,
        category,
        year,
        ROUND(cfo::NUMERIC, 2)                  AS operating_cf,
        ROUND(cfi::NUMERIC, 2)                  AS investing_cf,
        ROUND(cff::NUMERIC, 2)                  AS financing_cf,
        ROUND((cfo + cfi + cff)::NUMERIC, 2)    AS net_cash_flow,
        ROUND(fcf_per_share::NUMERIC, 4)        AS fcf_per_share,
        ROUND(net_income::NUMERIC, 2)           AS net_income,
        ROUND(revenue::NUMERIC, 2)              AS revenue,
        -- Cash flow quality ratio
        ROUND((cfo / NULLIF(net_income, 0))
            ::NUMERIC, 4)                       AS cf_quality_ratio,
        -- Operating CF margin
        ROUND((cfo / NULLIF(revenue, 0) * 100)
            ::NUMERIC, 2)                       AS ocf_margin_pct
    FROM financials
    WHERE revenue > 0
)
SELECT *,
    CASE
        WHEN operating_cf > 0
         AND investing_cf < 0
         AND financing_cf < 0 THEN 'Mature/Profitable'
        WHEN operating_cf > 0
         AND investing_cf < 0
         AND financing_cf > 0 THEN 'Growing'
        WHEN operating_cf < 0
         AND investing_cf < 0
         AND financing_cf > 0 THEN 'Early Stage'
        WHEN operating_cf > 0
         AND investing_cf > 0
         AND financing_cf < 0 THEN 'Restructuring'
        ELSE 'Other'
    END                                         AS cf_profile,
    RANK() OVER (
        PARTITION BY category, year
        ORDER BY operating_cf DESC)             AS ocf_rank_in_sector
FROM cash_flow
ORDER BY 
	company, 
	year;