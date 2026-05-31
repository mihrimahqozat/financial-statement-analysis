DROP TABLE IF EXISTS financials;

CREATE TABLE financials (
    year                            INTEGER,
    company                         TEXT,
    category                        TEXT,
    market_cap_b                    NUMERIC(12, 2),
    revenue                         NUMERIC(20, 2),
    gross_profit                    NUMERIC(20, 2),
    net_income                      NUMERIC(20, 2),
    eps                             NUMERIC(10, 4),
    ebitda                          NUMERIC(20, 2),
    shareholder_equity              NUMERIC(20, 2),
    cfo                             NUMERIC(20, 2),
    cfi                             NUMERIC(20, 2),
    cff                             NUMERIC(20, 2),
    current_ratio                   NUMERIC(10, 4),
    debt_equity_ratio               NUMERIC(10, 4),
    roe                             NUMERIC(10, 4),
    roa                             NUMERIC(10, 4),
    roi                             NUMERIC(10, 4),
    net_profit_margin               NUMERIC(10, 4),
    fcf_per_share                   NUMERIC(10, 4),
    return_on_tangible_equity       NUMERIC(10, 4),
    num_employees                   INTEGER,
    inflation_rate                  NUMERIC(8, 4)
);