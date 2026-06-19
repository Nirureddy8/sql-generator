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
    m.WAERS AS currency_cd,
    IF(m.WAERS = 'RMB', 'CNY', m.WAERS) AS converted_currency_cd
  FROM Move to Vendor/Customer Master m
),
uom_conversion AS (
  SELECT
    CASE WHEN m.bmeng IS NOT NULL THEN m.bmeng ELSE m.wmeng END AS converted_uom
  FROM Move to Vendor/Customer Master m
)

SELECT
  CAST(NULL AS string) AS co_key,
  CAST(NULL AS string) AS g_allocated_qty_primary_uom,
  CAST(NULL AS string) AS g_availability_dt_yyyymmdd,
  m.KUNNR AS g_bill_to_customer_nbr,
  CAST(NULL AS string) AS g_cancel_dt_yyyymmdd,
  CAST(NULL AS string) AS g_cancel_qty_primary_uom,
  m.WAERS AS g_company_currency_cd,
  m.kdmat AS g_customer_item_nbr,
  m.POSEX AS g_customer_po_line_nbr,
  m.bstkd AS g_customer_po_nbr,
  m.bsark AS g_customer_po_type,
  case when COALESCE(request_date.LAND1, request_date_posnr0.LAND1) not in('US','CA') then COALESCE(request_date.vdatu, request_date_posnr0.vbdatu) when COALESCE(request_date.LAND1, request_date_posnr0.LAND1) in('US','CA') then trim(vbep.request_dt) else vbep.edatu end AS g_customer_request_dt_yyyymmdd,
  m.ETENR AS g_delivery_schedule_line_nbr,
  CAST(NULL AS string) AS g_flag_consignment_order,
  m.UEPOS AS g_flag_has_parent,
  m.SOBKZ AS g_flag_inventory_fully_allocated,
  m.UEPOS AS g_flag_is_parent,
  CAST(NULL AS string) AS g_flag_is_transfer_order,
  case when trim(vbak.vbtyp) in ('A', 'B', 'D') then 'no' when trim(VBUP.LFSTA) in ('A', 'B', 'C') and MARA.MTART in ('DIEN', 'NSTK', 'SERV', 'ZSRV') then 'no' when trim(VBUP.LFSTA) = '' or VBUP.LFSTA is NULL then 'no' else 'yes' end AS g_flag_material_transacted,
  CAST(NULL AS string) AS g_flag_on_hold,
  CAST(NULL AS string) AS g_flag_open_to_ship,
  m.VBTYP AS g_flag_return,
  case when coalesce(open_qty_primary_uom, 0) = 0 then 'no' when trim(vbak.vbtyp) in ('A', 'B', 'D') then 'no' when trim(tvap.prsfd) = 'X' then 'yes' else 'no' end AS g_flag_revenue_recognition,
  m.inco1 AS g_inco_terms,
  m.erdat AS g_invoice_dt_yyyymmdd,
  m.MATNR AS g_item_nbr,
  CAST(NULL AS string) AS g_last_actual_ship_dt_yyyymmdd,
  case when upper(trim(vbup.gbsta)) = 'A' then 'NOT YET PROCESSED' when upper(trim(vbup.gbsta)) = 'B' then 'PARTIALLY PROCESSED' when upper(trim(vbup.gbsta)) = 'C' then 'COMPLETELY PROCESSED' else 'NOT RELEVANT' end AS g_line_status_cd,
  case when order_type = 'DEMO' AND ship_lines.sttrg = '7' then 0 when tvap.fkrel in ('A','H','J','K','M','O','P','Q','R','T','U','V','W') then round((coalesce(order_qty_primary_uom,0) - coalesce(lst.shipped_qty,0)),4) when trim(tvap.fkrel) = '' then 0 else round((coalesce(order_qty_primary_uom,0) - (case when lst.shipped_qty <> 0 then lst.shipped_qty when lst.shipped_qty = 0 and inv.invoice_qty <> 0 then inv.invoice_qty else 0 end)), 0) end - coalesce(cancel_qty_primary_uom,0) AS g_open_qty_primary_uom,
  CAST(NULL AS STRING) AS g_order_category,
  CAST(NULL AS STRING) AS g_order_company_cd,
  CAST(NULL AS STRING) AS g_order_currency_cd,
  CAST(NULL AS STRING) AS g_order_dt_yyyymmdd,
  CAST(NULL AS STRING) AS g_order_line_nbr,
  CAST(NULL AS STRING) AS g_order_nbr,
  CAST(NULL AS STRING) AS g_order_qty_order_uom,
  CAST(NULL AS STRING) AS g_order_qty_primary_uom,
  CAST(NULL AS STRING) AS g_order_type,
  CAST(NULL AS STRING) AS g_order_uom_cd,
  CAST(NULL AS STRING) AS g_original_customer_request_dt_yyyymmdd,
  CAST(NULL AS STRING) AS g_original_promised_ship_dt_yyyymmdd,
  CAST(NULL AS STRING) AS g_parent_order_line_nbr,
  CAST(NULL AS STRING) AS g_payment_terms,
  CAST(NULL AS STRING) AS g_plant_cd,
  CAST(NULL AS STRING) AS g_primary_uom_cd,
  CAST(NULL AS STRING) AS g_promised_ship_dt_yyyymmdd,
  CAST(NULL AS STRING) AS g_scheduled_ship_dt_yyyymmdd,
  CAST(NULL AS STRING) AS g_ship_to_customer_nbr,
  CAST(NULL AS STRING) AS g_ship_to_delivery_days,
  CAST(NULL AS STRING) AS g_shipment_mode,
  CAST(NULL AS STRING) AS g_shipped_qty_primary_uom,
  CAST(NULL AS STRING) AS g_source_system_cd,
  CAST(NULL AS STRING) AS g_unit_cost_company_currency_primary_uom,
  CAST(NULL AS STRING) AS g_unit_price_company_currency_primary_uom,
  CAST(NULL AS STRING) AS g_unit_price_order_currency_primary_uom,
  CAST(NULL AS STRING) AS plant_key,
  CAST(NULL AS STRING) AS prod_key,
  CAST(NULL AS STRING) AS prod_plant_key,
  CAST(NULL AS STRING) AS sls_ord_key,
  CAST(NULL AS STRING) AS sls_ord_sched_key,
  CAST(NULL AS STRING) AS flag_is_blanket
FROM Move to Vendor/Customer Master m
LEFT JOIN mara ma ON m.matnr = ma.matnr