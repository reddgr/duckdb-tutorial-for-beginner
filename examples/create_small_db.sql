-- Installing DuckDB:
-- Windows: 
-- winget install DuckDB.cli
-- Linux/MacOS:
-- curl https://install.duckdb.org | sh

-- Para ejecutar las queries sobre thematic_screener.db, ejecutar duckdb en la terminal, en el directorio "db"
cd C:\Users\david\Documents\git\miax-tfm-dgr\db;

-- Para ejecutar las queries sobre thematic_screener.db, ejecutar duckdb en la terminal, en el directorio "db"
-- DuckDB es una base de datos SQL embebida, por lo que no requiere un servidor separado para funcionar.
-- DuckDB se puede usar en la terminal, o directamente en nuestro entorno Python. 
-- Para ejecutar las queries de este fichero, uso Visual Studio Code con el siguiente tajo que configuro en keyboard shortcuts:
--{
--    "key": "shift+enter",
--    "command": "workbench.action.terminal.runSelectedText"
--}
-- Una vez configurado el atajo, selecciono la query y le doy a shift+enter para ejecutarla en la terminal en la que tengo abierto duckdb.

-- Ejecutando el siguiente comando, Duckdb crea un fichero de base de datos si no existe aún:
duckdb C:\Users\david\Documents\git\miax-tfm-dgr\db\thematic_screener_small.db;

-- Una vez que tenemos el fichero de base de datos, podemos conectarnos:
duckdb;
ATTACH 'thematic_screener_small.db';
USE thematic_screener_small;
SHOW TABLES;

-- Copiamos el contenido de la base de datos principal a la base de datos nueva
duckdb;
ATTACH 'thematic_screener_small.db';
ATTACH 'thematic_screener.db';
COPY FROM DATABASE thematic_screener TO thematic_screener_small;

-- Podemos hacerlo recurrentemente para reducir el tamaño del fichero:
duckdb;
ATTACH 'thematic_screener_small0.db';
ATTACH 'thematic_screener_small.db';
COPY FROM DATABASE thematic_screener_small0 TO thematic_screener_small;

-- Comprobamos el contenido de la nueva base de datos:
ATTACH 'thematic_screener_small.db';
USE thematic_screener_small;
SHOW TABLES;
CHECKPOINT;
SELECT date, COUNT(*) as record_count FROM maestro GROUP BY date ORDER BY date;
-- QUERY principal maestro
WITH LatestInfo AS (
    SELECT ticker, MAX(date) as latest_date FROM maestro 
    WHERE ticker NOT IN ('GOOGL', 'GMKN.ME')
    AND currency NOT IN ('ILA', 'KWF')
    GROUP BY ticker
)
SELECT m.* FROM maestro m JOIN LatestInfo lt ON m.ticker = lt.ticker AND m.date = lt.latest_date
ORDER BY m.marketCap DESC LIMIT 20;

-- Textos de descripción (los vamos a dejar sólo en la tabla principal):
WITH LatestInfo AS (
    SELECT ticker, MAX(date) as latest_date FROM maestro 
    WHERE ticker NOT IN ('GOOGL', 'GMKN.ME')
    AND currency NOT IN ('ILA', 'KWF')
    GROUP BY ticker
)
SELECT m.ticker, m.longBusinessSummary FROM maestro m JOIN LatestInfo lt ON m.ticker = lt.ticker AND m.date = lt.latest_date
ORDER BY m.marketCap DESC LIMIT 20;

-- Borramos fechas antiguas (poniendo la fecha):
DELETE FROM maestro WHERE date < '2025-04-17';
-- O quedándonos con las 3 más recientes:
DELETE FROM maestro 
WHERE date NOT IN (
    SELECT DISTINCT date
    FROM maestro
    ORDER BY date DESC
    LIMIT 3
);

-- Borramos la columna longBusinessSummary de la tabla maestro:
ALTER TABLE maestro DROP COLUMN longBusinessSummary;
CHECKPOINT;

CHECKPOINT thematic_screener_small;

ALTER TABLE maestro DROP COLUMN address1;
ALTER TABLE maestro DROP COLUMN phone;
ALTER TABLE maestro DROP COLUMN governanceEpochDate;
ALTER TABLE maestro DROP COLUMN maxAge;
ALTER TABLE maestro DROP COLUMN tradeable;
ALTER TABLE maestro DROP COLUMN SandP52WeekChange;
ALTER TABLE maestro DROP COLUMN language;
ALTER TABLE maestro DROP COLUMN region;
ALTER TABLE maestro DROP COLUMN typeDisp;
ALTER TABLE maestro DROP COLUMN quoteSourceName;
ALTER TABLE maestro DROP COLUMN esgPopulated;
ALTER TABLE maestro DROP COLUMN postMarketTime;
ALTER TABLE maestro DROP COLUMN regularMarketTime;
ALTER TABLE maestro DROP COLUMN marketState;
ALTER TABLE maestro DROP COLUMN exchangeDataDelayedBy;
ALTER TABLE maestro DROP COLUMN cryptoTradeable;
ALTER TABLE maestro DROP COLUMN postMarketChangePercent;
ALTER TABLE maestro DROP COLUMN postMarketPrice;
ALTER TABLE maestro DROP COLUMN postMarketChange;
ALTER TABLE maestro DROP COLUMN isEarningsDateEstimate;
ALTER TABLE maestro DROP COLUMN gmtOffSetMilliseconds;
ALTER TABLE maestro DROP COLUMN compensationAsOfEpochDate;
ALTER TABLE maestro DROP COLUMN sharesShortPreviousMonthDate;
ALTER TABLE maestro DROP COLUMN dateShortInterest;
ALTER TABLE maestro DROP COLUMN dividendDate;
ALTER TABLE maestro DROP COLUMN earningsTimestamp;
ALTER TABLE maestro DROP COLUMN earningsTimestampStart;
ALTER TABLE maestro DROP COLUMN earningsTimestampEnd;
ALTER TABLE maestro DROP COLUMN priceHint;
ALTER TABLE maestro DROP COLUMN triggerable;
ALTER TABLE maestro DROP COLUMN customPriceAlertConfidence;
ALTER TABLE maestro DROP COLUMN messageBoardId;
ALTER TABLE maestro DROP COLUMN hasPrePostMarketData;
ALTER TABLE maestro DROP COLUMN sourceInterval;
ALTER TABLE maestro DROP COLUMN open;
ALTER TABLE maestro DROP COLUMN dayLow;
ALTER TABLE maestro DROP COLUMN dayHigh;
ALTER TABLE maestro DROP COLUMN regularMarketPreviousClose;
ALTER TABLE maestro DROP COLUMN bid;
ALTER TABLE maestro DROP COLUMN ask;
ALTER TABLE maestro DROP COLUMN bidSize;
ALTER TABLE maestro DROP COLUMN askSize;
ALTER TABLE maestro DROP COLUMN regularMarketOpen;
ALTER TABLE maestro DROP COLUMN regularMarketDayLow;
ALTER TABLE maestro DROP COLUMN regularMarketDayHigh;
ALTER TABLE maestro DROP COLUMN twoHundredDayAverage;
ALTER TABLE maestro DROP COLUMN lastDividendValue;
ALTER TABLE maestro DROP COLUMN targetHighPrice;
ALTER TABLE maestro DROP COLUMN targetLowPrice;
ALTER TABLE maestro DROP COLUMN targetMeanPrice;
ALTER TABLE maestro DROP COLUMN targetMedianPrice;
ALTER TABLE maestro DROP COLUMN regularMarketPrice;
ALTER TABLE maestro DROP COLUMN regularMarketChangePercent;
ALTER TABLE maestro DROP COLUMN fiftyTwoWeekLowChange;
ALTER TABLE maestro DROP COLUMN fiftyTwoWeekHighChange;
ALTER TABLE maestro DROP COLUMN fiftyTwoWeekLow;
ALTER TABLE maestro DROP COLUMN fiftyTwoWeekHigh;
ALTER TABLE maestro DROP COLUMN fiftyDayAverage;
ALTER TABLE maestro DROP COLUMN dividendRate;
ALTER TABLE maestro DROP COLUMN regularMarketChange;
ALTER TABLE maestro DROP COLUMN exDividendDate;
ALTER TABLE maestro DROP COLUMN lastFiscalYearEnd;
ALTER TABLE maestro DROP COLUMN nextFiscalYearEnd;
ALTER TABLE maestro DROP COLUMN mostRecentQuarter;
ALTER TABLE maestro DROP COLUMN nameChangeDate;
ALTER TABLE maestro DROP COLUMN lastSplitDate;
ALTER TABLE maestro DROP COLUMN lastDividendDate;
ALTER TABLE maestro DROP COLUMN regularMarketVolume;
ALTER TABLE maestro DROP COLUMN volume;
ALTER TABLE maestro DROP COLUMN averageDailyVolume10Day;
ALTER TABLE maestro DROP COLUMN averageDailyVolume3Month;
ALTER TABLE maestro DROP COLUMN epsTrailingTwelveMonths;
ALTER TABLE maestro DROP COLUMN averageVolume10days;
ALTER TABLE maestro DROP COLUMN auditRisk;
ALTER TABLE maestro DROP COLUMN boardRisk;
ALTER TABLE maestro DROP COLUMN compensationRisk;
ALTER TABLE maestro DROP COLUMN shareHolderRightsRisk;
ALTER TABLE maestro DROP COLUMN overallRisk;