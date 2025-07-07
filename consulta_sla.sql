SET DATEFIRST 7;

WITH Datos AS (
    SELECT 
        Agente_Asignado,
        FORMAT(Fecha, 'yyyy-MM') AS Mes,
        DATENAME(WEEKDAY, Fecha) AS DiaSemana,
        TRY_CAST(REPLACE(Service_Level_20_Seconds, '%', '') AS FLOAT) AS SLA,
        Incoming_Calls,
        Answered_Calls,
        DATEDIFF(SECOND, '00:00:00', Answer_Speed_AVG) AS Answer_Speed_Seg,
        DATEDIFF(SECOND, '00:00:00', Talk_Duration_AVG) AS Talk_Duration_Seg,
        DATEDIFF(SECOND, '00:00:00', Waiting_Time_AVG) AS Waiting_Time_Seg,
        Abandoned_Calls
    FROM dbo.Call_Center_WithAgentDate
    WHERE DATEPART(WEEKDAY, Fecha) BETWEEN 2 AND 6
)

SELECT
    Agente_Asignado,
    Mes,
    DiaSemana,
    CASE 
        WHEN SUM(Incoming_Calls) > 0 THEN SUM(SLA * Incoming_Calls) * 1.0 / SUM(Incoming_Calls)
        ELSE NULL
    END AS SLA_Ponderado_Por_Llamadas,
    AVG(Answer_Speed_Seg) AS Answer_Speed_Promedio_Seg,
    AVG(Talk_Duration_Seg) AS Talk_Duration_Promedio_Seg,
    AVG(Waiting_Time_Seg) AS Waiting_Time_Promedio_Seg,
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
    CASE DiaSemana
        WHEN 'Monday' THEN 1
        WHEN 'Tuesday' THEN 2
        WHEN 'Wednesday' THEN 3
        WHEN 'Thursday' THEN 4
        WHEN 'Friday' THEN 5
        ELSE 6
    END;
