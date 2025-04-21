-- Installing DuckDB:
-- Windows: 
-- winget install DuckDB.cli
-- Linux/MacOS:
-- curl https://install.duckdb.org | sh

-- Para ejecutar las queries sobre thematic_screener.db, ejecutar duckdb en la terminal, en el directorio "db"
-- DuckDB es una base de datos SQL embebida, por lo que no requiere un servidor separado para funcionar.
-- DuckDB se puede usar en la terminal, o directamente en nuestro entorno Python. 
-- Para ejecutar las queries de este fichero, uso Visual Studio Code con el siguiente tajo que configuro en "Keyboard Shortcuts (JSON)":
--{
--    "key": "shift+enter",
--    "command": "workbench.action.terminal.runSelectedText"
--}
-- Una vez configurado el atajo, selecciono la query y le doy a shift+enter para ejecutarla en la terminal en la que tengo abierto duckdb.

-- Inicialización de DuckDB y conexión a la base de datos thematic_screener.db
ATTACH 'thematic_screener.db';
USE thematic_screener;
SHOW TABLES;

-- Describe la tabla maestro para ver los tipos de datos de las columnas
DESCRIBE TABLE maestro;
-- Para una columna en concreto:
DESCRIBE SELECT auditRisk FROM maestro;
DESCRIBE SELECT companyOfficers FROM maestro;
DESCRIBE SELECT dayLow FROM maestro;
DESCRIBE SELECT exDividendDate FROM maestro;
DESCRIBE SELECT gmtOffSetMilliseconds FROM maestro;
DESCRIBE SELECT averageDailyVolume3Month FROM maestro;

-- Muestra del formato de fecha en la tabla maestro
SELECT DISTINCT date FROM maestro ORDER BY date;
-- Convertimos la columna date a tipo DATE
ALTER TABLE maestro ALTER COLUMN date TYPE DATE USING date::DATE;
-- Verificamos el cambio
SELECT DISTINCT date FROM maestro ORDER BY date;
SELECT DISTINCT date FROM maestro ORDER BY date DESC;

-- Otras conversiones a DATE
ALTER TABLE maestro ALTER COLUMN nameChangeDate TYPE DATE USING nameChangeDate::DATE;
SELECT DISTINCT nameChangeDate FROM maestro ORDER BY nameChangeDate;
SELECT DISTINCT nameChangeDate FROM maestro ORDER BY nameChangeDate DESC;

SELECT DISTINCT regularMarketVolume FROM maestro LIMIT 5; -- convertir a INT

-- Casting a INT de campos varios
ALTER TABLE maestro ALTER COLUMN regularMarketVolume TYPE INTEGER;
ALTER TABLE maestro ALTER COLUMN volume TYPE INTEGER;  
ALTER TABLE maestro ALTER COLUMN averageVolume10days TYPE INTEGER;
ALTER TABLE maestro ALTER COLUMN averageDailyVolume10Day TYPE INTEGER;
ALTER TABLE maestro ALTER COLUMN averageVolume TYPE INTEGER;
ALTER TABLE maestro ALTER COLUMN sharesShort TYPE INTEGER;
ALTER TABLE maestro ALTER COLUMN sharesShortPriorMonth TYPE INTEGER;
ALTER TABLE maestro ALTER COLUMN gmtOffSetMilliseconds TYPE INTEGER;

-- timestamps (a integer)
ALTER TABLE maestro ALTER COLUMN exDividendDate TYPE INTEGER;
ALTER TABLE maestro ALTER COLUMN governanceEpochDate TYPE INTEGER;
ALTER TABLE maestro ALTER COLUMN compensationAsOfEpochDate TYPE INTEGER;
ALTER TABLE maestro ALTER COLUMN sharesShortPreviousMonthDate TYPE INTEGER;
ALTER TABLE maestro ALTER COLUMN dateShortInterest TYPE INTEGER;
ALTER TABLE maestro ALTER COLUMN lastFiscalYearEnd TYPE INTEGER;
ALTER TABLE maestro ALTER COLUMN nextFiscalYearEnd TYPE INTEGER;
ALTER TABLE maestro ALTER COLUMN mostRecentQuarter TYPE INTEGER;
ALTER TABLE maestro ALTER COLUMN lastSplitDate TYPE INTEGER;
ALTER TABLE maestro ALTER COLUMN lastDividendDate TYPE INTEGER;
ALTER TABLE maestro ALTER COLUMN postMarketTime TYPE INTEGER;
ALTER TABLE maestro ALTER COLUMN regularMarketTime TYPE INTEGER;
ALTER TABLE maestro ALTER COLUMN dividendDate TYPE INTEGER;
ALTER TABLE maestro ALTER COLUMN earningsTimestamp TYPE INTEGER;
ALTER TABLE maestro ALTER COLUMN earningsTimestampStart TYPE INTEGER;
ALTER TABLE maestro ALTER COLUMN earningsTimestampEnd TYPE INTEGER;
ALTER TABLE maestro ALTER COLUMN earningsTimestampStart TYPE INTEGER;
ALTER TABLE maestro ALTER COLUMN earningsCallTimestampStart TYPE INTEGER;
ALTER TABLE maestro ALTER COLUMN earningsCallTimestampEnd TYPE INTEGER;
ALTER TABLE maestro ALTER COLUMN earningsCallTimestampStart TYPE INTEGER;
ALTER TABLE maestro ALTER COLUMN fundInceptionDate TYPE INTEGER;

-- timestamps (a BIGINT)
ALTER TABLE maestro ALTER COLUMN firstTradeDateMilliseconds TYPE BIGINT;

-- Casting a SMALLINT (2 bytes) de campos varios
ALTER TABLE maestro ALTER COLUMN auditRisk TYPE SMALLINT;
ALTER TABLE maestro ALTER COLUMN boardRisk TYPE SMALLINT;
ALTER TABLE maestro ALTER COLUMN compensationRisk TYPE SMALLINT;
ALTER TABLE maestro ALTER COLUMN shareHolderRightsRisk TYPE SMALLINT;
ALTER TABLE maestro ALTER COLUMN overallRisk TYPE SMALLINT;
ALTER TABLE maestro ALTER COLUMN numberOfAnalystOpinions TYPE SMALLINT;
-- Comprobar el cambio
SELECT DISTINCT compensationRisk FROM maestro ORDER BY compensationRisk;


ALTER TABLE maestro ALTER COLUMN exDividendDate TYPE TIMESTAMP;

-- Casting a BIGINT (8 bytes) de campos varios
ALTER TABLE maestro ALTER COLUMN floatShares TYPE BIGINT;
ALTER TABLE maestro ALTER COLUMN sharesOutstanding TYPE BIGINT;
ALTER TABLE maestro ALTER COLUMN impliedSharesOutstanding TYPE BIGINT;
ALTER TABLE maestro ALTER COLUMN netIncomeToCommon TYPE BIGINT;
ALTER TABLE maestro ALTER COLUMN averageDailyVolume3Month TYPE BIGINT;

-- Casting a DOUBLE
ALTER TABLE maestro ALTER COLUMN totalCash TYPE DOUBLE;
ALTER TABLE maestro ALTER COLUMN ebitda TYPE DOUBLE;
ALTER TABLE maestro ALTER COLUMN totalDebt TYPE DOUBLE;
ALTER TABLE maestro ALTER COLUMN totalRevenue TYPE DOUBLE;
ALTER TABLE maestro ALTER COLUMN grossProfits TYPE DOUBLE;
ALTER TABLE maestro ALTER COLUMN freeCashflow TYPE DOUBLE;
ALTER TABLE maestro ALTER COLUMN operatingCashflow TYPE DOUBLE;
ALTER TABLE maestro ALTER COLUMN trailingThreeMonthNavReturns TYPE DOUBLE;
ALTER TABLE maestro ALTER COLUMN preMarketPrice TYPE DOUBLE;
ALTER TABLE maestro ALTER COLUMN preMarketChange TYPE DOUBLE;
ALTER TABLE maestro ALTER COLUMN threeYearAverageReturn TYPE DOUBLE;
ALTER TABLE maestro ALTER COLUMN beta3Year TYPE DOUBLE;
ALTER TABLE maestro ALTER COLUMN ytdReturn TYPE DOUBLE;
ALTER TABLE maestro ALTER COLUMN totalAssets TYPE DOUBLE;
ALTER TABLE maestro ALTER COLUMN netExpenseRatio TYPE DOUBLE;
ALTER TABLE maestro ALTER COLUMN trailingThreeMonthReturns TYPE DOUBLE;
ALTER TABLE maestro ALTER COLUMN yield TYPE DOUBLE;
ALTER TABLE maestro ALTER COLUMN netAssets TYPE DOUBLE;
ALTER TABLE maestro ALTER COLUMN navPrice TYPE DOUBLE;
ALTER TABLE maestro ALTER COLUMN preMarketChangePercent TYPE DOUBLE;

-- Casting a BIGINT  ... NO EJECUTADO!!!
ALTER TABLE maestro ALTER COLUMN averageVolume TYPE BIGINT;
-- Casting a BIGINT  ... NO EJECUTADO!!! Por el momento no lo veo necesario


-- ALTER TABLE maestro ALTER COLUMN companyOfficers TYPE JSON;
-- Serializaremos el JSON de este campo con Pandas (no merece la pena con DuckDB)
SELECT companyOfficers FROM maestro LIMIT 1;


-- Ranking de los activos por volumen (solo fecha más reciente por ticker)
WITH LatestInfo AS (
    SELECT ticker, MAX(date) as latest_date
    FROM maestro
    GROUP BY ticker
)
SELECT m.date, m.ticker, m.security, m.averageVolume10days
FROM maestro m
JOIN LatestInfo lt ON m.ticker = lt.ticker AND m.date = lt.latest_date
ORDER BY m.averageVolume10days DESC
LIMIT 20;


ALTER TABLE maestro ALTER COLUMN fullTimeEmployees TYPE INTEGER;

-- Ranking de los activos por número de empleados
WITH LatestInfo AS (
    SELECT ticker, MAX(date) as latest_date
    FROM maestro
    GROUP BY ticker
)
SELECT m.date, m.ticker, m.security, m.fullTimeEmployees
FROM maestro m
JOIN LatestInfo lt ON m.ticker = lt.ticker AND m.date = lt.latest_date
ORDER BY m.fullTimeEmployees DESC
LIMIT 30;


-- Casting a DOUBLE de campos varios
ALTER TABLE maestro 
ALTER COLUMN ____,  TYPE DOUBLE;

-- Ajuste manual de un tipo de cambio
UPDATE exchange_rates 
SET exchange_rate = 0.05103
WHERE currency_pair = 'ZACUSD';


