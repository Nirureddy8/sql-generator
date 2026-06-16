-- Query: fetch_customer_product_order_invoice
-- Purpose: Fetch data from customer, product, order, and invoice tables with necessary joins and filters applied.
-- Query Type: SELECT

SELECT 
    cm.customer_id AS customer_key,
    cm.customer_name,
    cm.email,
    cm.status AS customer_status,
    cm.city,
    cm.country AS customer_country,
    oh.order_id AS order_key,
    oh.order_number,
    oh.order_date,
    oh.currency,
    oh.total_amount AS order_amount,
    oi.order_item_id,
    oi.product_id AS product_key,
    pm.product_name,
    pm.category AS product_category,
    pm.brand AS product_brand,
    oi.quantity,
    oi.unit_price,
    oi.discount AS discount_amount,
    oi.tax_amount,
    oi.line_total,
    inv.invoice_id AS invoice_key,
    inv.invoice_number,
    inv.invoice_date,
    inv.invoice_amount
FROM 
    customer_master cm
INNER JOIN 
    order_header oh ON oh.customer_id = cm.customer_id
INNER JOIN 
    order_item oi ON oi.order_id = oh.order_id
INNER JOIN 
    product_master pm ON pm.product_id = oi.product_id
INNER JOIN 
    invoice inv ON inv.order_id = oh.order_id
WHERE 
    cm.status = 'ACTIVE'
    AND cm.customer_name IS NOT NULL
    AND oh.order_status = 'COMPLETED'
    AND oi.quantity > 0;