-- Installing DuckDB:
-- Windows: 
-- winget install DuckDB.cli
-- Linux/MacOS:
-- curl https://install.duckdb.org | sh

-- Para ejecutar las queries sobre thematic_screener.db, ejecutar duckdb en la terminal, en el directorio "db"
-- DuckDB es una base de datos SQL embebida, por lo que no requiere un servidor separado para funcionar.
-- DuckDB se puede usar en la terminal, o directamente en nuestro entorno Python. 
-- Para ejecutar las queries de este fichero, uso Visual Studio Code con el siguiente tajo que configuro en keyboard shortcuts:
--{
--    "key": "shift+enter",
--    "command": "workbench.action.terminal.runSelectedText"
--}
-- Una vez configurado el atajo, selecciono la query y le doy a shift+enter para ejecutarla en la terminal en la que tengo abierto duckdb.

ATTACH 'thematic_screener.db';
USE thematic_screener;
SHOW TABLES;

COPY maestro TO 'maestro.parquet' (FORMAT parquet);

SELECT DISTINCT date FROM maestro ORDER BY date DESC;

-- QUERY principal maestro
WITH LatestInfo AS (
    SELECT ticker, MAX(date) as latest_date FROM maestro 
    WHERE ticker NOT IN ('GOOGL', 'GMKN.ME')
    AND currency NOT IN ('ILA', 'KWF')
    GROUP BY ticker
)
SELECT m.* FROM maestro m JOIN LatestInfo lt ON m.ticker = lt.ticker AND m.date = lt.latest_date
ORDER BY m.marketCap DESC;


-- QUERY para tickers que tienen como fecha más reciente una concreta
WITH LatestInfo AS (
    SELECT ticker, MAX(date) as latest_date FROM maestro 
    WHERE ticker NOT IN ('GOOGL', 'PLACEHOLDER')
    AND currency NOT IN ('ILA', 'KWF')
    GROUP BY ticker
    HAVING MAX(date) = '2025-03-30'
)
SELECT m.* FROM maestro m JOIN LatestInfo lt ON m.ticker = lt.ticker AND m.date = lt.latest_date
ORDER BY m.marketCap DESC;



SELECT * FROM tickers;

SELECT * FROM maestro;

SELECT * FROM close_prices;

SELECT date, AAPL FROM close_prices;

-- Consulta para obtener los precios de cierre de AMZN entre el 6 y el 18 de enero de 2025
SELECT date, AMZN FROM close_prices
WHERE date BETWEEN '2025-01-06' AND '2025-01-18';

-- Guardar datos de IBM para un rango de fechas específico en un archivo
COPY (SELECT date, IBM FROM close_prices
WHERE date BETWEEN '2025-02-01' AND '2025-02-10') TO 'ibm_close_prices_query.txt';

-- Ranking de los activos por capitalización de mercado (antes de casting)
SELECT date, ticker, security, CAST(marketCap AS DOUBLE) as marketCap, currency
FROM maestro
WHERE (currency IN ('USD', 'EUR') and ticker != 'GOOGL')
ORDER BY marketCap DESC
LIMIT 20;

-- Ranking de los activos por capitalización de mercado
SELECT date, ticker, security, marketCap, currency
FROM maestro
WHERE (currency IN ('USD', 'EUR') and ticker != 'GOOGL')
ORDER BY marketCap DESC
LIMIT 20;

-- Describe la tabla maestro para ver los tipos de datos de las columnas
DESCRIBE TABLE maestro;

-- Verifica el tipo de dato de la columna marketCap en la tabla maestro
SELECT column_name, data_type 
FROM information_schema.columns
WHERE table_name = 'maestro' AND column_name = 'marketCap';

-- Alter table to change the data type of marketCap column to DOUBLE
ALTER TABLE maestro 
ALTER COLUMN marketCap TYPE DOUBLE;

-- Verify the change
SELECT column_name, data_type 
FROM information_schema.columns
WHERE table_name = 'maestro' AND column_name = 'marketCap';


-- Ranking de los activos por capitalización de mercado
SELECT date, ticker, security, marketCap, currency
FROM maestro
WHERE (currency IN ('USD', 'EUR') and ticker != 'GOOGL')
ORDER BY marketCap DESC
LIMIT 20;


-- Ranking de los activos por marketCap (capitalización de mercado)
SELECT date, ticker, security, CAST(marketCap AS DOUBLE) as marketCap, currency
FROM maestro
WHERE (currency IN ('USD', 'EUR') and ticker != 'GOOGL')
ORDER BY marketCap DESC
LIMIT 20;

-- Ranking de los activos por marketCap (capitalización de mercado) en España
WITH LatestInfo AS (
    SELECT ticker, MAX(date) as latest_date
    FROM maestro WHERE country = 'Spain'
    GROUP BY ticker
)
SELECT m.date, m.ticker, m.security, m.marketCap, m.city, m.currency
FROM maestro m
JOIN LatestInfo lt ON m.ticker = lt.ticker AND m.date = lt.latest_date
ORDER BY m.marketCap DESC
LIMIT 30;


-- Ejemplo de query "compleja" (activos con mayor revalorización desde su mínimo de 52 semanas)
WITH LatestInfo AS (
    SELECT ticker, MAX(date) as latest_date FROM maestro 
    WHERE ticker NOT IN ('GOOGL', 'PLACEHOLDER')
    AND currency NOT IN ('ILA', 'KWF')
    GROUP BY ticker
)
SELECT 
    m.ticker, m.security, m.fiftyTwoWeekLow, m.previousClose,
    CASE 
        WHEN m.fiftyTwoWeekLow > 0 THEN ((m.previousClose - m.fiftyTwoWeekLow) / m.fiftyTwoWeekLow) * 100 
        ELSE NULL 
    END AS pct_above_52w_low
FROM maestro m
JOIN LatestInfo lt ON m.ticker = lt.ticker AND m.date = lt.latest_date
WHERE m.marketCap > 10e9
ORDER BY pct_above_52w_low DESC
LIMIT 20;



--  Activos con mayor caída desde su máximo de 52 semanas
WITH LatestInfo AS (
    SELECT ticker, MAX(date) as latest_date FROM maestro 
    WHERE ticker NOT IN ('GOOGL', 'PLACEHOLDER')
    AND currency NOT IN ('ILA', 'KWF')
    GROUP BY ticker
)
SELECT 
    m.ticker, m.security, m.fiftyTwoWeekHigh, m.previousClose,
    CASE 
        WHEN m.fiftyTwoWeekHigh > 0 THEN ((m.previousClose - m.fiftyTwoWeekHigh) / m.fiftyTwoWeekHigh) * 100 
        ELSE NULL 
    END AS pct_from_52w_high
FROM maestro m
JOIN LatestInfo lt ON m.ticker = lt.ticker AND m.date = lt.latest_date
WHERE m.marketCap > 10e9
ORDER BY pct_from_52w_high ASC
LIMIT 20;


SELECT * FROM maestro WHERE ticker in ('IKM.MC', 'YADR.MC', 'YADV.MC', 'AMEN.MC', 'YAI1.MC', 'ALQ.MC', 'ALC.MC', 'YAP67.MC', 
'YARP.MC', 'ART.MC', 'YATO.MC', 'APG.MC', 'YAZR.MC', 'YBAR.MC', 'BST.MC', 'CLR.MC');