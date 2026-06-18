-- Databricks notebook source
-- Generated for: SCRUM-55
-- Universal Plan Schema generation
--
-- Query 1: sales_order_detail_transformation
--   Pattern: fact_multi_scenario

/**************************************************************************
This plan processes the sales_order_detail table with multiple scenarios detected.
Scenarios include currency conversion, SCD, STO, and UOM conversion.
**************************************************************************/

-- Query: sales_order_detail_transformation
-- Pattern: fact_multi_scenario
-- Coverage: 49 rows
-- WARNING: unresolved items: Logic for g_open_qty_primary_uom is unclear.; Logic for g_unit_cost_company_currency_primary_uom is unclear.; Logic for g_unit_price_company_currency_primary_uom is unclear.

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
),
uom_conversion_view AS (
  SELECT 
    vbep.vbeln AS g_order_nbr,
    vbep.posnr AS g_order_line_nbr,
    vbep.etenr AS g_delivery_schedule_line_nbr,
    vbep.bmeng * (marm.umrez / marm.umren) AS g_order_qty_primary_uom,
    marm.meinh AS g_primary_uom_cd
FROM 
    vbep
LEFT JOIN 
    marm
ON 
    vbep.matnr = marm.matnr 
    AND vbep.vrkme = marm.meinh
),
currency_conversion_view AS (
  SELECT 
    src.vbeln AS g_order_nbr,
    src.posnr AS g_order_line_nbr,
    src.waerk AS source_currency,
    tcurf.tcurr AS target_currency,
    src.netwr AS source_amount,
    CASE 
        WHEN tcurf.tcurr IN ('JPY', 'KRW') THEN src.netwr * tcurf.ukurs / 100
        WHEN tcurf.tcurr = 'CNY' AND src.waerk = 'RMB' THEN src.netwr * tcurf.ukurs
        ELSE src.netwr * tcurf.ukurs
    END AS converted_amount,
    tcurf.ukurs AS exchange_rate
FROM 
    sales_order_detail src
JOIN 
    tcurf 
ON 
    src.waerk = tcurf.fcurr 
    AND tcurf.tcurr = 'USD' -- Example target currency, adjust as needed
    AND tcurf.gdatu = (SELECT MAX(gdatu) FROM tcurf WHERE tcurf.fcurr = src.waerk AND tcurf.tcurr = 'USD')
)

SELECT
  vbep.etenr AS g_delivery_schedule_line_nbr,
  CASE WHEN vbap.pstyv IN ('KBN', 'KEN', 'KAN', 'KRN') THEN 'yes' ELSE 'no' END AS g_flag_consignment_order,
  CASE WHEN vbap.uepos IS NOT NULL AND vbap.uepos <> 0 THEN 'yes' ELSE 'no' END AS g_flag_has_parent,
  CASE WHEN mska.sobkz = 'E' AND (mska.kalab > 0 OR mska.kains > 0 OR mska.kaspe > 0 OR mska.kavla > 0 OR mska.kavin > 0 OR mska.kavsp > 0) THEN 'yes' ELSE 'no' END AS g_flag_inventory_fully_allocated,
  CASE WHEN vbap.posnr = vbap.uepos THEN 'yes' ELSE 'no' END AS g_flag_is_parent,
  CASE WHEN knvv.kdgrp IN ('05', '06', '07') OR kna1.ktokd IN ('ZSUB', 'IC3P') THEN 'yes' ELSE 'no' END AS g_flag_is_transfer_order,
  CASE WHEN vbak.vbtyp IN ('A', 'B', 'D') THEN 'no' WHEN vbup.lfsta IN ('A', 'B', 'C') AND mara.mtart IN ('DIEN', 'NSTK', 'SERV', 'ZSRV') THEN 'no' ELSE 'yes' END AS g_flag_material_transacted,
  CASE WHEN vbep.lifsp <> '' THEN 'yes' WHEN vbak.lifsk <> '' THEN 'yes' WHEN vbuk.cmgst IN ('B', 'C') THEN 'yes' ELSE 'no' END AS g_flag_on_hold,
  CASE WHEN vbak.autlf = 'X' THEN 'no' WHEN cancel_qty_primary_uom = order_qty_primary_uom THEN 'no' WHEN open_qty_primary_uom <= 0 THEN 'no' ELSE 'yes' END AS g_flag_open_to_ship,
  CASE WHEN vbak.vbtyp IN ('H', 'T') THEN 'yes' ELSE 'no' END AS g_flag_return,
  CASE WHEN tvap.prsfd = 'X' THEN 'yes' ELSE 'no' END AS g_flag_revenue_recognition,
  vbkd.inco1 AS g_inco_terms,
  vbfa.erdat AS g_invoice_dt_yyyymmdd,
  vbap.matnr AS g_item_nbr,
  vbep.edatu AS g_last_actual_ship_dt_yyyymmdd,
  CASE WHEN vbup.gbsta = 'A' THEN 'NOT YET PROCESSED' WHEN vbup.gbsta = 'B' THEN 'PARTIALLY PROCESSED' WHEN vbup.gbsta = 'C' THEN 'COMPLETELY PROCESSED' ELSE 'NOT RELEVANT' END AS g_line_status_cd,
  CAST(NULL AS string) AS g_open_qty_primary_uom,
  vbap.pstyv AS g_order_category,
  t001k.bukrs AS g_order_company_cd,
  CASE WHEN vbap.waerk = 'RMB' THEN 'CNY' ELSE vbap.waerk END AS g_order_currency_cd,
  vbap.erdat AS g_order_dt_yyyymmdd,
  vbep.posnr AS g_order_line_nbr,
  vbep.vbeln AS g_order_nbr,
  uom_conversion_view.order_qty_order_uom AS g_order_qty_order_uom,
  uom_conversion_view.order_qty_order_uom AS g_order_qty_primary_uom,
  vbak.auart AS g_order_type,
  vbap.vrkme AS g_order_uom_cd,
  vbep.edatu AS g_original_customer_request_dt_yyyymmdd,
  vbep.edatu AS g_original_promised_ship_dt_yyyymmdd,
  vbap.uepos AS g_parent_order_line_nbr,
  vbkd.zterm AS g_payment_terms,
  vbap.werks AS g_plant_cd,
  vbap.meins AS g_primary_uom_cd,
  vbep.edatu AS g_promised_ship_dt_yyyymmdd,
  vbep.mbdat AS g_scheduled_ship_dt_yyyymmdd,
  vbpa.kunnr AS g_ship_to_customer_nbr,
  CASE WHEN vbep.bmeng = 0 THEN 0 ELSE vbep.mbdat - vbep.edatu END AS g_ship_to_delivery_days,
  tvsbt.vtext AS g_shipment_mode,
  vbfa.rfmng AS g_shipped_qty_primary_uom,
  'GBL' AS g_source_system_cd,
  CAST(NULL AS string) AS g_unit_cost_company_currency_primary_uom,
  CAST(NULL AS string) AS g_unit_price_company_currency_primary_uom,
  CAST(NULL AS string) AS g_unit_price_order_currency_primary_uom,
  CONCAT('gbl', '|', vbap.werks) AS plant_key,
  CONCAT('gbl', '|', vbap.matnr) AS prod_key,
  CONCAT('gbl', '|', vbap.matnr, '|', vbap.werks) AS prod_plant_key,
  CONCAT('gbl', '|', t001k.bukrs, '|', vbak.auart, '|', vbep.vbeln) AS sls_ord_key,
  CONCAT('gbl', '|', t001k.bukrs, '|', vbak.auart, '|', vbep.vbeln, '|', vbep.posnr, '|', vbep.etenr) AS sls_ord_sched_key,
  CAST(NULL AS string) AS flag_is_blanket
FROM ok ok
LEFT JOIN vbep vbep ON ok.vbeln = vbep.vbeln AND ok.posnr = vbep.posnr
LEFT JOIN vbap vbap ON vbep.vbeln = vbap.vbeln AND vbep.posnr = vbap.posnr
LEFT JOIN mara mara ON vbap.matnr = mara.matnr
WHERE vbep.vbeln IS NOT NULL AND vbep.posnr IS NOT NULL