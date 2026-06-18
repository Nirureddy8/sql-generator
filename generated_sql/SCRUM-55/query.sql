-- Databricks notebook source
-- Generated for: SCRUM-55
-- Universal Plan Schema generation
--
-- Query 1: sales_order_detail_transformation
--   Pattern: generic

/**************************************************************************
Generated plan for sales_order_detail
Mapped fields based on provided FIELD MAPPINGS and SCHEMA
**************************************************************************/

-- Query: sales_order_detail_transformation
-- Pattern: generic
-- Coverage: 49 rows

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
)

SELECT
  t.Unique number associated with one requested shipment AS g_delivery_schedule_line_nbr,
  t.Indicator of whether the schedule line will be processed into a customer consignment location AS g_flag_consignment_order,
  t.Designates includion of the item in a higher level virtual (package) sku AS g_flag_has_parent,
  t.Indication of whether material hard committed (reserved excluseively for) to meeting the demand on the schedule line AS g_flag_inventory_fully_allocated,
  t.Designates that the item is a high level virtual (package) sku AS g_flag_is_parent,
  t.An order that occures wholly within ThermoFisher for a given source system AS g_flag_is_transfer_order,
  t.Indicator of whether or not order will be completed against this line AS g_flag_material_transacted,
  t.Designates whether the schedule may be processed for shipment AS g_flag_on_hold,
  t.Indicator of whether or not a given sales order schedule line has open quantity remaining to be shipped. AS g_flag_open_to_ship,
  t.Indicator of whether or not the order is a return order AS g_flag_return,
  t.Indicator of whether or not revenue will be recognized for the sales order schedule AS g_flag_revenue_recognition,
  t.Inco term to be applied to any related shipments AS g_inco_terms,
  t.Date on which the most recent shipment against the schedule line was invoiced AS g_invoice_dt_yyyymmdd,
  t.Unique alphanumeric identifier for an individual product.  Smallest unit of managed inventory. AS g_item_nbr,
  t.Most recent shipment date against the sales order schedule line AS g_last_actual_ship_dt_yyyymmdd,
  t.progression of the order. Erp system specific. AS g_line_status_cd,
  t.Quantity remaining to ship measured in primary unit of measure AS g_open_qty_primary_uom,
  t.Source specific sales order schedule category AS g_order_category,
  t.Unique code within a source system to designate a parent legal entity with base level financial information. AS g_order_company_cd,
  t.Currency that the transaction will physically occur in AS g_order_currency_cd,
  t.date on which the order was placed AS g_order_dt_yyyymmdd,
  t.Unique number containing one or more sales order schedule lines AS g_order_line_nbr,
  t.Unique number used as a reference to a point of sale, a customer, and a set of deliverable items AS g_order_nbr,
  t.Schedule line quantity order in the ordering unit of measure AS g_order_qty_order_uom,
  t.Schedule line quantity order in the primary unit of measure AS g_order_qty_primary_uom,
  t.System specific category to establish order processing path AS g_order_type,
  t.The unit of measure in which the order was placed AS g_order_uom_cd,
  t.Date corresponding to the initial(original) request date from a customer irrespective of any lead time requirements or shipment time AS g_original_customer_request_dt_yyyymmdd,
  t.Date corresponding to the initial(original) confirmed shipment date sent from Thermo to a Customer AS g_original_promised_ship_dt_yyyymmdd,
  t.Line item that is associated with the order AS g_parent_order_line_nbr,
  t.Expected payment terms for any related shipments AS g_payment_terms,
  t.Plant code associated with the sales order line schedule. AS g_plant_cd,
  t.Primary Unit of Measure in the SKU Source, should be the unit of measure used to calculate the standard cost (Pack, Unit, Each, etc) AS g_primary_uom_cd,
  t.Source system calculated date based on expected delivery capabilities / performance AS g_promised_ship_dt_yyyymmdd,
  t.Thermofisher best estimate of item shipment, date that drives MRP demand date AS g_scheduled_ship_dt_yyyymmdd,
  t.Unique number associated with the delivery address for the sales order AS g_ship_to_customer_nbr,
  t.Expected shipment time for a sales order schedule line AS g_ship_to_delivery_days,
  t.Method of shipment for the schedule line AS g_shipment_mode,
  t.Quantity of material that has been shipped against the Sales Order Line in the primary unit of measure AS g_shipped_qty_primary_uom,
  t.Unique alphanumeric identifier for an individual system ingested into the EDP. AS g_source_system_cd,
  t.Standard cost in the primary unit of measure for the item sold AS g_unit_cost_company_currency_primary_uom,
  t.Unit price in the primary unit of measure for the item sold AS g_unit_price_company_currency_primary_uom,
  t.Unit price in the order currency and the primary unit of measure for the item sold AS g_unit_price_order_currency_primary_uom,
  CAST(NULL AS string) AS plant_key,
  CAST(NULL AS string) AS prod_key,
  CAST(NULL AS string) AS prod_plant_key,
  CAST(NULL AS string) AS sls_ord_key,
  CAST(NULL AS string) AS sls_ord_sched_key,
  CAST(NULL AS string) AS flag_is_blanket
FROM True t