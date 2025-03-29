-- Installing DuckDB: 
-- winget install DuckDB.cli
-- curl https://install.duckdb.org | sh

ATTACH 'thematic_screener.db';

USE thematic_screener;

SHOW TABLES;

SELECT * FROM tickers;

SELECT * FROM close_prices;

SELECT date, AAPL FROM close_prices;

SELECT date, AMZN FROM close_prices
WHERE date BETWEEN '2025-01-06' AND '2025-01-18';

SELECT date, AMZN FROM close_prices
WHERE date BETWEEN '2025-01-06' AND '2025-01-18';

COPY (SELECT date, IBM FROM close_prices
WHERE date BETWEEN '2025-02-01' AND '2025-02-10') TO 'ibm_close_prices_query.txt';