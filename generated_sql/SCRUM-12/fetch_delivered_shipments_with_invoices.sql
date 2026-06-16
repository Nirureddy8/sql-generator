-- Query: fetch_delivered_shipments_with_invoices
-- Purpose: Fetch details of delivered shipments along with their associated invoices and payment information.
-- Query Type: SELECT

SELECT 
    sh.shipment_id,
    sh.order_id,
    sh.shipment_date,
    sh.carrier,
    sh.tracking_number,
    sh.delivery_status,
    inv.invoice_id,
    inv.invoice_number,
    inv.invoice_date,
    inv.invoice_amount,
    pay.payment_id,
    pay.payment_date,
    pay.payment_method,
    pay.payment_amount
FROM 
    shipment sh
INNER JOIN 
    order_header oh ON sh.order_id = oh.order_id
INNER JOIN 
    invoice inv ON oh.order_id = inv.order_id
INNER JOIN 
    payment pay ON inv.invoice_id = pay.invoice_id
WHERE 
    sh.delivery_status = 'DELIVERED'
ORDER BY 
    sh.shipment_date DESC;