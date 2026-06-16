-- Query: fetch_active_customers_with_completed_orders
-- Purpose: Fetch active customers who have completed orders, along with their order details and associated product information.
-- Query Type: SELECT

SELECT 
    cm.customer_id AS cust_id,
    cm.customer_name AS cust_nm,
    cm.email,
    cm.status AS active_flg,
    cm.city,
    cm.country,
    cm.created_date,
    oh.order_id,
    oh.order_number,
    oh.order_date,
    oh.currency AS curncy_cd,
    oh.total_amount,
    oi.order_item_id,
    oi.product_id,
    oi.quantity,
    oi.unit_price,
    oi.discount,
    oi.tax_amount,
    oi.line_total,
    pm.product_name,
    pm.category,
    pm.brand,
    pm.unit_cost
FROM 
    customer_master cm
INNER JOIN 
    order_header oh ON cm.customer_id = oh.customer_id
INNER JOIN 
    order_item oi ON oh.order_id = oi.order_id
INNER JOIN 
    product_master pm ON oi.product_id = pm.product_id
WHERE 
    cm.customer_name IS NOT NULL
    AND cm.status = 'ACTIVE'
    AND oh.order_status = 'COMPLETED'
    AND oi.quantity > 0
ORDER BY 
    cm.customer_name, oh.order_date DESC;