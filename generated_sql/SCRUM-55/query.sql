-- Databricks notebook source
-- Generated for: SCRUM-55
-- Universal Plan Schema generation
--
-- Query 1: sales_order_detail_transformation
--   Pattern: fact_multi_scenario

/**************************************************************************
Generated plan for sales_order_detail
Includes multiple scenarios: currency_conversion, scd, sto, uom_conversion
**************************************************************************/

-- Query: sales_order_detail_transformation
-- Pattern: fact_multi_scenario
-- Coverage: 49 rows
-- WARNING: unresolved items: Logic for g_flag_revenue_recognition is incomplete.; Logic for g_original_customer_request_dt_yyyymmdd is unclear.; Logic for g_unit_cost_company_currency_primary_uom is partially defined.

WITH
uom_conversion_view AS (
  
),
currency_conversion_view AS (
  
)

SELECT
  vbep.ETENR AS g_delivery_schedule_line_nbr,
  CASE WHEN vbap.PSTYV IN ('KBN', 'KEN', 'KAN', 'KRN') THEN 'yes' ELSE 'no' END AS g_flag_consignment_order,
  CASE WHEN vbap.UEPOS IS NOT NULL AND vbap.UEPOS <> 0 THEN 'yes' ELSE 'no' END AS g_flag_has_parent,
  CASE WHEN mska.SOBKZ = 'E' AND (mska.KALAB > 0 OR mska.KAINS > 0 OR mska.KASPE > 0 OR mska.KAVLA > 0 OR mska.KAVIN > 0 OR mska.KAVSP > 0) THEN 'yes' ELSE 'no' END AS g_flag_inventory_fully_allocated,
  CASE WHEN vbap.POSNR = vbap.UEPOS THEN 'yes' ELSE 'no' END AS g_flag_is_parent,
  CASE WHEN vbak.KUNNR IN (SELECT KUNNR FROM kna1 WHERE KTOKD IN ('ZSUB', 'IC3P')) OR (vbak.KUNNR, vbak.VKORG, vbak.VTWEG, vbak.SPART) IN (SELECT KDGRP FROM knvv WHERE KDGRP IN ('05', '06', '07')) THEN 'yes' ELSE 'no' END AS g_flag_is_transfer_order,
  CASE WHEN vbak.VBTYP IN ('A', 'B', 'D') THEN 'no' WHEN vbup.LFSTA IN ('A', 'B', 'C') AND mara.MTART IN ('DIEN', 'NSTK', 'SERV', 'ZSRV') THEN 'no' ELSE 'yes' END AS g_flag_material_transacted,
  CASE WHEN vbep.LIFSP <> '' THEN 'yes' WHEN vbak.LIFSK <> '' THEN 'yes' WHEN vbuk.CMGST IN ('B', 'C') THEN 'yes' ELSE 'no' END AS g_flag_on_hold,
  CASE WHEN vbak.AUTLF = 'X' THEN 'no' WHEN cancel_qty_primary_uom = order_qty_primary_uom THEN 'no' WHEN open_qty_primary_uom <= 0 THEN 'no' ELSE 'yes' END AS g_flag_open_to_ship,
  CASE WHEN vbak.VBTYP IN ('H', 'T') THEN 'yes' ELSE 'no' END AS g_flag_return
FROM tvsbt t
LEFT JOIN vbep vbep ON t.vbeln = vbep.vbeln AND t.posnr = vbep.posnr
LEFT JOIN vbap vbap ON vbep.vbeln = vbap.vbeln AND vbep.posnr = vbap.posnr
LEFT JOIN vbak vbak ON vbep.vbeln = vbak.vbeln
LEFT JOIN vbup vbup ON vbep.vbeln = vbup.vbeln AND vbep.posnr = vbup.posnr
LEFT JOIN vbkd vbkd ON vbep.vbeln = vbkd.vbeln AND vbep.posnr = vbkd.posnr
LEFT JOIN t001w t001w ON vbap.werks = t001w.werks
LEFT JOIN vbpa vbpa ON vbep.vbeln = vbpa.vbeln AND vbpa.parvw = 'WE'
WHERE vbep.ETENR IS NOT NULL