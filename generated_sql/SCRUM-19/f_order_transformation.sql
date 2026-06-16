-- Query: f_order_transformation
-- Purpose: Transform and load data into the f_order fact table.
-- Query Type: SELECT

-- Databricks SQL Notebook: f_order Transformation
-- Purpose: Transform and load data into the f_order fact table.

WITH so_mstr_cte AS (
    SELECT
        so.so_nbr,
        so.so_ord_date,
        so.so_cust
    FROM edp_raw.sap_hana.so_mstr so
    WHERE so.so_status = 'COMPLETED'
),
sod_det_cte AS (
    SELECT
        sd.sod_nbr,
        sd.sod_price_tot,
        sd.sod_qty_ord,
        sd.sod_disc,
        sd.sod_tax
    FROM edp_raw.sap_hana.sod_det sd
),
customer_lookup_cte AS (
    SELECT
        CONCAT('msd_qad_', LOWER(ad.ad_domain), '|', ad.ad_addr) AS customer_key,
        ad.ad_addr
    FROM edp_raw.sap_hana.ad_mstr ad
),
product_lookup_cte AS (
    SELECT
        pt.pt_part AS product_key,
        pt.pt_part
    FROM edp_raw.sap_hana.pt_mstr pt
)
SELECT
    CAST(so.so_nbr AS STRING) AS order_key,
    CAST(so.so_ord_date AS DATE) AS order_date,
    CAST(cl.customer_key AS STRING) AS customer_key,
    CAST(pl.product_key AS STRING) AS product_key,
    CAST(sd.sod_price_tot AS DECIMAL(18, 2)) AS order_amount,
    CAST(sd.sod_qty_ord AS INT) AS quantity,
    CAST(sd.sod_disc AS DECIMAL(18, 2)) AS discount_amount,
    CAST(sd.sod_tax AS DECIMAL(18, 2)) AS tax_amount
FROM so_mstr_cte so
LEFT JOIN sod_det_cte sd
    ON so.so_nbr = sd.sod_nbr
LEFT JOIN customer_lookup_cte cl
    ON so.so_cust = cl.ad_addr
LEFT JOIN product_lookup_cte pl
    ON sd.sod_nbr = pl.pt_part;