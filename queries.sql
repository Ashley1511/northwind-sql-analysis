-- 1. Top 10 Customers by Total Revenue
SELECT 
    c.customer_id,
    c.company_name,
    ROUND(SUM(od.unit_price * od.quantity), 2) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
GROUP BY c.customer_id, c.company_name
ORDER BY total_revenue DESC
LIMIT 10;

-- 2. Most Frequently Ordered Products
SELECT 
    p.product_name,
    COUNT(*) AS times_ordered,
    SUM(od.quantity) AS total_quantity
FROM products p
JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_name
ORDER BY total_quantity DESC
LIMIT 10;

-- 3. Monthly Order Count Trend
SELECT 
    DATE_TRUNC('month', order_date) AS month,
    COUNT(*) AS order_count
FROM orders
GROUP BY month
ORDER BY month;

-- 4. Orders Per Employee
SELECT 
    e.first_name || ' ' || e.last_name AS employee_name,
    COUNT(o.order_id) AS total_orders
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
GROUP BY employee_name
ORDER BY total_orders DESC;

-- 5. Average Order Value (AOV) by Customer
SELECT 
    c.customer_id,
    c.company_name,
    ROUND(AVG(order_total), 2) AS avg_order_value
FROM customers c
JOIN (
    SELECT 
        o.order_id,
        o.customer_id,
        SUM(od.unit_price * od.quantity) AS order_total
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY o.order_id, o.customer_id
) AS order_totals ON c.customer_id = order_totals.customer_id
GROUP BY c.customer_id, c.company_name
ORDER BY avg_order_value DESC
LIMIT 10;

-- 6. Orders with Highest Revenue
SELECT 
    o.order_id,
    c.company_name,
    ROUND(SUM(od.unit_price * od.quantity), 2) AS total
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY o.order_id, c.company_name
ORDER BY total DESC
LIMIT 10;

-- 7. Top-Selling Products by Revenue
SELECT 
    p.product_name,
    ROUND(SUM(od.unit_price * od.quantity), 2) AS revenue_generated
FROM products p
JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_name
ORDER BY revenue_generated DESC
LIMIT 10;

-- 8. First Order Date per Customer (Window Function)
SELECT 
    c.customer_id,
    c.company_name,
    MIN(o.order_date) AS first_order
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.company_name
ORDER BY first_order;

-- 9. Running Total Revenue Over Time (Window Function)
SELECT 
    DATE_TRUNC('month', o.order_date) AS month,
    ROUND(SUM(od.unit_price * od.quantity), 2) AS monthly_revenue,
    ROUND(SUM(SUM(od.unit_price * od.quantity)) OVER (ORDER BY DATE_TRUNC('month', o.order_date)), 2) AS running_total
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY month
ORDER BY month;

-- 10. Customer Lifetime Revenue (CTE)
WITH customer_revenue AS (
    SELECT 
        c.customer_id,
        c.company_name,
        ROUND(SUM(od.unit_price * od.quantity), 2) AS total_revenue
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY c.customer_id, c.company_name
)
SELECT *
FROM customer_revenue
ORDER BY total_revenue DESC
LIMIT 15;
