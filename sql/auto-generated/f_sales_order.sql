/**********************************************************************
artefact name :- f_sales_order
description   :- f_sales_order sql generated via multi-pass CTE pipeline
----------------------------------------------------------------------
change log
version :   date :        description :                       changed by
----------------------------------------------------------------------
0.0         2026-06-22    auto-generated multi-pass            ai_agent
**********************************************************************/

with
header_extract as (
    select 
    concat('gbl', g_order_company_cd) as co_key,
    case 
        when exists (
            select 1 
            from mska 
            where mska.vbeln = vbap.vbeln 
              and mska.posnr = vbap.posnr
        ) 
        then kalab + kains + kaspe + kavla + kavin + kavsp
        else g_shipped_qty_primary_uom
    end as g_allocated_qty_primary_uom,
    null as g_availability_dt_yyyymmdd,
    case 
        when vbap.posnr is not null 
        then (
            select kunnr 
            from vbap 
            where vbeln = g_order_nbr 
              and posnr = g_order_line_nbr 
              and parvw = 'RE/BP'
        )
        else (
            select kunnr 
            from vbap 
            where vbeln = g_order_nbr 
              and parvw = 'RE/BP'
        )
    end as g_bill_to_customer_nbr,
    case 
        when vbap.abgru is null 
        then null 
        else coalesce(vbap.aedat, vbap.erdat)
    end as g_cancel_dt_yyyymmdd,
    null as g_cancel_qty_primary_uom,
    case 
        when t001.waers = 'RMB' 
        then 'CNY' 
        else t001.waers
    end as g_company_currency_cd,
    vbap.kdmat as g_customer_item_nbr,
    null as g_customer_po_line_nbr,
    case 
        when vbap.posnr is not null 
        then (
            select bstdk 
            from vbkd 
            where vbeln = g_order_nbr 
              and posnr = g_order_line_nbr
        )
        else (
            select bstdk 
            from vbkd 
            where vbeln = g_order_nbr
        )
    end as g_customer_po_nbr,
    case 
        when vbap.posnr is not null 
        then (
            select bsark 
            from vbkd 
            where vbeln = g_order_nbr 
              and posnr = g_order_line_nbr
        )
        else (
            select bsark 
            from vbkd 
            where vbeln = g_order_nbr
        )
    end as g_customer_po_type,
    case 
        when coalesce(request_date.land1, request_date_posnr0.land1) not in ('US', 'CA') 
        then coalesce(request_date.vdatu, request_date_posnr0.vbdatu)
        when coalesce(request_date.land1, request_date_posnr0.land1) in ('US', 'CA') 
        then trim(vbep.request_dt)
        else vbep.edatu
    end as g_customer_request_dt_yyyymmdd,
    vbep.etenr as g_delivery_schedule_line_nbr,
    case 
        when vbap.pstyv in ('KBN', 'KEN', 'KAN', 'KRN') 
        then 'yes' 
        else 'no'
    end as g_flag_consignment_order,
    case 
        when vbap.uepos is not null and vbap.uepos != 0 
        then 'yes' 
        else 'no'
    end as g_flag_has_parent,
    case 
        when mska.sobkz = 'E' 
          and (kalab > 0 or kains > 0 or kaspe > 0 or kavla > 0 or kavin > 0 or kavsp > 0) 
        then 'yes' 
        else 'no'
    end as g_flag_inventory_fully_allocated,
    case 
        when vbap.posnr = any (
            select uepos 
            from vbap 
            where vbeln = vbap.vbeln
        ) 
        then 'yes' 
        else 'no'
    end as g_flag_is_parent,
    case 
        when exists (
            select 1 
            from knvv 
            where knvv.kdgrp in ('05', '06', '07') 
              and knvv.kunnr = vbak.kunnr 
              and knvv.vkorg = vbak.vkorg 
              and knvv.vtweg = vbak.vtweg 
              and knvv.spart = vbak.spart
        ) 
        or exists (
            select 1 
            from kna1 
            where kna1.ktokd in ('ZSUB', 'IC3P') 
              and kna1.kunnr = vbak.kunnr
        ) 
        then 'yes' 
        else 'no'
    end as g_flag_is_transfer_order,
    case 
        when vbep.ettp = tvep.ettp 
          and tvep.bedsd = 'X' 
        then 'yes'
        when vbep.ettp = tvep.ettp 
          and tvep.bedsd is null 
          and tvep.knttp in ('M', 'X') 
        then 'yes'
        when order_qty_primary_uom = 0 
        then 'no'
        else 'no'
    end as g_flag_material_transacted,
    case 
        when vbep.lifsp is not null 
        then 'yes'
        when vbak.lifsk is not null 
        then 'yes'
        when vbuk.cmgst in ('B', 'C') 
        then 'yes'
        else 'no'
    end as g_flag_on_hold
from vbap
left join vbep on vbep.vbeln = vbap.vbeln and vbep.posnr = vbap.posnr
left join t001 on t001.bukrs = g_order_company_cd
left join mska on mska.vbeln = vbap.vbeln and mska.posnr = vbap.posnr
),
item_extract as (
    select 
  concat('gbl', g_order_company_cd) as co_key,
  case 
    when exists (
      select 1 
      from mska 
      where mska.vbeln = vbap.vbeln 
        and mska.posnr = vbap.posnr
    ) then 
      coalesce(mska.kalab, 0) + coalesce(mska.kains, 0) + coalesce(mska.kaspe, 0) + coalesce(mska.kavla, 0) + coalesce(mska.kavin, 0) + coalesce(mska.kavsp, 0)
    else 
      vbap.g_shipped_qty_primary_uom
  end as g_allocated_qty_primary_uom,
  null as g_availability_dt_yyyymmdd,
  case 
    when vbap.posnr is not null then (
      select kunnr 
      from vbap 
      where vbeln = vbap.vbeln 
        and posnr = vbap.posnr 
        and parvw = 'RE/BP'
    )
    else (
      select kunnr 
      from vbap 
      where vbeln = vbap.vbeln 
        and parvw = 'RE/BP'
    )
  end as g_bill_to_customer_nbr,
  case 
    when vbap.abgru is null or vbap.abgru = '' then null
    when vbap.aedat = 0 then vbap.erdat
    else vbap.aedat
  end as g_cancel_dt_yyyymmdd,
  null as g_cancel_qty_primary_uom,
  case 
    when t001.waers = 'RMB' then 'CNY'
    else t001.waers
  end as g_company_currency_cd,
  vbap.kdmat as g_customer_item_nbr,
  null as g_customer_po_line_nbr,
  case 
    when vbap.posnr is not null then (
      select bstdk 
      from vbkd 
      where vbeln = vbap.vbeln 
        and posnr = vbap.posnr
    )
    else (
      select bstdk 
      from vbkd 
      where vbeln = vbap.vbeln
    )
  end as g_customer_po_nbr,
  case 
    when vbap.posnr is not null then (
      select bsark 
      from vbkd 
      where vbeln = vbap.vbeln 
        and posnr = vbap.posnr
    )
    else (
      select bsark 
      from vbkd 
      where vbeln = vbap.vbeln
    )
  end as g_customer_po_type,
  case 
    when coalesce(request_date.land1, request_date_posnr0.land1) not in ('US', 'CA') then coalesce(request_date.vdatu, request_date_posnr0.vbdatu)
    when coalesce(request_date.land1, request_date_posnr0.land1) in ('US', 'CA') then trim(vbep.request_dt)
    else vbep.edatu
  end as g_customer_request_dt_yyyymmdd,
  vbep.etenr as g_delivery_schedule_line_nbr,
  case 
    when vbap.pstyv in ('KBN', 'KEN', 'KAN', 'KRN') then 'yes'
    else 'no'
  end as g_flag_consignment_order,
  case 
    when vbap.uepos is not null and vbap.uepos <> 0 then 'yes'
    else 'no'
  end as g_flag_has_parent,
  case 
    when mska.sobkz = 'E' 
      and (coalesce(mska.kalab, 0) + coalesce(mska.kains, 0) + coalesce(mska.kaspe, 0) + coalesce(mska.kavla, 0) + coalesce(mska.kavin, 0) + coalesce(mska.kavsp, 0)) > 0 then 'yes'
    else 'no'
  end as g_flag_inventory_fully_allocated,
  case 
    when vbap.posnr = vbap.uepos then 'yes'
    else 'no'
  end as g_flag_is_parent,
  case 
    when exists (
      select 1 
      from knvv 
      where knvv.kunnr = vbak.kunnr 
        and knvv.vkorg = vbak.vkorg 
        and knvv.vtweg = vbak.vtweg 
        and knvv.spart = vbak.spart 
        and knvv.kdgrp in ('05', '06', '07')
    ) or exists (
      select 1 
      from kna1 
      where kna1.kunnr = vbak.kunnr 
        and kna1.ktokd in ('ZSUB', 'IC3P')
    ) then 'yes'
    else 'no'
  end as g_flag_is_transfer_order,
  case 
    when exists (
      select 1 
      from tvep 
      where vbep.ettyp = tvep.ettyp 
        and tvep.bedsd = 'X'
    ) then 'yes'
    when exists (
      select 1 
      from tvep 
      where vbep.ettyp = tvep.ettyp 
        and tvep.bedsd is null 
        and tvep.knttp in ('M', 'X')
    ) then 'yes'
    when vbep.order_qty_primary_uom = 0 then 'no'
    else 'no'
  end as g_flag_material_transacted,
  case 
    when vbep.lifsp is not null and vbep.lifsp <> '' then 'yes'
    when vbak.lifsk is not null and vbak.lifsk <> '' then 'yes'
    when vbuk.cmgst in ('B', 'C') then 'yes'
    else 'no'
  end as g_flag_on_hold
from vbap
left join vbep on vbep.vbeln = vbap.vbeln and vbep.posnr = vbap.posnr
left join marm on vbap.matnr = marm.matnr and vbep.vrkme = marm.meinh
left join mbew on vbap.matnr = mbew.matnr and vbap.werks = mbew.bwkey
left join t001 on t001.bukrs = vbap.g_order_company_cd
left join mska on mska.vbeln = vbap.vbeln and mska.posnr = vbap.posnr
left join vbak on vbak.vbeln = vbap.vbeln
left join vbuk on vbuk.vbeln = vbap.vbeln
),
schedule_extract as (
    select 
  concat('gbl', vbap.vbeln) as co_key,
  case 
    when exists (
      select 1 
      from mska 
      where mska.vbeln = vbap.vbeln 
        and mska.posnr = vbap.posnr
    ) then 
      coalesce(mska.kalab, 0) + 
      coalesce(mska.kains, 0) + 
      coalesce(mska.kaspe, 0) + 
      coalesce(mska.kavla, 0) + 
      coalesce(mska.kavin, 0) + 
      coalesce(mska.kavsp, 0)
    else vbep.bmeng
  end as g_allocated_qty_primary_uom,
  null as g_availability_dt_yyyymmdd,
  case 
    when vbap.posnr is not null then (
      select kunnr 
      from vbap 
      where vbeln = vbap.vbeln 
        and posnr = vbap.posnr 
        and parvw = 'RE/BP'
    )
    else (
      select kunnr 
      from vbap 
      where vbeln = vbap.vbeln 
        and parvw = 'RE/BP'
    )
  end as g_bill_to_customer_nbr,
  case 
    when vbap.abgru is null then null
    else coalesce(vbap.aedat, vbap.erdat)
  end as g_cancel_dt_yyyymmdd,
  null as g_cancel_qty_primary_uom,
  case 
    when t001.waers = 'RMB' then 'CNY'
    else t001.waers
  end as g_company_currency_cd,
  vbap.kdmat as g_customer_item_nbr,
  null as g_customer_po_line_nbr,
  case 
    when vbap.posnr is not null then (
      select bstdk 
      from vbkd 
      where vbeln = vbap.vbeln 
        and posnr = vbap.posnr
    )
    else (
      select bstdk 
      from vbkd 
      where vbeln = vbap.vbeln
    )
  end as g_customer_po_nbr,
  case 
    when vbap.posnr is not null then (
      select bsark 
      from vbkd 
      where vbeln = vbap.vbeln 
        and posnr = vbap.posnr
    )
    else (
      select bsark 
      from vbkd 
      where vbeln = vbap.vbeln
    )
  end as g_customer_po_type,
  case 
    when coalesce(request_date.land1, request_date_posnr0.land1) not in ('US', 'CA') then 
      coalesce(request_date.vdatu, request_date_posnr0.vbdatu)
    when coalesce(request_date.land1, request_date_posnr0.land1) in ('US', 'CA') then 
      trim(vbep.request_dt)
    else vbep.edatu
  end as g_customer_request_dt_yyyymmdd,
  vbep.etenr as g_delivery_schedule_line_nbr,
  case 
    when vbap.pstyv in ('KBN', 'KEN', 'KAN', 'KRN') then 'yes'
    else 'no'
  end as g_flag_consignment_order,
  case 
    when vbap.uepos is not null and vbap.uepos != 0 then 'yes'
    else 'no'
  end as g_flag_has_parent,
  case 
    when mska.sobkz = 'E' and (
      coalesce(mska.kalab, 0) + 
      coalesce(mska.kains, 0) + 
      coalesce(mska.kaspe, 0) + 
      coalesce(mska.kavla, 0) + 
      coalesce(mska.kavin, 0) + 
      coalesce(mska.kavsp, 0)
    ) > 0 then 'yes'
    else 'no'
  end as g_flag_inventory_fully_allocated,
  case 
    when vbap.posnr = vbap.uepos then 'yes'
    else 'no'
  end as g_flag_is_parent,
  case 
    when vbak.kunnr in (
      select kna1.kunnr 
      from kna1 
      where kna1.ktokd in ('ZSUB', 'IC3P')
    ) then 'yes'
    when vbak.kunnr in (
      select knvv.kunnr 
      from knvv 
      where knvv.kdgrp in ('05', '06', '07')
    ) then 'yes'
    else 'no'
  end as g_flag_is_transfer_order,
  case 
    when tvep.bedsd = 'X' then 'yes'
    when tvep.bedsd is null and tvep.knttp in ('M', 'X') then 'yes'
    when vbep.bmeng = 0 then 'no'
    else 'no'
  end as g_flag_material_transacted,
  case 
    when vbep.lifsp is not null then 'yes'
    when vbak.lifsk is not null then 'yes'
    when vbuk.cmgst in ('B', 'C') then 'yes'
    else 'no'
  end as g_flag_on_hold
from vbep
left join vbap on vbep.vbeln = vbap.vbeln and vbep.posnr = vbap.posnr
left join marm on vbap.matnr = marm.matnr and vbep.vrkme = marm.meinh
left join mbew on vbap.matnr = mbew.matnr and vbap.werks = mbew.bwkey
left join mska on vbap.vbeln = mska.vbeln and vbap.posnr = mska.posnr
left join t001 on vbap.bukrs = t001.bukrs
),
uom_conversion as (
    select 
    vbap.matnr,
    vbap.werks,
    vbap.vrkme as order_uom_cd,
    vbap.meins as primary_uom_cd,
    case 
        when vbep.vrkme = vbap.meins 
        then vbep.bmeng
        else (marm.umrez / marm.umren) * vbep.bmeng
    end as order_qty_primary_uom,
    vbep.bmeng as order_qty_order_uom,
    case 
        when vbep.vrkme = vbap.meins 
        then vbep.wmeng
        else (marm.umrez / marm.umren) * vbep.wmeng
    end as shipped_qty_primary_uom,
    case 
        when trim(mbew.vprsv) = 'V'
        then round(if(t001.waers in ('KRW', 'JPY'), mbew.verpr * 100, mbew.verpr) / currency_factor, 2)
        when trim(mbew.vprsv) = 'S'
        then round(if(t001.waers in ('KRW', 'JPY'), mbew.stprs * 100, mbew.stprs) / currency_factor, 2)
    end as unit_cost_company_currency_primary_uom,
    case 
        when trim(vbap.waerk) = trim(t001.waers) 
        then if(trim(vbap.waerk) = 'JPY', puom.price_uom * 100 * coalesce(vbkd.kursk, vbkd_derived.kursk), puom.price_uom * coalesce(vbkd.kursk, vbkd_derived.kursk)) * (tcurf.tfact / tcurf.ffact)
        else (puom.price_uom * coalesce(vbkd.kursk, vbkd_derived.kursk)) * (tcurf.tfact / tcurf.ffact)
    end as unit_price_company_currency_primary_uom,
    case 
        when vbep.vrkme = vbap.meins 
        then vbep.bmeng
        else (marm.umrez / marm.umren) * vbep.bmeng
    end as unit_price_order_currency_primary_uom
from vbep
left join vbap on vbep.vbeln = vbap.vbeln and vbep.posnr = vbap.posnr
left join marm on vbap.matnr = marm.matnr and vbep.vrkme = marm.meinh
left join mbew on vbap.matnr = mbew.matnr and vbap.werks = mbew.bwkey
left join t001 on vbap.werks = t001.bukrs
left join vbkd on vbap.vbeln = vbkd.vbeln
left join vbkd_derived on vbap.vbeln = vbkd_derived.vbeln
left join tcurf on vbap.waerk = tcurf.ffact and t001.waers = tcurf.tfact
),
document_flow as (
    select 
    concat('gbl', g_order_company_cd) as co_key,
    case 
        when exists (
            select 1 
            from mska 
            where mska.vbeln = vbap.vbeln 
              and mska.posnr = vbap.posnr
        ) then (
            coalesce(mska.kalab, 0) + 
            coalesce(mska.kains, 0) + 
            coalesce(mska.kaspe, 0) + 
            coalesce(mska.kavla, 0) + 
            coalesce(mska.kavin, 0) + 
            coalesce(mska.kavsp, 0)
        )
        else g_shipped_qty_primary_uom
    end as g_allocated_qty_primary_uom,
    null as g_availability_dt_yyyymmdd,
    case 
        when vbap.posnr is not null then (
            select kunnr 
            from vbpa 
            where vbpa.vbeln = vbap.vbeln 
              and vbpa.posnr = vbap.posnr 
              and vbpa.parvw = 'RE/BP'
        )
        else (
            select kunnr 
            from vbpa 
            where vbpa.vbeln = vbap.vbeln 
              and vbpa.parvw = 'RE/BP'
        )
    end as g_bill_to_customer_nbr,
    case 
        when vbap.aedat = 0 then vbap.erdat
        else vbap.aedat
    end as g_cancel_dt_yyyymmdd,
    null as g_cancel_qty_primary_uom,
    case 
        when t001.waers = 'RMB' then 'CNY'
        else t001.waers
    end as g_company_currency_cd,
    vbap.kdmat as g_customer_item_nbr,
    null as g_customer_po_line_nbr,
    case 
        when vbap.posnr is not null then (
            select bstdk 
            from vbkd 
            where vbkd.vbeln = vbap.vbeln 
              and vbkd.posnr = vbap.posnr
        )
        else (
            select bstdk 
            from vbkd 
            where vbkd.vbeln = vbap.vbeln
        )
    end as g_customer_po_nbr,
    case 
        when vbap.posnr is not null then (
            select bsark 
            from vbkd 
            where vbkd.vbeln = vbap.vbeln 
              and vbkd.posnr = vbap.posnr
        )
        else (
            select bsark 
            from vbkd 
            where vbkd.vbeln = vbap.vbeln
        )
    end as g_customer_po_type,
    case 
        when coalesce(request_date.land1, request_date_posnr0.land1) not in ('US', 'CA') then 
            coalesce(request_date.vdatu, request_date_posnr0.vbdatu)
        when coalesce(request_date.land1, request_date_posnr0.land1) in ('US', 'CA') then 
            trim(vbep.request_dt)
        else vbep.edatu
    end as g_customer_request_dt_yyyymmdd,
    vbep.etenr as g_delivery_schedule_line_nbr,
    case 
        when vbap.pstyv in ('KBN', 'KEN', 'KAN', 'KRN') then 'yes'
        else 'no'
    end as g_flag_consignment_order,
    case 
        when vbap.uepos is not null and vbap.uepos != 0 then 'yes'
        else 'no'
    end as g_flag_has_parent,
    case 
        when mska.sobkz = 'E' 
          and (coalesce(mska.kalab, 0) + coalesce(mska.kains, 0) + coalesce(mska.kaspe, 0) + coalesce(mska.kavla, 0) + coalesce(mska.kavin, 0) + coalesce(mska.kavsp, 0)) > 0 
        then 'yes'
        else 'no'
    end as g_flag_inventory_fully_allocated,
    case 
        when vbap.posnr = any (
            select uepos 
            from vbap as vbap_inner 
            where vbap_inner.vbeln = vbap.vbeln
        ) then 'yes'
        else 'no'
    end as g_flag_is_parent,
    case 
        when exists (
            select 1 
            from knvv 
            where knvv.kunnr = vbak.kunnr 
              and knvv.vkorg = vbak.vkorg 
              and knvv.vtweg = vbak.vtweg 
              and knvv.spart = vbak.spart 
              and knvv.kdgrp in ('05', '06', '07')
        ) or exists (
            select 1 
            from kna1 
            where kna1.kunnr = vbak.kunnr 
              and kna1.ktokd in ('ZSUB', 'IC3P')
        ) then 'yes'
        else 'no'
    end as g_flag_is_transfer_order,
    case 
        when vbep.ettp = 'X' then 'yes'
        when vbep.ettp is null and vbep.knttp in ('M', 'X') then 'yes'
        when order_qty_primary_uom = 0 then 'no'
        else 'no'
    end as g_flag_material_transacted,
    case 
        when vbep.lifsp != '' then 'yes'
        when vbak.lifsk != '' then 'yes'
        when vbuk.cmgst in ('B', 'C') then 'yes'
        else 'no'
    end as g_flag_on_hold
from vbap
left join vbep on vbep.vbeln = vbap.vbeln and vbep.posnr = vbap.posnr
left join t001 on t001.bukrs = vbap.bukrs
left join mska on mska.vbeln = vbap.vbeln and mska.posnr = vbap.posnr
),
last_event_dt as (
    select
    concat('gbl', g_order_company_cd) as co_key,
    g_order_nbr,
    g_order_line_nbr,
    first_value(event_dt) over (
        partition by g_order_nbr, g_order_line_nbr
        order by event_dt desc
    ) as last_event_dt
from
    document_flow
where
    event_dt is not null
),
vbep_bmeng as (
    select 
    vbep.vbeln,
    vbep.posnr,
    sum(vbep.bmeng) as calculated_bmeng
from 
    vbep
group by 
    vbep.vbeln, 
    vbep.posnr
),
vbfa_dedup as (
    select 
    vbeln,
    posnn,
    row_number() over (
        partition by vbeln, posnn 
        order by erdat desc, erzet desc, vbelv desc, posnv desc
    ) as row_num
from 
    document_flow
where 
    vbelv is not null and posnv is not null
),
order_schedule as (
    select 
    vbep.etenr as g_delivery_schedule_line_nbr,
    vbep.mbdat as g_scheduled_ship_dt_yyyymmdd,
    sum(schedule_extract.order_qty) over (
        partition by schedule_extract.vbeln, schedule_extract.posnr 
        order by schedule_extract.mbdat
    ) as running_total_order_qty
from 
    schedule_extract
left join vbap 
    on schedule_extract.vbeln = vbap.vbeln 
    and schedule_extract.posnr = vbap.posnr
left join marm 
    on vbap.matnr = marm.matnr 
    and schedule_extract.vrkme = marm.meinh
left join mbew 
    on vbap.matnr = mbew.matnr 
    and vbap.werks = mbew.bwkey
),
order_shipment as (
    select
    vbelv,
    vbeln,
    posnv,
    posnn,
    vbtyp_n,
    sum(rfmng) over (partition by vbelv, posnv order by erdat rows between unbounded preceding and current row) as shipped_qty_primary_uom,
    first_value(erdat) over (partition by vbelv, posnv order by erdat desc) as last_actual_ship_dt_yyyymmdd
from
    vbfa_dedup
where
    vbtyp_n = 'J' and rfmng > 0
),
last_shipped_dt as (
    select 
    vbeln,
    posnr,
    first_value(ship_dt) over (
        partition by vbeln, posnr 
        order by ship_dt desc
    ) as g_last_actual_ship_dt_yyyymmdd
from 
    order_shipment
),
order_invoice as (
    select
    vbeln,
    posnr,
    first_value(erdat) over (
        partition by vbeln, posnr
        order by erdat desc
    ) as g_invoice_dt_yyyymmdd
from
    vbfa_dedup
),
tcurf_dedup as (
    select 
    tcurf.ffact as from_currency_factor,
    tcurf.tfact as to_currency_factor,
    tcurf.ukurs as exchange_rate,
    tcurf.kurst as rate_type,
    tcurf.datab as valid_from_date,
    tcurf.datbi as valid_to_date,
    row_number() over (
        partition by tcurf.ffact, tcurf.tfact, tcurf.kurst 
        order by tcurf.datbi desc, tcurf.datab desc
    ) as row_num
from 
    tcurf
where 
    tcurf.ffact is not null 
    and tcurf.tfact is not null 
    and tcurf.ukurs is not null
),
final_joined as (
    select
    vbep.vbeln as g_order_nbr,
    vbep.posnr as g_order_line_nbr,
    vbep.etenr as g_delivery_schedule_line_nbr,
    vbap.matnr as g_item_nbr,
    vbap.werks as g_plant_cd,
    vbap.meins as g_primary_uom_cd,
    vbap.vrkme as g_order_uom_cd,
    case 
        when vbep.vrkme = vbap.meins 
        then vbep.bmeng
        else (marm.umrez / marm.umren) * vbep.bmeng
    end as g_order_qty_primary_uom,
    case 
        when vbep_bmeng.calculated_bmeng is not null and vbep_bmeng.calculated_bmeng > 0
        then vbep.bmeng
        else vbep.wmeng
    end as g_order_qty_order_uom,
    vbep.mbdat as g_scheduled_ship_dt_yyyymmdd,
    vbep.edatu as g_promised_ship_dt_yyyymmdd,
    vbep.edatu as g_original_promised_ship_dt_yyyymmdd,
    vbep.edatu as g_original_customer_request_dt_yyyymmdd,
    vbep.mbdat - vbep.edatu as g_ship_to_delivery_days,
    vbfa.erdat as g_invoice_dt_yyyymmdd,
    vbap.abgru as g_cancel_dt_yyyymmdd,
    case 
        when vbap.abgru is not null 
        then vbep.bmeng
        else 0
    end as g_cancel_qty_primary_uom,
    case 
        when vbap.pstyv in ('KBN', 'KEN', 'KAN', 'KRN') 
        then 'yes' 
        else 'no'
    end as g_flag_consignment_order,
    case 
        when vbap.uepos is not null and vbap.uepos <> '0' 
        then 'yes' 
        else 'no'
    end as g_flag_has_parent,
    case 
        when vbap.posnr = vbap.uepos 
        then 'yes' 
        else 'no'
    end as g_flag_is_parent,
    case 
        when vbak.kunnr in (select kna1.kunnr from kna1 where kna1.ktokd in ('ZSUB', 'IC3P')) 
        or (vbak.kunnr, vbak.vkorg, vbak.vtweg, vbak.spart) in (select knvv.kunnr, knvv.vkorg, knvv.vtweg, knvv.spart from knvv where knvv.kdgrp in ('05', '06', '07'))
        then 'yes' 
        else 'no'
    end as g_flag_is_transfer_order,
    case 
        when tvap.bedsd = 'X' or tvap.knttp in ('M', 'X') 
        then 'yes' 
        else 'no'
    end as g_flag_material_transacted,
    case 
        when vbep.lifsp is not null 
        then 'yes' 
        when vbak.lifsk is not null 
        then 'yes' 
        when vbuk.cmgst in ('B', 'C') 
        then 'yes' 
        else 'no'
    end as g_flag_on_hold,
    case 
        when vbak.autlf = 'X' 
        or cancel_qty_primary_uom = order_qty_primary_uom 
        or open_qty_primary_uom <= 0 
        then 'no' 
        else 'yes'
    end as g_flag_open_to_ship,
    case 
        when vbak.vbtyp in ('H', 'T') 
        then 'yes' 
        else 'no'
    end as g_flag_return,
    case 
        when order_qty_primary_uom = 0 
        or vbak.vbtyp in ('A', 'B', 'D') 
        or tvap.prsfd = 'X' 
        then 'no' 
        else 'yes'
    end as g_flag_revenue_recognition,
    vbap.pstyv as g_order_category,
    t001k.bukrs as g_order_company_cd,
    case 
        when trim(vbap.waerk) = 'RMB' 
        then 'CNY' 
        else trim(vbap.waerk)
    end as g_order_currency_cd,
    vbak.aedat as g_order_dt_yyyymmdd,
    case 
        when trim(mbew.vprsv) = 'V' 
        then round(if(t001.waers in ('KRW', 'JPY'), mbew.verpr * 100, mbew.verpr) / currency_factor, 2)
        when trim(mbew.vprsv) = 'S' 
        then round(if(t001.waers in ('KRW', 'JPY'), mbew.stprs * 100, mbew.stprs) / currency_factor, 2)
    end as g_unit_cost_company_currency_primary_uom,
    case 
        when trim(vbap.waerk) = trim(t001.waers) 
        then if(trim(vbap.waerk) = 'JPY', puom.price_uom * 100 * coalesce(vbkd.kursk, vbkd_derived.kursk), puom.price_uom * coalesce(vbkd.kursk, vbkd_derived.kursk)) * (tcurf.tfact / tcurf.ffact)
        else (puom.price_uom * coalesce(vbkd.kursk, vbkd_derived.kursk)) * (tcurf.tfact / tcurf.ffact)
    end as g_unit_price_company_currency_primary_uom,
    case 
        when vbep.vrkme = vbap.meins 
        then vbep.bmeng
        else (marm.umrez / marm.umren) * vbep.bmeng
    end as g_unit_price_order_currency_primary_uom,
    concat_ws('|', 'gbl', g_order_company_cd, g_order_type, g_order_nbr) as sls_ord_key,
    concat_ws('|', 'gbl', g_order_company_cd, g_order_type, g_order_nbr, g_order_line_nbr, g_delivery_schedule_line_nbr) as sls_ord_sched_key,
    concat_ws('|', 'gbl', g_item_nbr) as prod_key,
    concat_ws('|', 'gbl', g_plant_cd) as plant_key,
    concat_ws('|', 'gbl', g_item_nbr, g_plant_cd) as prod_plant_key,
    cast(null as string) as flag_is_blanket
from
    vbep
left join vbap on vbep.vbeln = vbap.vbeln and vbep.posnr = vbap.posnr
left join marm on vbap.matnr = marm.matnr and vbep.vrkme = marm.meinh
left join mbew on vbap.matnr = mbew.matnr and vbap.werks = mbew.bwkey
left join vbfa on vbep.vbeln = vbfa.vbelv and vbep.posnr = vbfa.posnv
left join t001k on vbap.werks = t001k.bwkey
left join t001 on t001k.bukrs = t001.bukrs
left join tcurf on vbap.waerk = tcurf.ffact and t001.waers = tcurf.tfact
left join vbkd on vbep.vbeln = vbkd.vbeln and vbep.posnr = vbkd.posnr
left join vbkd_derived on vbep.vbeln = vbkd_derived.vbeln and vbep.posnr = vbkd_derived.posnr
left join puom on vbep.vbeln = puom.vbeln and vbep.posnr = puom.posnr
left join tvap on vbap.pstyv = tvap.pstyv
left join vbak on vbep.vbeln = vbak.vbeln
left join vbuk on vbep.vbeln = vbuk.vbeln
),
final_joined_with_flags as (
    select
    g_order_nbr,
    g_order_line_nbr,
    g_delivery_schedule_line_nbr,
    g_order_qty_primary_uom,
    g_shipped_qty_primary_uom,
    g_invoice_dt_yyyymmdd,
    g_cancel_qty_primary_uom,
    g_cancel_dt_yyyymmdd,
    g_open_qty_primary_uom,
    case
        when g_cancel_qty_primary_uom = g_order_qty_primary_uom then 'no'
        when g_open_qty_primary_uom > 0 then 'yes'
        else 'no'
    end as flag_open_to_ship,
    case
        when g_shipped_qty_primary_uom > 0 or g_invoice_dt_yyyymmdd is not null then 'yes'
        else 'no'
    end as flag_material_transacted,
    case
        when g_cancel_qty_primary_uom = g_order_qty_primary_uom then 'no'
        when g_open_qty_primary_uom > 0 then 'yes'
        else 'no'
    end as flag_open,
    case
        when g_shipped_qty_primary_uom > 0 or g_invoice_dt_yyyymmdd is not null then 'yes'
        else 'no'
    end as flag_transacted
from
    final_joined
)
select
    concat_ws('|', 'gbl', g_order_company_cd) as co_key,
    g_allocated_qty_primary_uom,
    g_availability_dt_yyyymmdd,
    g_bill_to_customer_nbr,
    g_cancel_dt_yyyymmdd,
    g_cancel_qty_primary_uom,
    g_company_currency_cd,
    g_customer_item_nbr,
    g_customer_po_line_nbr,
    g_customer_po_nbr,
    g_customer_po_type,
    g_customer_request_dt_yyyymmdd,
    g_delivery_schedule_line_nbr,
    g_flag_consignment_order,
    g_flag_has_parent,
    g_flag_inventory_fully_allocated,
    g_flag_is_parent,
    g_flag_is_transfer_order,
    g_flag_material_transacted,
    g_flag_on_hold,
    g_flag_open_to_ship,
    g_flag_return,
    g_flag_revenue_recognition,
    g_inco_terms,
    g_invoice_dt_yyyymmdd,
    g_item_nbr,
    g_last_actual_ship_dt_yyyymmdd,
    g_line_status_cd,
    g_open_qty_primary_uom,
    g_order_category,
    g_order_company_cd,
    g_order_currency_cd,
    g_order_dt_yyyymmdd,
    g_order_line_nbr,
    g_order_nbr,
    g_order_qty_order_uom,
    g_order_qty_primary_uom,
    g_order_type,
    g_order_uom_cd,
    g_original_customer_request_dt_yyyymmdd,
    g_original_promised_ship_dt_yyyymmdd,
    g_parent_order_line_nbr,
    g_payment_terms,
    g_plant_cd,
    g_primary_uom_cd,
    g_promised_ship_dt_yyyymmdd,
    g_scheduled_ship_dt_yyyymmdd,
    g_ship_to_customer_nbr,
    g_ship_to_delivery_days,
    g_shipment_mode,
    g_shipped_qty_primary_uom,
    'gbl' as g_source_system_cd,
    g_unit_cost_company_currency_primary_uom,
    g_unit_price_company_currency_primary_uom,
    g_unit_price_order_currency_primary_uom,
    concat_ws('|', 'gbl', g_plant_cd) as plant_key,
    concat_ws('|', 'gbl', g_item_nbr) as prod_key,
    concat_ws('|', 'gbl', g_item_nbr, g_plant_cd) as prod_plant_key,
    concat_ws('|', 'gbl', g_order_company_cd, g_order_type, g_order_nbr) as sls_ord_key,
    concat_ws('|', 'gbl', g_order_company_cd, g_order_type, g_order_nbr, g_order_line_nbr, g_delivery_schedule_line_nbr) as sls_ord_sched_key,
    flag_is_blanket
from final_joined_with_flags;