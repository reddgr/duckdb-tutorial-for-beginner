-- INSTALL azure;
-- LOAD azure;

-- Versión de DuckDB
SELECT version() AS version;
-- Comprobar plataforma
PRAGMA platform;
-- Extensiones de DuckDB instaladas
SELECT * FROM duckdb_extensions();
SELECT * FROM duckdb_extensions() WHERE extension_name = 'azure';

-- Comprobar variables de entorno
SELECT getenv('HF_TOKEN');
SELECT getenv('THEMATIC_SCREENER_CONNECTION_STRING');

SELECT * FROM duckdb_secrets();

-- Prueba de conexión al fichero de base de datos en Azure Blob Storage
ATTACH 'az://thematicscreener.blob.core.windows.net/thematicscreenerdb/thematic_screener.db' as tsdb;
USE tsdb;
SHOW TABLES;

PRAGMA database_size;

CALL pragma_database_size();

-- QUERY principal maestro
WITH LatestInfo AS (
    SELECT ticker, MAX(date) as latest_date FROM maestro
    WHERE ticker NOT IN ('GOOGL', 'GMKN.ME')
    AND currency NOT IN ('ILA', 'KWF')
    GROUP BY ticker
)
SELECT m.date, m.ticker, m.security, m.marketCap FROM maestro m JOIN LatestInfo lt ON m.ticker = lt.ticker AND m.date = lt.latest_date
ORDER BY m.marketCap DESC LIMIT 20;

-- prueba fichero csv
SELECT count(*)
FROM 'az://thematicscreener.blob.core.windows.net/thematicscreenerdb/maestro.csv';

-- Crear secreto no-persistente
CREATE SECRET secret1 (
    TYPE azure,
    CONNECTION_STRING '___________'
);
-- DROP SECRET secret1;