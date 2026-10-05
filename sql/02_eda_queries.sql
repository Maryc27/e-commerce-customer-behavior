-- ===============================================================================
-- Proyecto: Análisis de Comportamiento del Cliente y Valor de Vida en E-Commerce
-- Archivo: 02_eda_queries.sql
-- Descripción: Consultas para Análisis Exploratorio de Datos (EDA).
-- ===============================================================================

USE EcommerceDB;
GO

-- -------------------------------------------------------------------------------
-- 1. Calidad e Integridad de Datos
-- -------------------------------------------------------------------------------
SELECT 
    COUNT(*) AS total_clientes,
    COUNT(DISTINCT Customer_ID) AS clientes_unicos,
    MIN(Age) AS edad_minima,
    MAX(Age) AS edad_maxima,
    MIN(Total_Spend) AS gasto_minimo,
    MAX(Total_Spend) AS gasto_maximo,
    CAST(AVG(Total_Spend) AS DECIMAL(10,2)) AS gasto_promedio
FROM dbo.stg_ecommerce_customer_behavior;

-- Conteo de valores nulos o vacíos
SELECT 
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS null_gender,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS null_city,
    SUM(CASE WHEN Membership_Type IS NULL THEN 1 ELSE 0 END) AS null_membership,
    SUM(CASE WHEN Total_Spend IS NULL THEN 1 ELSE 0 END) AS null_total_spend,
    SUM(CASE WHEN Satisfaction_Level IS NULL THEN 1 ELSE 0 END) AS null_satisfaction
FROM dbo.stg_ecommerce_customer_behavior;

-- -------------------------------------------------------------------------------
-- 2. Segmentación de Clientes por Tipo de Membresía
-- -------------------------------------------------------------------------------
SELECT 
    ISNULL(Membership_Type, 'Sin Membresía') AS Membresia,
    COUNT(Customer_ID) AS Total_Clientes,
    CAST(AVG(Total_Spend) AS DECIMAL(10,2)) AS Gasto_Promedio_Cliente,
    SUM(Total_Spend) AS Gasto_Total_Acumulado,
    CAST(AVG(CAST(Items_Purchased AS DECIMAL(10,2))) AS DECIMAL(10,2)) AS Promedio_Articulos_Comprados,
    CAST(AVG(Total_Spend / NULLIF(Items_Purchased, 0)) AS DECIMAL(10,2)) AS Ticket_Promedio_Por_Articulo
FROM dbo.stg_ecommerce_customer_behavior
GROUP BY Membership_Type
ORDER BY Gasto_Total_Acumulado DESC;

-- -------------------------------------------------------------------------------
-- 3. Análisis de Inactividad y Riesgo de Churn (Días sin compra vs. Satisfacción)
-- -------------------------------------------------------------------------------
SELECT 
    ISNULL(Satisfaction_Level, 'Sin Especificar') AS Nivel_Satisfaccion,
    COUNT(Customer_ID) AS Cantidad_Clientes,
    AVG(Days_Since_Last_Purchase) AS Promedio_Dias_Sin_Comprar,
    SUM(CASE WHEN Days_Since_Last_Purchase > 60 THEN 1 ELSE 0 END) AS Clientes_En_Riesgo,
    CAST(
        SUM(CASE WHEN Days_Since_Last_Purchase > 60 THEN 1.0 ELSE 0.0 END) / COUNT(Customer_ID) * 100 
        AS DECIMAL(5,2)
    ) AS Porcentaje_En_Riesgo
FROM dbo.stg_ecommerce_customer_behavior
GROUP BY Satisfaction_Level
ORDER BY Promedio_Dias_Sin_Comprar DESC;

-- -------------------------------------------------------------------------------
-- 4. Sensibilidad al Uso de Descuentos
-- -------------------------------------------------------------------------------
SELECT 
    CASE 
        WHEN UPPER(LTRIM(RTRIM(Discount_Applied))) IN ('TRUE', 'YES', '1') THEN 'Con Descuento'
        ELSE 'Sin Descuento'
    END AS Aplicacion_Descuento,
    COUNT(Customer_ID) AS Total_Clientes,
    CAST(AVG(Total_Spend) AS DECIMAL(10,2)) AS Gasto_Promedio,
    CAST(AVG(CAST(Items_Purchased AS DECIMAL(10,2))) AS DECIMAL(10,2)) AS Unidades_Promedio,
    CAST(AVG(Average_Rating) AS DECIMAL(3,2)) AS Calificacion_Promedio
FROM dbo.stg_ecommerce_customer_behavior
GROUP BY 
    CASE 
        WHEN UPPER(LTRIM(RTRIM(Discount_Applied))) IN ('TRUE', 'YES', '1') THEN 'Con Descuento'
        ELSE 'Sin Descuento'
    END;

-- -------------------------------------------------------------------------------
-- 5. Ranking de los 3 Clientes de Mayor Gasto por Ciudad (CTE & Window Function)
-- -------------------------------------------------------------------------------
WITH CustomerSpendRanking AS (
    SELECT 
        Customer_ID,
        City,
        Membership_Type,
        Total_Spend,
        Satisfaction_Level,
        DENSE_RANK() OVER (PARTITION BY City ORDER BY Total_Spend DESC) AS Ranking_Ciudad
    FROM dbo.stg_ecommerce_customer_behavior
)
SELECT 
    Ranking_Ciudad,
    City AS Ciudad,
    Customer_ID,
    Membership_Type AS Membresia,
    Total_Spend AS Gasto_Total,
    Satisfaction_Level AS Satisfaccion
FROM CustomerSpendRanking
WHERE Ranking_Ciudad <= 3
ORDER BY City, Ranking_Ciudad;
GO