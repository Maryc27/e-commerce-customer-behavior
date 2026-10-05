-- ===============================================================================
-- Proyecto: Análisis de Comportamiento del Cliente y Valor de Vida en E-Commerce
-- Archivo: 03_create_views.sql
-- Descripción: Creación de vistas optimizadas para el modelo de datos en Power BI.
-- ===============================================================================

USE EcommerceDB;
GO

CREATE OR ALTER VIEW dbo.vw_ecommerce_customer_clean AS
SELECT 
    Customer_ID,
    Gender,
    Age,
    -- Segmentación por rango de edad
    CASE 
        WHEN Age < 25 THEN '18-24'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END AS Age_Group,
    City,
    ISNULL(Membership_Type, 'Unassigned') AS Membership_Type,
    Total_Spend,
    Items_Purchased,
    -- Costo promedio por artículo
    CAST(
        CASE 
            WHEN Items_Purchased > 0 THEN Total_Spend / Items_Purchased 
            ELSE 0 
        END AS DECIMAL(10, 2)
    ) AS Avg_Item_Cost,
    Average_Rating,
    -- Normalización de bandera de descuento
    CASE 
        WHEN UPPER(LTRIM(RTRIM(Discount_Applied))) IN ('TRUE', 'YES', '1') THEN 1 
        ELSE 0 
    END AS Discount_Applied_Flag,
    Days_Since_Last_Purchase,
    -- Clasificación de estado de actividad del cliente (Riesgo de Churn)
    CASE 
        WHEN Days_Since_Last_Purchase <= 30 THEN 'Activo (0-30 días)'
        WHEN Days_Since_Last_Purchase BETWEEN 31 AND 60 THEN 'Riesgo Moderado (31-60 días)'
        WHEN Days_Since_Last_Purchase BETWEEN 61 AND 90 THEN 'En Riesgo Alto (61-90 días)'
        ELSE 'Inactivo (>90 días)'
    END AS Activity_Status_Group,
    ISNULL(Satisfaction_Level, 'Unspecified') AS Satisfaction_Level
FROM dbo.stg_ecommerce_customer_behavior;
GO

-- Comprobación de la vista generada
SELECT TOP 10 * FROM dbo.vw_ecommerce_customer_clean;
GO