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

-- Muestra del formato de fecha en la tabla maestro
SELECT DISTINCT date FROM maestro ORDER BY date;

-- Convertimos la columna date a tipo DATE
ALTER TABLE maestro
ALTER COLUMN date TYPE DATE USING date::DATE;

-- Verificamos el cambio
SELECT DISTINCT date FROM maestro ORDER BY date;
SELECT DISTINCT date FROM maestro ORDER BY date DESC;



SELECT DISTINCT regularMarketVolume FROM maestro LIMIT 5; -- convertir a INT

-- Casting a INT de campos varios
ALTER TABLE maestro ALTER COLUMN regularMarketVolume TYPE INTEGER;
ALTER TABLE maestro ALTER COLUMN volume TYPE INTEGER;  
ALTER TABLE maestro ALTER COLUMN averageVolume10days TYPE INTEGER;
ALTER TABLE maestro ALTER COLUMN averageDailyVolume10Day TYPE INTEGER;
ALTER TABLE maestro ALTER COLUMN averageVolume TYPE INTEGER;

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