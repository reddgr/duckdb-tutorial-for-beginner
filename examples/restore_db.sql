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

-- Renombrar la base de datos original. En PowerShell:
ren thematic_screener.db thematic_screener_orig.db

-- Ejecutando el siguiente comando, Duckdb crea un fichero de base de datos si no existe aún:
duckdb C:\Users\david\Documents\git\miax-tfm-dgr\db\thematic_screener.db;

-- Una vez que tenemos el fichero de base de datos, podemos conectarnos:
duckdb;
ATTACH 'thematic_screener.db';
USE thematic_screener;
SHOW TABLES;

-- Copiamos el contenido de la base de datos original a la base de datos nueva
ATTACH 'thematic_screener_orig.db';
ATTACH 'thematic_screener.db';
COPY FROM DATABASE thematic_screener_orig TO thematic_screener;