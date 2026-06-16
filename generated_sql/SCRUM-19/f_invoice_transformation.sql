-- Query: f_invoice_transformation
-- Purpose: Transform and load data into the f_invoice fact table.
-- Query Type: SELECT

-- Databricks SQL Notebook: f_invoice Transformation
-- Purpose: Transform and load data into the f_invoice fact table.

WITH inv_mstr_cte AS (
    SELECT
        inv.inv_id,
        inv.inv_amt
    FROM edp_raw.sap_hana.inv_mstr inv
)
SELECT
    CAST(inv.inv_id AS STRING) AS invoice_key,
    CAST(inv.inv_amt AS DECIMAL(18, 2)) AS invoice_amount
FROM inv_mstr_cte inv;