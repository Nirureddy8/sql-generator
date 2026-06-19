-- Databricks notebook source
-- Generated for: SCRUM-65
-- Universal Plan Schema generation
--
-- Query 1: sales_order_detail_transformation
--   Pattern: fact_multi_scenario

/**************************************************************************
Generated plan for sales_order_detail with multi-scenario logic.
**************************************************************************/

-- Query: sales_order_detail_transformation
-- Pattern: fact_multi_scenario
-- Coverage: 61 rows

WITH
uom_conversion AS (
  select 
     vbeln,
     posnr,
     etenr,
     edatu,
     bmeng,
     order_qty,
     wavwr,
     company_currency_derive,
     vbap.kwmeng,
     coalesce(case 
                when uom_check = 'yes' 
                then if(netpr=0,netwr/kwmeng,(netpr/kpein))
                else if(netpr=0,netwr/kwmeng,(netpr/kpein)/conversion_factor)
               end,0) as price_uom
from uom_conversion_view
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
uom_conversion_view AS (
  SELECT
    CASE WHEN vbep.vrkme = vbap.meins THEN vbep.bmeng ELSE (marm.umrez / marm.umren) * vbep.bmeng END AS order_qty,
    CASE WHEN uom_check = 'yes' THEN IF(netpr=0, netwr/order_qty, (netpr/kpein)) ELSE IF(netpr=0, netwr/order_qty, (netpr/kpein)/conversion_factor) END AS price_uom
  FROM vbep vbep
  LEFT JOIN marm marm ON vbep.vrkme = marm.meinh
),
currency_conversion AS (
  SELECT
    CASE WHEN trim(vbap.waerk) = trim(t001.waers) THEN IF(trim(vbap.waerk)='JPY', price_uom*100*COALESCE(vbkd.kursk, vbkd_derived.kursk), price_uom*COALESCE(vbkd.kursk, vbkd_derived.kursk))*(tcurf.tfact/tcurf.ffact) ELSE (price_uom*COALESCE(vbkd.kursk, vbkd_derived.kursk))*(tcurf.tfact/tcurf.ffact) END AS unit_price_company_currency
  FROM vbap vbap
  LEFT JOIN t001 t001 ON vbap.bukrs = t001.bukrs
  LEFT JOIN tcurf tcurf ON vbap.waerk = tcurf.ffact AND t001.waers = tcurf.tfact
)

SELECT
  CONCAT_WS('|', gbl, g_order_company_cd) AS co_key,
  CAST(NULL AS string) AS g_allocated_qty_primary_uom,
  CAST(NULL AS string) AS g_availability_dt_yyyymmdd,
  vbap.kunnr AS g_bill_to_customer_nbr,
  CASE WHEN vbap.aedat = '0' THEN vbap.erdat ELSE vbap.aedat END AS g_cancel_dt_yyyymmdd,
  CAST(NULL AS string) AS g_cancel_qty_primary_uom,
  CASE WHEN t001.waers = 'RMB' THEN 'CNY' ELSE t001.waers END AS g_company_currency_cd,
  vbap.kdmat AS g_customer_item_nbr,
  'NULL' AS g_customer_po_line_nbr,
  vbkd.bstkd AS g_customer_po_nbr,
  vbkd.bsark AS g_customer_po_type,
  case when COALESCE(request_date.LAND1, request_date_posnr0.LAND1) not in('US','CA') then COALESCE(request_date.vdatu, request_date_posnr0.vbdatu) 
when COALESCE(request_date.LAND1, request_date_posnr0.LAND1) in('US','CA') then trim(vbep.request_dt) 
else vbep.edatu 
end as original_customer_request_dt_yyyymmdd

For request_date and request_date_posnr0 refer Join Condiions and CTE Sheet,
  vbep.etenr AS g_delivery_schedule_line_nbr,
  CASE WHEN vbap.pstyv IN ('KBN', 'KEN', 'KAN', 'KRN') THEN 'yes' ELSE 'no' END AS g_flag_consignment_order,
  CASE WHEN vbap.uepos IS NOT NULL AND vbap.uepos <> '0' THEN 'yes' ELSE 'no' END AS g_flag_has_parent,
  CAST(NULL AS STRING) AS g_flag_inventory_fully_allocated,
  CAST(NULL AS STRING) AS g_flag_is_parent,
  CAST(NULL AS STRING) AS g_flag_is_transfer_order,
  CAST(NULL AS STRING) AS g_flag_material_transacted,
  CAST(NULL AS STRING) AS g_flag_on_hold,
  CAST(NULL AS STRING) AS g_flag_open_to_ship,
  CAST(NULL AS STRING) AS g_flag_return,
  CAST(NULL AS STRING) AS g_flag_revenue_recognition,
  CAST(NULL AS STRING) AS g_inco_terms,
  CAST(NULL AS STRING) AS g_invoice_dt_yyyymmdd,
  CAST(NULL AS STRING) AS g_item_nbr,
  CAST(NULL AS STRING) AS g_last_actual_ship_dt_yyyymmdd,
  CAST(NULL AS STRING) AS g_line_status_cd,
  CAST(NULL AS STRING) AS g_open_qty_primary_uom,
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
FROM vbap vbap
LEFT JOIN vbep vbep ON vbap.vbeln = vbep.vbeln AND vbap.posnr = vbep.posnr
LEFT JOIN t001 t001 ON vbap.bukrs = t001.bukrs