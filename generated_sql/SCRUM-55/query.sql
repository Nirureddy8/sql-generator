-- Databricks notebook source
-- Generated for: SCRUM-55
-- Universal Plan Schema generation
--
-- Query 1: sales_order_detail_transformation
--   Pattern: fact_join_enriched
-- Query 2: Sales_Order_Detail_transformation
--   Pattern: fact_join_enriched

-- =============================
-- sales_order_detail_transformation
-- =============================
/**************************************************************************
Artefact Name :- sales_order_detail SQL
Description  :- Generate sales order detail fact table with enriched joins and derived columns
**************************************************************************/

-- Query: sales_order_detail_transformation
-- Pattern: fact_join_enriched
-- Coverage: 7 rows

SELECT
  CASE WHEN vbak.vbtyp IN ('H', 'T') THEN 'Yes' ELSE 'No' END AS g_flag_return,
  vbap.uepos AS g_parent_order_line_nbr,
  CONCAT('gbl', tvsbt.g_plant_cd) AS plant_key,
  CONCAT('gbl', tvsbt.g_item_nbr) AS prod_key,
  CONCAT('gbl', tvsbt.g_item_nbr, tvsbt.g_plant_cd) AS prod_plant_key,
  CONCAT('gbl', tvsbt.g_order_company_cd, tvsbt.g_order_type, tvsbt.g_order_nbr) AS sls_ord_key,
  CONCAT('gbl', tvsbt.g_order_company_cd, tvsbt.g_order_type, tvsbt.g_order_nbr, tvsbt.g_order_line_nbr, tvsbt.g_delivery_schedule_line_nbr) AS sls_ord_sched_key
FROM tvsbt tvsbt
LEFT JOIN vbak vbak ON tvsbt.vbeln = vbak.vbeln
LEFT JOIN vbap vbap ON tvsbt.vbeln = vbap.vbeln AND tvsbt.posnr = vbap.posnr

-- =============================
-- Sales_Order_Detail_transformation
-- =============================
/**************************************************************************
Artefact Name :- Sales_Order_Detail SQL
Description  :- Generates the Sales Order Detail fact table with enriched joins and derived fields.
**************************************************************************/

-- Query: Sales_Order_Detail_transformation
-- Pattern: fact_join_enriched
-- Coverage: 42 rows

WITH
uom_conversion_view AS (
  SELECT
    vbep.vbeln,
    vbep.posnr,
    CASE WHEN vbep.vrkme = vbep.meins THEN vbep.bmeng ELSE (marm.umrez / marm.umren) * vbep.bmeng END AS order_qty,
    CASE WHEN vbep.vrkme = vbep.meins THEN vbep.netpr ELSE (vbep.netpr / marm.umrez) * marm.umren END AS price_uom
  FROM vbep vbep
  LEFT JOIN marm marm ON vbep.vrkme = marm.meinh AND vbep.matnr = marm.matnr
)

SELECT
  vbep.etenr AS g_delivery_schedule_line_nbr,
  CASE WHEN vbap.pstyv IN ('KBN', 'KEN', 'KAN', 'KRN') THEN 'yes' ELSE 'no' END AS g_flag_consignment_order,
  CASE WHEN vbap.uepos IS NOT NULL AND vbap.uepos <> '0' THEN 'yes' ELSE 'no' END AS g_flag_has_parent,
  CASE WHEN mska.sobkz = 'E' AND (mska.kalab > 0 OR mska.kains > 0 OR mska.kaspe > 0 OR mska.kavla > 0 OR mska.kavin > 0 OR mska.kavsp > 0) THEN 'yes' ELSE 'no' END AS g_flag_inventory_fully_allocated,
  CASE WHEN vbap.posnr = vbap.uepos THEN 'yes' ELSE 'no' END AS g_flag_is_parent,
  CASE WHEN vbak.kunnr IN (SELECT kna1.kunnr FROM kna1 WHERE kna1.ktokd IN ('ZSUB', 'IC3P')) OR (vbak.kunnr, vbak.vkorg, vbak.vtweg, vbak.spart) IN (SELECT knvv.kunnr, knvv.vkorg, knvv.vtweg, knvv.spart FROM knvv WHERE knvv.kdgrp IN ('05', '06', '07')) THEN 'yes' ELSE 'no' END AS g_flag_is_transfer_order,
  CASE WHEN trim(vbak.vbtyp) IN ('A', 'B', 'D') THEN 'no' WHEN trim(vbup.lfsta) IN ('A', 'B', 'C') AND mara.mtart IN ('DIEN', 'NSTK', 'SERV', 'ZSRV') THEN 'no' WHEN trim(vbup.lfsta) = '' OR vbup.lfsta IS NULL THEN 'no' ELSE 'yes' END AS g_flag_material_transacted,
  CASE WHEN vbep.lifsp <> '' THEN 'yes' WHEN vbak.lifsk <> '' THEN 'yes' WHEN vbuk.cmgst IN ('B', 'C') THEN 'yes' ELSE 'no' END AS g_flag_on_hold,
  CASE WHEN vbak.autlf = 'X' THEN 'no' WHEN cancel_qty_primary_uom = order_qty_primary_uom THEN 'no' WHEN open_qty_primary_uom <= 0 THEN 'no' ELSE 'yes' END AS g_flag_open_to_ship,
  CASE WHEN order_qty_primary_uom = 0 THEN 'no' WHEN trim(vbak.vbtyp) IN ('A', 'B', 'D') THEN 'no' WHEN trim(tvap.prsfd) = 'X' THEN 'yes' ELSE 'no' END AS g_flag_revenue_recognition,
  vbkd.inco1 AS g_inco_terms,
  vbfa.erdat AS g_invoice_dt_yyyymmdd,
  vbap.matnr AS g_item_nbr,
  vbup.gbsta AS g_line_status_cd
FROM vbep vbep
LEFT JOIN vbap vbap ON vbep.vbeln = vbap.vbeln AND vbep.posnr = vbap.posnr
LEFT JOIN vbak vbak ON vbep.vbeln = vbak.vbeln
LEFT JOIN vbup vbup ON vbep.vbeln = vbup.vbeln AND vbep.posnr = vbup.posnr
LEFT JOIN vbfa vbfa ON vbep.vbeln = vbfa.vbelv AND vbep.posnr = vbfa.posnv
LEFT JOIN vbkd vbkd ON vbep.vbeln = vbkd.vbeln AND vbkd.posnr = '000000'
LEFT JOIN tvsbt tvsbt ON vbak.vsbed = tvsbt.vsbed AND tvsbt.spras = 'E' AND tvsbt.mandt_id = '100'
LEFT JOIN t001w t001w ON vbap.werks = t001w.werks
LEFT JOIN t001k t001k ON t001w.bwkey = t001k.bwkey
LEFT JOIN mara mara ON vbap.matnr = mara.matnr
