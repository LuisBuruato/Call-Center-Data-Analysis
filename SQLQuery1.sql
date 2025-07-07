CREATE DATABASE CallCenterDB;
GO

-- Usar la base destino
USE CallCenterDB;
GO

-- Copiar tabla desde la base origen
SELECT *
INTO dbo.Call_Center_Data
FROM CLIPBOARD_HEALTH.dbo.[Call Center Data];
GO

USE CallCenterDB;
GO

SELECT TOP 100 *
FROM dbo.Call_Center_Data;

SELECT COUNT(*) FROM dbo.Call_Center_Data;

SELECT TOP 10 *
FROM dbo.Call_Center_Data
WHERE
    -- Revisa que al menos una columna no sea NULL
    Column1 IS NOT NULL
    OR Column2 IS NOT NULL
    OR Column3 IS NOT NULL;

	USE CallCenterDB;
GO

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Call_Center_Data';

USE CallCenterDB;
GO

SELECT TOP 10 *
FROM dbo.Call_Center_Data
WHERE 
    Incoming_Calls IS NOT NULL
    OR Answered_Calls IS NOT NULL
    OR Answer_Rate IS NOT NULL
    OR Abandoned_Calls IS NOT NULL;

	SELECT *
FROM dbo.Call_Center_Data
WHERE TRY_CAST(REPLACE(Answer_Rate, '%', '') AS FLOAT) < 90;

SELECT AVG(CAST(Answered_Calls AS FLOAT)) AS PromedioContestadas
FROM dbo.Call_Center_Data;

SELECT SUM(Incoming_Calls) AS TotalEntrantes
FROM dbo.Call_Center_Data;

-- Calcula el porcentaje promedio de llamadas abandonadas sobre el total de llamadas entrantes
SELECT 
    CAST(SUM(Abandoned_Calls) AS FLOAT) / SUM(Incoming_Calls) * 100 AS Abandono_Promedio_Porcentaje
FROM dbo.Call_Center_Data;

-- Muestra los registros donde el porcentaje de llamadas abandonadas es mayor a 10%
SELECT *
FROM dbo.Call_Center_Data
WHERE (CAST(Abandoned_Calls AS FLOAT) / Incoming_Calls) * 100 > 10;

-- Calcula el promedio de Answer_Speed_AVG, Talk_Duration_AVG y Waiting_Time_AVG en segundos
SELECT 
    AVG(DATEDIFF(SECOND, '00:00:00', Answer_Speed_AVG)) AS Avg_Answer_Speed_Sec,
    AVG(DATEDIFF(SECOND, '00:00:00', Talk_Duration_AVG)) AS Avg_Talk_Duration_Sec,
    AVG(DATEDIFF(SECOND, '00:00:00', Waiting_Time_AVG)) AS Avg_Waiting_Time_Sec
FROM dbo.Call_Center_Data;

-- Muestra los registros donde el Service Level a 20 segundos es menor al 80%
SELECT *
FROM dbo.Call_Center_Data
WHERE TRY_CAST(REPLACE(Service_Level_20_Seconds, '%', '') AS FLOAT) < 80;

-- Muestra totales de llamadas entrantes, contestadas y abandonadas
-- Además promedia la tasa de respuesta y el nivel de servicio
SELECT
    SUM(Incoming_Calls) AS Total_Incoming,
    SUM(Answered_Calls) AS Total_Answered,
    SUM(Abandoned_Calls) AS Total_Abandoned,
    AVG(TRY_CAST(REPLACE(Answer_Rate, '%', '') AS FLOAT)) AS Avg_Answer_Rate_Pct,
    AVG(TRY_CAST(REPLACE(Service_Level_20_Seconds, '%', '') AS FLOAT)) AS Avg_Service_Level_Pct
FROM dbo.Call_Center_Data;



-- Clasifica los días según el volumen de llamadas entrantes: Bajo, Medio o Alto
-- Y cuenta cuántos días hay en cada rango
SELECT 
    CASE 
        WHEN Incoming_Calls < 100 THEN 'Bajo'
        WHEN Incoming_Calls BETWEEN 100 AND 300 THEN 'Medio'
        ELSE 'Alto'
    END AS Rango_Llamadas,
    COUNT(*) AS Dias
FROM dbo.Call_Center_Data
GROUP BY 
    CASE 
        WHEN Incoming_Calls < 100 THEN 'Bajo'
        WHEN Incoming_Calls BETWEEN 100 AND 300 THEN 'Medio'
        ELSE 'Alto'
    END;



	-- Creamos una tabla temporal con los registros y un número aleatorio
WITH CallDataWithRandom AS (
    SELECT *, 
           ROW_NUMBER() OVER (ORDER BY NEWID()) AS RandomRowNum
    FROM dbo.Call_Center_Data
)

-- Asignamos el nombre del agente según el número de fila
SELECT *,
       CASE 
           WHEN (RandomRowNum % 4) = 1 THEN 'Laura'
           WHEN (RandomRowNum % 4) = 2 THEN 'Sofía'
           WHEN (RandomRowNum % 4) = 3 THEN 'Juan'
           ELSE 'Pedro'
       END AS Agente_Asignado
FROM CallDataWithRandom;



WITH CallDataWithRandom AS (
    SELECT Index,  -- solo una columna para referencia
           ROW_NUMBER() OVER (ORDER BY NEWID()) AS RandomRowNum
    FROM dbo.Call_Center_Data
)
SELECT Index,
       CASE 
           WHEN (RandomRowNum % 4) = 1 THEN 'Laura'
           WHEN (RandomRowNum % 4) = 2 THEN 'Sofía'
           WHEN (RandomRowNum % 4) = 3 THEN 'Juan'
           ELSE 'Pedro'
       END AS Agente_Asignado
FROM CallDataWithRandom;




WITH CallDataWithRandom AS (
    SELECT [Index],  -- Aquí usamos corchetes
           ROW_NUMBER() OVER (ORDER BY NEWID()) AS RandomRowNum
    FROM dbo.Call_Center_Data
)
SELECT [Index],
       CASE 
           WHEN (RandomRowNum % 4) = 1 THEN 'Laura'
           WHEN (RandomRowNum % 4) = 2 THEN 'Sofía'
           WHEN (RandomRowNum % 4) = 3 THEN 'Juan'
           ELSE 'Pedro'
       END AS Agente_Asignado
FROM CallDataWithRandom;


WITH CallDataWithRandom AS (
    SELECT *, ROW_NUMBER() OVER (ORDER BY NEWID()) AS RandomRowNum
    FROM dbo.Call_Center_Data
)
SELECT [Index], Incoming_Calls, Answered_Calls, Abandoned_Calls,
       CASE 
           WHEN (RandomRowNum % 4) = 1 THEN 'Laura'
           WHEN (RandomRowNum % 4) = 2 THEN 'Sofía'
           WHEN (RandomRowNum % 4) = 3 THEN 'Juan'
           ELSE 'Pedro'
       END AS Agente_Asignado
FROM CallDataWithRandom;




-- Primero, generamos un número aleatorio por fila y asignamos un agente al azar
WITH CallDataWithRandom AS (
    SELECT *, ROW_NUMBER() OVER (ORDER BY NEWID()) AS RandomRowNum
    FROM dbo.Call_Center_Data
),
CallDataWithAgent AS (
    SELECT *,
           CASE 
               WHEN (RandomRowNum % 4) = 1 THEN 'Laura'
               WHEN (RandomRowNum % 4) = 2 THEN 'Sofía'
               WHEN (RandomRowNum % 4) = 3 THEN 'Juan'
               ELSE 'Pedro'
           END AS Agente_Asignado,
           CASE 
               WHEN Incoming_Calls < 100 THEN 'Bajo'
               WHEN Incoming_Calls BETWEEN 100 AND 300 THEN 'Medio'
               ELSE 'Alto'
           END AS Rango_Llamadas
    FROM CallDataWithRandom
)
SELECT 
    Agente_Asignado,
    Rango_Llamadas,
    COUNT(*) AS Dias
FROM CallDataWithAgent
GROUP BY 
    Agente_Asignado,
    Rango_Llamadas;


  
-- Genera un número aleatorio y asigna agente + rango
WITH CallDataWithRandom AS (
    SELECT *, 
           ROW_NUMBER() OVER (ORDER BY NEWID()) AS RandomRowNum
    FROM dbo.Call_Center_Data
),
CallDataWithAgent AS (
    SELECT *,
           CASE 
               WHEN (RandomRowNum % 4) = 1 THEN 'Laura'
               WHEN (RandomRowNum % 4) = 2 THEN 'Sofía'
               WHEN (RandomRowNum % 4) = 3 THEN 'Juan'
               ELSE 'Pedro'
           END AS Agente_Asignado,
           CASE 
               WHEN Incoming_Calls < 100 THEN 'Bajo'
               WHEN Incoming_Calls BETWEEN 100 AND 300 THEN 'Medio'
               ELSE 'Alto'
           END AS Rango_Llamadas
    FROM CallDataWithRandom
)
-- Aquí mismo el SELECT, sin GO antes
SELECT 
    Agente_Asignado,
    Rango_Llamadas,
    COUNT(*) AS Dias
FROM CallDataWithAgent
GROUP BY 
    Agente_Asignado,
    Rango_Llamadas
ORDER BY 
    Agente_Asignado,
    Rango_Llamadas;





WITH CallDataWithRandom AS (
    SELECT *, 
           ROW_NUMBER() OVER (ORDER BY NEWID()) AS RandomRowNum
    FROM dbo.Call_Center_Data
),
CallDataWithAgent AS (
    SELECT *,
           -- Asigna agente al azar
           CASE 
               WHEN (RandomRowNum % 4) = 1 THEN 'Laura'
               WHEN (RandomRowNum % 4) = 2 THEN 'Sofía'
               WHEN (RandomRowNum % 4) = 3 THEN 'Juan'
               ELSE 'Pedro'
           END AS Agente_Asignado
    FROM CallDataWithRandom
),
CallDataWithDayTime AS (
    SELECT *,
           -- Asigna día aleatorio de lunes a viernes
           CASE (ABS(CHECKSUM(NEWID())) % 5) + 1
               WHEN 1 THEN 'Lunes'
               WHEN 2 THEN 'Martes'
               WHEN 3 THEN 'Miércoles'
               WHEN 4 THEN 'Jueves'
               ELSE 'Viernes'
           END AS Dia_Semana,
           
           -- Asigna hora cerrada aleatoria entre 09 y 17 (18 ya es fuera de turno)
           CAST((ABS(CHECKSUM(NEWID())) % 9) + 9 AS VARCHAR(2)) + ':00' AS Hora_Trabajo
           -- Genera hora de 09:00 a 17:00
    FROM CallDataWithAgent
)
SELECT *
FROM CallDataWithDayTime
WHERE NOT (
    -- Excluye registros que caen en el horario de descanso del agente
    (Agente_Asignado = 'Juan' AND Hora_Trabajo = '11:00')
 OR (Agente_Asignado = 'Pedro' AND Hora_Trabajo = '12:00')
 OR (Agente_Asignado = 'Sofía' AND Hora_Trabajo = '13:00')
 OR (Agente_Asignado = 'Laura' AND Hora_Trabajo = '14:00')
)
ORDER BY Agente_Asignado, Dia_Semana, Hora_Trabajo;





WITH CallDataWithRandom AS (
    SELECT *, 
           ROW_NUMBER() OVER (ORDER BY NEWID()) AS RandomRowNum
    FROM dbo.Call_Center_Data
),
CallDataWithAgent AS (
    SELECT *,
           -- Asigna agente al azar
           CASE 
               WHEN (RandomRowNum % 4) = 1 THEN 'Laura'
               WHEN (RandomRowNum % 4) = 2 THEN 'Sofía'
               WHEN (RandomRowNum % 4) = 3 THEN 'Juan'
               ELSE 'Pedro'
           END AS Agente_Asignado
    FROM CallDataWithRandom
),
CallDataWithDayTime AS (
    SELECT *,
           -- Asigna día aleatorio
           CASE (ABS(CHECKSUM(NEWID())) % 5) + 1
               WHEN 1 THEN 'Lunes'
               WHEN 2 THEN 'Martes'
               WHEN 3 THEN 'Miércoles'
               WHEN 4 THEN 'Jueves'
               ELSE 'Viernes'
           END AS Dia_Semana,

           -- Asigna hora cerrada aleatoria entre 09:00 y 17:00
           CAST((ABS(CHECKSUM(NEWID())) % 9) + 9 AS VARCHAR(2)) + ':00' AS Hora_Trabajo
    FROM CallDataWithAgent
)
SELECT 
    Agente_Asignado,
    Hora_Trabajo,
    Service_Level_20_Seconds
FROM CallDataWithDayTime
WHERE 
    Dia_Semana = 'Viernes'
    AND Hora_Trabajo IN ('09:00', '10:00', '11:00', '12:00')  -- Horas de 9am a 12pm
    AND Service_Level_20_Seconds IS NOT NULL  -- Excluye nulos
ORDER BY 
    Agente_Asignado, 
    Hora_Trabajo;







	WITH CallDataWithRandom AS (
    SELECT *, 
           ROW_NUMBER() OVER (ORDER BY NEWID()) AS RandomRowNum
    FROM dbo.Call_Center_Data
),
CallDataWithAgent AS (
    SELECT *,
           CASE 
               WHEN (RandomRowNum % 4) = 1 THEN 'Laura'
               WHEN (RandomRowNum % 4) = 2 THEN 'Sofía'
               WHEN (RandomRowNum % 4) = 3 THEN 'Juan'
               ELSE 'Pedro'
           END AS Agente_Asignado
    FROM CallDataWithRandom
),
CallDataWithDayTime AS (
    SELECT *,
           CASE (ABS(CHECKSUM(NEWID())) % 5) + 1
               WHEN 1 THEN 'Lunes'
               WHEN 2 THEN 'Martes'
               WHEN 3 THEN 'Miércoles'
               WHEN 4 THEN 'Jueves'
               ELSE 'Viernes'
           END AS Dia_Semana,

           CAST((ABS(CHECKSUM(NEWID())) % 9) + 9 AS VARCHAR(2)) + ':00' AS Hora_Trabajo,

           -- Convierte Service_Level_20_Seconds a numérico (quitando el %)
           TRY_CAST(REPLACE(Service_Level_20_Seconds, '%', '') AS FLOAT) AS Service_Level_Num
    FROM CallDataWithAgent
    WHERE Service_Level_20_Seconds IS NOT NULL
)
, RankedData AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY Agente_Asignado 
               ORDER BY Service_Level_Num DESC
           ) AS Rank_Performance
    FROM CallDataWithDayTime
)
SELECT 
    Agente_Asignado,
    Dia_Semana,
    Hora_Trabajo,
    Service_Level_20_Seconds
FROM RankedData
WHERE Rank_Performance = 1
ORDER BY Agente_Asignado;





--
WITH CallDataWithRandom AS (
    SELECT *, 
           ROW_NUMBER() OVER (ORDER BY NEWID()) AS RandomRowNum
    FROM dbo.Call_Center_Data
),
CallDataWithAgent AS (
    SELECT *,
           -- Asigna agente al azar
           CASE 
               WHEN (RandomRowNum % 4) = 1 THEN 'Laura'
               WHEN (RandomRowNum % 4) = 2 THEN 'Sofía'
               WHEN (RandomRowNum % 4) = 3 THEN 'Juan'
               ELSE 'Pedro'
           END AS Agente_Asignado
    FROM CallDataWithRandom
),
CallDataWithDayTime AS (
    SELECT *,
           -- Asigna día aleatorio de lunes a viernes
           CASE (ABS(CHECKSUM(NEWID())) % 5) + 1
               WHEN 1 THEN 'Lunes'
               WHEN 2 THEN 'Martes'
               WHEN 3 THEN 'Miércoles'
               WHEN 4 THEN 'Jueves'
               ELSE 'Viernes'
           END AS Dia_Semana,

           -- Asigna hora cerrada aleatoria entre 09:00 y 17:00
           CAST((ABS(CHECKSUM(NEWID())) % 9) + 9 AS VARCHAR(2)) + ':00' AS Hora_Trabajo,

           -- Convierte el nivel de servicio a numérico (sin %)
           TRY_CAST(REPLACE(Service_Level_20_Seconds, '%', '') AS FLOAT) AS Service_Level_Num
    FROM CallDataWithAgent
    WHERE Service_Level_20_Seconds IS NOT NULL
)
, RankedData AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY Agente_Asignado 
               ORDER BY Service_Level_Num DESC
           ) AS Rank_Performance
    FROM CallDataWithDayTime
)
SELECT 
    Agente_Asignado,
    Dia_Semana,
    Hora_Trabajo,
    Service_Level_20_Seconds,
    Service_Level_Num
FROM RankedData
WHERE Rank_Performance <= 3
ORDER BY 
    Agente_Asignado, 
    Rank_Performance;



-- Genera el top 3 de mejor service level y guarda en tabla nueva
WITH CallDataWithRandom AS (
    SELECT *, 
           ROW_NUMBER() OVER (ORDER BY NEWID()) AS RandomRowNum
    FROM dbo.Call_Center_Data
),
CallDataWithAgent AS (
    SELECT *,
           CASE 
               WHEN (RandomRowNum % 4) = 1 THEN 'Laura'
               WHEN (RandomRowNum % 4) = 2 THEN 'Sofía'
               WHEN (RandomRowNum % 4) = 3 THEN 'Juan'
               ELSE 'Pedro'
           END AS Agente_Asignado
    FROM CallDataWithRandom
),
CallDataWithDayTime AS (
    SELECT *,
           CASE (ABS(CHECKSUM(NEWID())) % 5) + 1
               WHEN 1 THEN 'Lunes'
               WHEN 2 THEN 'Martes'
               WHEN 3 THEN 'Miércoles'
               WHEN 4 THEN 'Jueves'
               ELSE 'Viernes'
           END AS Dia_Semana,
           CAST((ABS(CHECKSUM(NEWID())) % 9) + 9 AS VARCHAR(2)) + ':00' AS Hora_Trabajo,
           TRY_CAST(REPLACE(Service_Level_20_Seconds, '%', '') AS FLOAT) AS Service_Level_Num
    FROM CallDataWithAgent
    WHERE Service_Level_20_Seconds IS NOT NULL
),
RankedData AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY Agente_Asignado 
               ORDER BY Service_Level_Num DESC
           ) AS Rank_Performance
    FROM CallDataWithDayTime
)
SELECT 
    Agente_Asignado,
    Dia_Semana,
    Hora_Trabajo,
    Service_Level_20_Seconds,
    Service_Level_Num
INTO Call_Center_TopPerformance
FROM RankedData
WHERE Rank_Performance <= 3;


SELECT * FROM Call_Center_TopPerformance
ORDER BY Agente_Asignado, Service_Level_Num DESC;




WITH CallDataWithRandom AS (
    SELECT *, 
           ROW_NUMBER() OVER (ORDER BY NEWID()) AS RandomRowNum
    FROM dbo.Call_Center_Data
),
CallDataWithAgent AS (
    SELECT *,
           CASE 
               WHEN (RandomRowNum % 4) = 1 THEN 'Laura'
               WHEN (RandomRowNum % 4) = 2 THEN 'Sofía'
               WHEN (RandomRowNum % 4) = 3 THEN 'Juan'
               ELSE 'Pedro'
           END AS Agente_Asignado
    FROM CallDataWithRandom
),
CallDataWithDayTime AS (
    SELECT *,
           CASE (ABS(CHECKSUM(NEWID())) % 5) + 1
               WHEN 1 THEN 'Lunes'
               WHEN 2 THEN 'Martes'
               WHEN 3 THEN 'Miércoles'
               WHEN 4 THEN 'Jueves'
               ELSE 'Viernes'
           END AS Dia_Semana,
           CAST((ABS(CHECKSUM(NEWID())) % 9) + 9 AS VARCHAR(2)) + ':00' AS Hora_Trabajo,
           TRY_CAST(REPLACE(Service_Level_20_Seconds, '%', '') AS FLOAT) AS Service_Level_Num
    FROM CallDataWithAgent
    WHERE Service_Level_20_Seconds IS NOT NULL
),
RankedData AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY Agente_Asignado 
               ORDER BY Service_Level_Num DESC
           ) AS Rank_Performance
    FROM CallDataWithDayTime
)
SELECT 
    Agente_Asignado,
    Dia_Semana,
    Hora_Trabajo,
    Service_Level_20_Seconds,
    Service_Level_Num
FROM RankedData
WHERE Rank_Performance <= 3
ORDER BY 
    Agente_Asignado, 
    Rank_Performance;

IF OBJECT_ID('dbo.Call_Center_TopPerformance', 'U') IS NOT NULL
    DROP TABLE dbo.Call_Center_TopPerformance;


-- Elimina la tabla si existe
IF OBJECT_ID('dbo.Call_Center_TopPerformance', 'U') IS NOT NULL
    DROP TABLE dbo.Call_Center_TopPerformance;

WITH CallDataWithRandom AS (
    SELECT *, 
           ROW_NUMBER() OVER (ORDER BY NEWID()) AS RandomRowNum
    FROM dbo.Call_Center_Data
),
CallDataWithAgent AS (
    SELECT *,
           CASE 
               WHEN (RandomRowNum % 4) = 1 THEN 'Laura'
               WHEN (RandomRowNum % 4) = 2 THEN 'Sofía'
               WHEN (RandomRowNum % 4) = 3 THEN 'Juan'
               ELSE 'Pedro'
           END AS Agente_Asignado
    FROM CallDataWithRandom
),
CallDataWithDayTime AS (
    SELECT *,
           CASE (ABS(CHECKSUM(NEWID())) % 5) + 1
               WHEN 1 THEN 'Lunes'
               WHEN 2 THEN 'Martes'
               WHEN 3 THEN 'Miércoles'
               WHEN 4 THEN 'Jueves'
               ELSE 'Viernes'
           END AS Dia_Semana,
           CAST((ABS(CHECKSUM(NEWID())) % 9) + 9 AS VARCHAR(2)) + ':00' AS Hora_Trabajo,
           TRY_CAST(REPLACE(Service_Level_20_Seconds, '%', '') AS FLOAT) AS Service_Level_Num
    FROM CallDataWithAgent
    WHERE Service_Level_20_Seconds IS NOT NULL
),
RankedData AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY Agente_Asignado 
               ORDER BY Service_Level_Num DESC
           ) AS Rank_Performance
    FROM CallDataWithDayTime
)
SELECT 
    Agente_Asignado,
    Dia_Semana,
    Hora_Trabajo,
    Service_Level_20_Seconds,
    Service_Level_Num
INTO dbo.Call_Center_TopPerformance
FROM RankedData
WHERE Rank_Performance <= 3;

-- Consulta los resultados
SELECT * FROM dbo.Call_Center_TopPerformance
ORDER BY Agente_Asignado, Service_Level_Num DESC;



-- Elimina la tabla si existe
IF OBJECT_ID('dbo.Call_Center_TopPerformance', 'U') IS NOT NULL
    DROP TABLE dbo.Call_Center_TopPerformance;

WITH CallDataWithRandom AS (
    SELECT *, 
           ROW_NUMBER() OVER (ORDER BY NEWID()) AS RandomRowNum
    FROM dbo.Call_Center_Data
),
CallDataWithAgent AS (
    SELECT *,
           CASE 
               WHEN (RandomRowNum % 4) = 1 THEN 'Laura'
               WHEN (RandomRowNum % 4) = 2 THEN 'Sofía'
               WHEN (RandomRowNum % 4) = 3 THEN 'Juan'
               ELSE 'Pedro'
           END AS Agente_Asignado
    FROM CallDataWithRandom
),
CallDataWithDayTime AS (
    SELECT *,
           CASE (ABS(CHECKSUM(NEWID())) % 5) + 1
               WHEN 1 THEN 'Lunes'
               WHEN 2 THEN 'Martes'
               WHEN 3 THEN 'Miércoles'
               WHEN 4 THEN 'Jueves'
               ELSE 'Viernes'
           END AS Dia_Semana,
           CAST((ABS(CHECKSUM(NEWID())) % 9) + 9 AS VARCHAR(2)) + ':00' AS Hora_Trabajo,
           TRY_CAST(REPLACE(Service_Level_20_Seconds, '%', '') AS FLOAT) AS Service_Level_Num
    FROM CallDataWithAgent
    WHERE Service_Level_20_Seconds IS NOT NULL
),
RankedData AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY Agente_Asignado 
               ORDER BY Service_Level_Num DESC
           ) AS Rank_Performance
    FROM CallDataWithDayTime
)
SELECT *
INTO dbo.Call_Center_TopPerformance
FROM RankedData
WHERE Rank_Performance <= 10;

-- Muestra todo
SELECT * FROM dbo.Call_Center_TopPerformance
ORDER BY Agente_Asignado, Service_Level_Num DESC;




-- Elimina la tabla si existe
IF OBJECT_ID('dbo.Call_Center_TopServiceLevel', 'U') IS NOT NULL
    DROP TABLE dbo.Call_Center_TopServiceLevel;

WITH CallDataWithRandom AS (
    SELECT *, 
           ROW_NUMBER() OVER (ORDER BY NEWID()) AS RandomRowNum
    FROM dbo.Call_Center_Data
),
CallDataWithAgent AS (
    SELECT *,
           CASE 
               WHEN (RandomRowNum % 4) = 1 THEN 'Laura'
               WHEN (RandomRowNum % 4) = 2 THEN 'Sofía'
               WHEN (RandomRowNum % 4) = 3 THEN 'Juan'
               ELSE 'Pedro'
           END AS Agente_Asignado
    FROM CallDataWithRandom
),
CallDataWithDayTime AS (
    SELECT *,
           CASE (ABS(CHECKSUM(NEWID())) % 5) + 1
               WHEN 1 THEN 'Lunes'
               WHEN 2 THEN 'Martes'
               WHEN 3 THEN 'Miércoles'
               WHEN 4 THEN 'Jueves'
               ELSE 'Viernes'
           END AS Dia_Semana,
           CAST((ABS(CHECKSUM(NEWID())) % 9) + 9 AS VARCHAR(2)) + ':00' AS Hora_Trabajo,
           TRY_CAST(REPLACE(Service_Level_20_Seconds, '%', '') AS FLOAT) AS Service_Level_Num
    FROM CallDataWithAgent
    WHERE Service_Level_20_Seconds IS NOT NULL
),
RankedData AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY Agente_Asignado 
               ORDER BY Service_Level_Num DESC
           ) AS Rank_ServiceLevel
    FROM CallDataWithDayTime
)
SELECT 
    Agente_Asignado,
    Service_Level_20_Seconds,
    Service_Level_Num,
    Answered_Calls,
    Dia_Semana,
    Hora_Trabajo
INTO dbo.Call_Center_TopServiceLevel
FROM RankedData
WHERE Rank_ServiceLevel <= 5;

-- Consulta el resultado
SELECT *
FROM dbo.Call_Center_TopServiceLevel
ORDER BY Agente_Asignado, Service_Level_Num DESC;

-- Elimina la tabla si existe
IF OBJECT_ID('dbo.Call_Center_TopAnsweredCalls', 'U') IS NOT NULL
    DROP TABLE dbo.Call_Center_TopAnsweredCalls;

WITH CallDataWithRandom AS (
    SELECT *, 
           ROW_NUMBER() OVER (ORDER BY NEWID()) AS RandomRowNum
    FROM dbo.Call_Center_Data
),
CallDataWithAgent AS (
    SELECT *,
           CASE 
               WHEN (RandomRowNum % 4) = 1 THEN 'Laura'
               WHEN (RandomRowNum % 4) = 2 THEN 'Sofía'
               WHEN (RandomRowNum % 4) = 3 THEN 'Juan'
               ELSE 'Pedro'
           END AS Agente_Asignado
    FROM CallDataWithRandom
),
CallDataWithDayTime AS (
    SELECT *,
           CASE (ABS(CHECKSUM(NEWID())) % 5) + 1
               WHEN 1 THEN 'Lunes'
               WHEN 2 THEN 'Martes'
               WHEN 3 THEN 'Miércoles'
               WHEN 4 THEN 'Jueves'
               ELSE 'Viernes'
           END AS Dia_Semana,
           CAST((ABS(CHECKSUM(NEWID())) % 9) + 9 AS VARCHAR(2)) + ':00' AS Hora_Trabajo,
           TRY_CAST(REPLACE(Service_Level_20_Seconds, '%', '') AS FLOAT) AS Service_Level_Num
    FROM CallDataWithAgent
),
RankedData AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY Agente_Asignado 
               ORDER BY Answered_Calls DESC
           ) AS Rank_AnsweredCalls
    FROM CallDataWithDayTime
)
SELECT 
    *
INTO dbo.Call_Center_TopAnsweredCalls
FROM RankedData
WHERE Rank_AnsweredCalls <= 5;

-- Consulta el resultado
SELECT *
FROM dbo.Call_Center_TopAnsweredCalls
ORDER BY Agente_Asignado, Answered_Calls DESC;


SELECT name FROM sys.databases;






WITH CallDataWithRandom AS (
    SELECT *, ROW_NUMBER() OVER (ORDER BY NEWID()) AS RandomRowNum
    FROM dbo.Call_Center_Data
),
CallDataWithAgent AS (
    SELECT *,
           CASE 
               WHEN (RandomRowNum % 4) = 1 THEN 'Laura'
               WHEN (RandomRowNum % 4) = 2 THEN 'Sofía'
               WHEN (RandomRowNum % 4) = 3 THEN 'Juan'
               ELSE 'Pedro'
           END AS Agente_Asignado
    FROM CallDataWithRandom
)
SELECT 
    Agente_Asignado,
    SUM(Answered_Calls) AS Total_Answered,
    AVG(TRY_CAST(REPLACE(Service_Level_20_Seconds, '%', '') AS FLOAT)) AS Avg_Service_Level
FROM CallDataWithAgent
GROUP BY Agente_Asignado
ORDER BY Agente_Asignado;


SELECT TOP 5 *
FROM dbo.Call_Center_Data;


-- Genera tabla con agentes y fechas simuladas
IF OBJECT_ID('dbo.Call_Center_WithAgentDate', 'U') IS NOT NULL
    DROP TABLE dbo.Call_Center_WithAgentDate;

WITH DataWithExtras AS (
    SELECT *,
           CASE (ABS(CHECKSUM(NEWID())) % 4)
               WHEN 0 THEN 'Laura'
               WHEN 1 THEN 'Sofía'
               WHEN 2 THEN 'Juan'
               ELSE 'Pedro'
           END AS Agente_Asignado,
           DATEADD(DAY, (ABS(CHECKSUM(NEWID())) % 30), '2025-06-01') AS Fecha
    FROM dbo.Call_Center_Data
)
SELECT *
INTO dbo.Call_Center_WithAgentDate
FROM DataWithExtras;


SELECT 
    Agente_Asignado,
    FORMAT(Fecha, 'yyyy-MM') AS Mes,
    AVG(TRY_CAST(REPLACE(Service_Level_20_Seconds, '%', '') AS FLOAT)) AS SLA_Promedio
FROM dbo.Call_Center_WithAgentDate
GROUP BY 
    Agente_Asignado,
    FORMAT(Fecha, 'yyyy-MM')
ORDER BY 
    Agente_Asignado, 
    Mes;


	SELECT 
    Agente_Asignado,
    FORMAT(Fecha, 'yyyy-MM') AS Mes,
    AVG(TRY_CAST(REPLACE(Service_Level_20_Seconds, '%', '') AS FLOAT)) AS SLA_Promedio
FROM dbo.Call_Center_WithAgentDate
WHERE 
    DATEPART(WEEKDAY, Fecha) BETWEEN 2 AND 6 -- lunes a viernes
    AND DATEPART(HOUR, Fecha) BETWEEN 9 AND 17 -- 9:00 a 17:59 (porque BETWEEN incluye ambos extremos)
GROUP BY 
    Agente_Asignado,
    FORMAT(Fecha, 'yyyy-MM')
ORDER BY 
    Agente_Asignado,
    Mes;


	SELECT TOP 50 
    Fecha,
    DATENAME(WEEKDAY, Fecha) AS Dia_Semana,
    DATEPART(WEEKDAY, Fecha) AS Num_Dia_Semana,
    DATEPART(HOUR, Fecha) AS Hora
FROM dbo.Call_Center_WithAgentDate
ORDER BY Fecha DESC;

SELECT @@DATEFIRST;

SET DATEFIRST 7;

SELECT COUNT(*) AS Registros
FROM dbo.Call_Center_WithAgentDate
WHERE DATEPART(WEEKDAY, Fecha) BETWEEN 2 AND 6
  AND DATEPART(HOUR, Fecha) BETWEEN 9 AND 17;


  SELECT DISTINCT DATEPART(HOUR, Fecha) AS Hora
FROM dbo.Call_Center_WithAgentDate
ORDER BY Hora;

SELECT TOP 20 Fecha FROM dbo.Call_Center_WithAgentDate ORDER BY Fecha DESC;


SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Call_Center_WithAgentDate';



SET DATEFIRST 7;

WITH Datos AS (
    SELECT 
        Agente_Asignado,
        FORMAT(Fecha, 'yyyy-MM') AS Mes,
        DATENAME(WEEKDAY, Fecha) AS DiaSemana,
        TRY_CAST(REPLACE(Service_Level_20_Seconds, '%', '') AS FLOAT) AS SLA,
        Incoming_Calls,
        Answered_Calls,
        -- Convertimos los tiempos a segundos para facilitar promedios
        DATEDIFF(SECOND, '00:00:00', Answer_Speed_AVG) AS Answer_Speed_Seg,
        DATEDIFF(SECOND, '00:00:00', Talk_Duration_AVG) AS Talk_Duration_Seg,
        DATEDIFF(SECOND, '00:00:00', Waiting_Time_AVG) AS Waiting_Time_Seg,
        Abandoned_Calls
    FROM dbo.Call_Center_WithAgentDate
    WHERE DATEPART(WEEKDAY, Fecha) BETWEEN 2 AND 6 -- lunes a viernes
)

SELECT
    Agente_Asignado,
    Mes,
    DiaSemana,
    -- SLA ponderado por Incoming_Calls para darle peso
    CASE 
        WHEN SUM(Incoming_Calls) > 0 THEN SUM(SLA * Incoming_Calls) * 1.0 / SUM(Incoming_Calls)
        ELSE NULL
    END AS SLA_Ponderado_Por_Llamadas,
    -- Métricas promedio de tiempos
    AVG(Answer_Speed_Seg) AS Answer_Speed_Promedio_Seg,
    AVG(Talk_Duration_Seg) AS Talk_Duration_Promedio_Seg,
    AVG(Waiting_Time_Seg) AS Waiting_Time_Promedio_Seg,
    -- Porcentaje promedio de abandono
    CASE
        WHEN SUM(Incoming_Calls) > 0 THEN SUM(Abandoned_Calls) * 100.0 / SUM(Incoming_Calls)
        ELSE NULL
    END AS Porcentaje_Abandono
FROM Datos
GROUP BY 
    Agente_Asignado,
    Mes,
    DiaSemana
ORDER BY 
    Agente_Asignado,
    Mes,
    -- Ordenar días lunes a viernes correctamente:
    CASE DiaSemana
        WHEN 'Monday' THEN 1
        WHEN 'Tuesday' THEN 2
        WHEN 'Wednesday' THEN 3
        WHEN 'Thursday' THEN 4
        WHEN 'Friday' THEN 5
        ELSE 6
    END;



	SET DATEFIRST 7;

WITH Datos AS (
    SELECT 
        Agente_Asignado,
        FORMAT(Fecha, 'yyyy-MM') AS Mes,
        TRY_CAST(REPLACE(Service_Level_20_Seconds, '%', '') AS FLOAT) AS SLA,
        Incoming_Calls
    FROM dbo.Call_Center_WithAgentDate
    WHERE DATEPART(WEEKDAY, Fecha) BETWEEN 2 AND 6
)
SELECT
    Agente_Asignado,
    Mes,
    CASE 
        WHEN SUM(Incoming_Calls) > 0 THEN SUM(SLA * Incoming_Calls) * 1.0 / SUM(Incoming_Calls)
        ELSE NULL
    END AS SLA_Ponderado_Por_Llamadas
FROM Datos
GROUP BY 
    Agente_Asignado,
    Mes
ORDER BY 
    Agente_Asignado,
    Mes;

	