-- Databricks notebook source
-- Generated for: SCRUM-55
-- Universal Plan Schema generation
--
-- Query 1: sales_order_detail_transformation
--   Pattern: fact_multi_scenario

/**************************************************************************
Generated plan for sales_order_detail table transformation.
**************************************************************************/

-- Query: sales_order_detail_transformation
-- Pattern: fact_multi_scenario
-- Coverage: 49 rows
-- WARNING: unresolved items: No source tables or fields provided for mapping.; No join conditions or logic provided for transformation.

WITH
uom_conversion_view AS (
  select
	vbep.vbeln as vbeln,
	vbep.posnr as posnr,
	vbep.etenr as etenr,
	vbep.edatu as edatu,
	vbep.bmeng as bmeng,
    vbap.wavwr as wavwr,
	vbap.netwr as netwr,
	vbap.netpr as netpr,
	vbap.kpein as kpein,
	if(vbap.meins = vbap.kmein,'yes','no') as uom_check,
	(marm.umrez / marm.umren) as conversion_factor,
	case
		when vbep.vrkme = vbap.meins 
		then vbep.bmeng
		else (marm.umrez / marm.umren)* vbep.bmeng
	end as order_qty,
	mbew.vprsv,
	mbew.verpr,
	mbew.stprs,
  case
      when (mbew.peinh is null or mbew.peinh = 0)
      then 1
      else mbew.peinh
    end as  currency_factor,
  case when trim(mbew.vprsv) = 'V'
      then round(if(t001.waers in('KRW', 'JPY'),mbew.verpr*100,mbew.verpr)/currency_factor,2)
      when trim(mbew.vprsv) = 'S' 
      then round(if(t001.waers in('KRW', 'JPY'),mbew.stprs*100,mbew.stprs)/currency_factor,2)
  end as company_currency_derive,
  vbap.kwmeng
from vbep
left outer join vbap on vbep.vbeln = vbap.vbeln	and vbep.posnr = vbap.posnr
left outer join marm on vbap.matnr = marm.matnr and vbep.vrkme = marm.meinh
left outer join mbew on vbap.matnr = mbew.matnr and vbap.werks = mbew.bwkey and mbew.mandt = '100' and trim(mbew.bwtar)=''
left outer join vbak on vbep.vbeln = vbak.vbeln
left outer join t001 on t001.bukrs = vbak.bukrs_vf
),
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
  CAST(NULL AS string) AS g_delivery_schedule_line_nbr,
  CAST(NULL AS string) AS g_flag_consignment_order,
  CAST(NULL AS string) AS g_flag_has_parent,
  CAST(NULL AS string) AS g_flag_inventory_fully_allocated,
  CAST(NULL AS string) AS g_flag_is_parent,
  CAST(NULL AS string) AS g_flag_is_transfer_order,
  CAST(NULL AS string) AS g_flag_material_transacted,
  CAST(NULL AS string) AS g_flag_on_hold,
  CAST(NULL AS string) AS g_flag_open_to_ship,
  CAST(NULL AS string) AS g_flag_return,
  CAST(NULL AS string) AS g_flag_revenue_recognition,
  CAST(NULL AS string) AS g_inco_terms,
  CAST(NULL AS string) AS g_invoice_dt_yyyymmdd,
  CAST(NULL AS string) AS g_item_nbr,
  CAST(NULL AS string) AS g_last_actual_ship_dt_yyyymmdd,
  CAST(NULL AS string) AS g_line_status_cd,
  CAST(NULL AS string) AS g_open_qty_primary_uom,
  CAST(NULL AS string) AS g_order_category,
  CAST(NULL AS string) AS g_order_company_cd,
  CAST(NULL AS string) AS g_order_currency_cd,
  CAST(NULL AS string) AS g_order_dt_yyyymmdd,
  CAST(NULL AS string) AS g_order_line_nbr,
  CAST(NULL AS string) AS g_order_nbr,
  CAST(NULL AS string) AS g_order_qty_order_uom,
  CAST(NULL AS string) AS g_order_qty_primary_uom,
  CAST(NULL AS string) AS g_order_type,
  CAST(NULL AS string) AS g_order_uom_cd,
  CAST(NULL AS string) AS g_original_customer_request_dt_yyyymmdd,
  CAST(NULL AS string) AS g_original_promised_ship_dt_yyyymmdd,
  CAST(NULL AS string) AS g_parent_order_line_nbr,
  CAST(NULL AS string) AS g_payment_terms,
  CAST(NULL AS string) AS g_plant_cd,
  CAST(NULL AS string) AS g_primary_uom_cd,
  CAST(NULL AS string) AS g_promised_ship_dt_yyyymmdd,
  CAST(NULL AS string) AS g_scheduled_ship_dt_yyyymmdd,
  CAST(NULL AS string) AS g_ship_to_customer_nbr,
  CAST(NULL AS string) AS g_ship_to_delivery_days,
  CAST(NULL AS string) AS g_shipment_mode,
  CAST(NULL AS string) AS g_shipped_qty_primary_uom,
  CAST(NULL AS string) AS g_source_system_cd,
  CAST(NULL AS string) AS g_unit_cost_company_currency_primary_uom,
  CAST(NULL AS string) AS g_unit_price_company_currency_primary_uom,
  CAST(NULL AS string) AS g_unit_price_order_currency_primary_uom,
  CAST(NULL AS string) AS plant_key,
  CAST(NULL AS string) AS prod_key,
  CAST(NULL AS string) AS prod_plant_key,
  CAST(NULL AS string) AS sls_ord_key,
  CAST(NULL AS string) AS sls_ord_sched_key,
  CAST(NULL AS string) AS flag_is_blanket
FROM sto_joined t