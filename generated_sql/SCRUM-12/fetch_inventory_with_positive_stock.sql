-- Query: fetch_inventory_with_positive_stock
-- Purpose: Fetch details of products with positive stock quantities from the inventory.
-- Query Type: SELECT

SELECT 
    inv.inventory_id,
    inv.product_id,
    inv.stock_qty,
    pm.product_name,
    pm.category,
    pm.brand,
    pm.unit_cost
FROM 
    inventory inv
INNER JOIN 
    product_master pm ON inv.product_id = pm.product_id
WHERE 
    inv.stock_qty > 0
ORDER BY 
    pm.product_name;