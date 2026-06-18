-- Databricks notebook source
-- Generated for: SCRUM-55
-- Universal Plan Schema generation
--
-- Query 1: sales_order_detail_transformation
--   Pattern: fact_join_enriched

/**************************************************************************
Generated plan for sales_order_detail table.
Includes joins, derived columns, and business rules.
**************************************************************************/

-- Query: sales_order_detail_transformation
-- Pattern: fact_join_enriched
-- Coverage: 49 rows

WITH
sto_orders AS (
  SELECT
    ekpo.ebeln AS order_nbr,
    ekpo.ebelp AS order_line_nbr,
    ekpo.matnr AS item_nbr,
    ekpo.werks AS plant_cd,
    ekpo.menge AS order_qty,
    ekpo.meins AS order_uom_cd,
    ekko.bsart AS order_type,
    ekko.bukrs AS order_company_cd,
    ekko.aedat AS order_dt
  FROM ekpo ekpo
  INNER JOIN ekko ekko
    ON ekko.ebeln = ekpo.ebeln
  WHERE ekko.bsart IN ('UB', 'NB')
),
sto_receipts AS (
  SELECT
    ekbe.ebeln,
    ekbe.ebelp,
    ekbe.budat AS receipt_dt,
    ekbe.menge AS receipt_qty,
    ekbe.shkzg
  FROM ekbe ekbe
  WHERE ekbe.bwart IN ('101', '102', '161', '162')
    AND ekbe.vgabe = '1'
),
sto_received_qty AS (
  SELECT
    ebeln,
    ebelp,
    SUM(
      CASE
        WHEN shkzg = 'H' THEN -1 * receipt_qty
        ELSE receipt_qty
      END
    ) AS total_received_qty,
    MAX(receipt_dt) AS last_receipt_dt
  FROM sto_receipts
  GROUP BY ebeln, ebelp
),
sto_joined AS (
  SELECT
    o.*,
    COALESCE(r.total_received_qty, 0) AS total_received_qty,
    r.last_receipt_dt,
    (o.order_qty - COALESCE(r.total_received_qty, 0)) AS open_qty
  FROM sto_orders o
  LEFT JOIN sto_received_qty r
    ON r.ebeln = o.order_nbr
   AND r.ebelp = o.order_line_nbr
),
invoice_dt_lookup AS (
  SELECT
    vbfa.vbelv AS order_vbeln,
    vbfa.posnv AS order_posnr,
    MIN(vbfa.erdat) AS first_invoice_dt,
    MAX(vbfa.erdat) AS last_invoice_dt
  FROM vbfa vbfa
  WHERE vbfa.vbtyp_n = 'M'
  GROUP BY vbfa.vbelv, vbfa.posnv
)

SELECT
  CAST(NULL AS ) AS g_delivery_schedule_line_nbr,
  CAST(NULL AS ) AS g_flag_consignment_order
FROM tvsbt tvsbt
LEFT JOIN VBEP vbep ON tvsbt.some_column = vbep.some_column
LEFT JOIN VBAP vbap ON tvsbt.some_column = vbap.some_column
LEFT JOIN (SELECT g_original_customer_request_dt_yyyymmdd,
      g_original_promised_ship_dt_yyyymmdd FROM sales_order_detail WHERE src_sys_cd = 'gbl') prior_load ON prior_load.business_key = main.business_key  -- TODO: update business key columns