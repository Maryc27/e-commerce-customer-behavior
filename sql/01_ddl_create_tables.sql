-- ===============================================================================
-- Proyecto: Análisis de Comportamiento del Cliente y Valor de Vida en E-Commerce
-- Archivo: 01_ddl_create_tables.sql
-- Descripción: Creación de base de datos, tabla de staging y carga de datos.
-- ===============================================================================

-- 1. Crear base de datos
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'EcommerceDB')
BEGIN
    CREATE DATABASE EcommerceDB;
END
GO

USE EcommerceDB;
GO

-- 2. Crear tabla de staging (Estructura cruda)
IF OBJECT_ID('dbo.stg_ecommerce_customer_behavior', 'U') IS NOT NULL
    DROP TABLE dbo.stg_ecommerce_customer_behavior;
GO

CREATE TABLE dbo.stg_ecommerce_customer_behavior (
    Customer_ID INT NOT NULL PRIMARY KEY,
    Gender VARCHAR(20),
    Age INT,
    City VARCHAR(100),
    Membership_Type VARCHAR(50),
    Total_Spend DECIMAL(10, 2),
    Items_Purchased INT,
    Average_Rating DECIMAL(3, 2),
    Discount_Applied VARCHAR(10),
    Days_Since_Last_Purchase INT,
    Satisfaction_Level VARCHAR(50)
);
GO

-- 3. Carga de datos masiva
-- Nota: Si usas la interfaz gráfica de SSMS (Import Flat File Wizard), omite este bloque de BULK INSERT.
/*
BULK INSERT dbo.stg_ecommerce_customer_behavior
FROM 'C:\Users\Public\E-commerce Customer Behavior - Sheet1.csv' -- Reemplazar ruta local
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
GO
*/

-- 4. Verificación de carga de registros
SELECT COUNT(*) AS total_registros_cargados FROM dbo.stg_ecommerce_customer_behavior;
SELECT TOP 10 * FROM dbo.stg_ecommerce_customer_behavior;
GO