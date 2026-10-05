# 🛒 Análisis de Comportamiento del Cliente y Valor de Vida en E-Commerce

![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![SQL Server](https://img.shields.io/badge/SQL_Server-CC292B?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)
![Data Analytics](https://img.shields.io/badge/E--Commerce-Analytics-blue?style=for-the-badge)

---

## 📌 1. Descripción y Objetivo del Proyecto

Este proyecto aborda el análisis del comportamiento de compra, la efectividad de las promociones y los niveles de inactividad de los clientes en una plataforma de comercio electrónico.

**Objetivo principal:**  
Evaluar la relación entre el nivel de membresía, la satisfacción del cliente y la frecuencia de compra para identificar segmentos en riesgo de abandono y oportunidades de maximización del valor de vida del cliente (*Customer Lifetime Value*). Las recomendaciones obtenidas brindan soporte analítico a los equipos de **Marketing y Fidelización** para optimizar el presupuesto comercial.

---

## 💡 2. Preguntas de Negocio Principales

1. **Rendimiento por Membresía:** ¿Cómo se distribuyen el gasto total y el volumen de artículos comprados según el nivel de membresía?
2. **Riesgo de Inactividad (Churn Risk):** ¿Existe una correlación directa entre el nivel de satisfacción reportado y los días transcurridos desde la última compra?
3. **Efectividad de Promociones:** ¿El uso de descuentos genera un incremento real en el valor promedio del pedido (*AOV*) o solo reduce los márgenes operativos?
4. **Concentración Geográfica:** ¿Cuáles son las ciudades que concentran a los clientes de mayor valor acumulado?

---

## 🛠️ 3. Arquitectura y Stack Tecnológico

* **Motor de Base de Datos:** Microsoft SQL Server
* **Herramienta de BI y Visualización:** Power BI Desktop
* **Modelado de Datos:** Esquema en Estrella (*Star Schema*)
* **Cálculos Analíticos:** Consultas T-SQL (CTEs, Window Functions, Agregaciones) y Medidas DAX

---

## 📂 4. Estructura del Repositorio

```text
e-commerce-customer-behavior/
│
├── sql/
│   ├── 01_ddl_create_tables.sql      -- Script DDL de tabla de staging e importación
│   ├── 02_eda_queries.sql             -- Consultas de Análisis Exploratorio de Datos (EDA)
│   └── 03_create_views.sql            -- Vista procesada y limpia para consumo en Power BI
│
├── power_bi/
│   ├── ecommerce_analytics_dashboard.pbix   -- Dashboard interactivo
│   └── dashboard_preview.png                -- Captura ejecutiva para documentación
│
├── data/
│   └── raw_data_link.txt              -- Enlace al dataset original en Kaggle
│
└── README.md                          -- Documentación del proyecto