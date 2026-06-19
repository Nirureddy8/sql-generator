-- Databricks notebook source
-- Generated for: SCRUM-65
-- Universal Plan Schema generation
--
-- Query 1: sales_order_detail_transformation
--   Pattern: fact_multi_scenario

/**************************************************************************
Generated plan for sales_order_detail with multiple scenarios.
**************************************************************************/

-- Query: sales_order_detail_transformation
-- Pattern: fact_multi_scenario
-- Coverage: 61 rows

WITH
uom_conversion_view AS (
  SELECT
    base.vbeln,
    base.posnr,
    base.matnr,
    base.vrkme,
    base.meins,
    base.bmeng,
    base.netpr,
    marm.umrez,
    marm.umren,
    CASE
      WHEN base.vrkme = base.meins THEN base.bmeng
      WHEN marm.umren = 0 OR marm.umren IS NULL THEN base.bmeng
      ELSE base.bmeng * (marm.umrez / marm.umren)
    END AS qty_primary_uom,
    CASE
      WHEN base.vrkme = base.meins THEN base.netpr
      WHEN marm.umrez = 0 OR marm.umrez IS NULL THEN base.netpr
      ELSE base.netpr * (marm.umren / marm.umrez)
    END AS price_primary_uom
  FROM vbep base
  LEFT JOIN marm marm
    ON marm.matnr = base.matnr
   AND marm.meinh = base.vrkme
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
),
currency_conversion AS (
  SELECT
    vbap.waerk AS order_currency,
    t001.waers AS company_currency,
    CASE WHEN t001.waers = 'JPY' THEN vbap.netpr * 100 ELSE vbap.netpr END AS converted_price
  FROM vbap vbap
  LEFT JOIN t001 t001 ON vbap.bukrs = t001.bukrs
),
uom_conversion AS (
  SELECT
    CASE WHEN vbep_bmeng.calculated_bmeng IS NOT NULL AND vbep_bmeng.calculated_bmeng > 0 THEN vbep.bmeng ELSE vbep.wmeng END AS converted_uom
  FROM vbep vbep
),
sto AS (
  SELECT
    vbap.matnr AS material_number,
    mara.mtart AS material_type
  FROM vbap vbap
  LEFT JOIN mara mara ON vbap.matnr = mara.matnr
),
scd AS (
  SELECT
    vbap.erdat AS created_date,
    vbap.aedat AS changed_date
  FROM vbap vbap
)

SELECT * FROM currency_conversion
UNION ALL
SELECT * FROM uom_conversion
UNION ALL
SELECT * FROM sto
UNION ALL
SELECT * FROM scd