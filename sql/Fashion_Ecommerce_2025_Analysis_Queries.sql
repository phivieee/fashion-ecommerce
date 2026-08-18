-- Fashion E-Commerce Customer Behaviour 2025
-- Portfolio Analysis Query Pack
-- PostgreSQL / DBeaver

-- 0) ROW COUNT VALIDATION
SELECT 'dim_customer' AS table_name, COUNT(*) AS rows FROM dim_customer
UNION ALL SELECT 'dim_product', COUNT(*) FROM dim_product
UNION ALL SELECT 'dim_campaign', COUNT(*) FROM dim_campaign
UNION ALL SELECT 'fact_orders', COUNT(*) FROM fact_orders
UNION ALL SELECT 'fact_order_items', COUNT(*) FROM fact_order_items
UNION ALL SELECT 'fact_customer_events', COUNT(*) FROM fact_customer_events;


-- ============================================================

-- 8.1 MONTHLY SALES TREND

SELECT
    DATE_TRUNC('month', order_datetime)::date AS month,
    COUNT(*) AS completed_orders,
    COUNT(DISTINCT customer_id) AS unique_customers,
    SUM(recognized_revenue_idr) AS revenue_idr,
    ROUND(AVG(net_sales_idr), 0) AS aov_idr
FROM fact_orders
WHERE order_status = 'Completed'
GROUP BY 1
ORDER BY 1;


-- ============================================================

-- 8.2 NEW YEAR EVENT PERFORMANCE

SELECT
    CASE
        WHEN order_datetime::date BETWEEN DATE '2025-01-01' AND DATE '2025-01-12'
            THEN 'New Year Event'
        ELSE 'Other Days'
    END AS period,
    COUNT(*) FILTER (WHERE order_status = 'Completed') AS completed_orders,
    COUNT(DISTINCT customer_id) FILTER (WHERE order_status = 'Completed') AS customers,
    SUM(recognized_revenue_idr) AS revenue_idr,
    ROUND(AVG(net_sales_idr) FILTER (WHERE order_status = 'Completed'), 0) AS aov_idr
FROM fact_orders
GROUP BY 1;


-- ============================================================

-- 8.3 REVENUE PER DAY

WITH daily AS (
    SELECT
        order_datetime::date AS order_date,
        CASE WHEN order_datetime::date BETWEEN DATE '2025-01-01' AND DATE '2025-01-12'
             THEN 'New Year Event' ELSE 'Other Days' END AS period,
        COUNT(*) FILTER (WHERE order_status = 'Completed') AS orders,
        SUM(recognized_revenue_idr) AS revenue
    FROM fact_orders
    GROUP BY 1,2
)
SELECT
    period,
    ROUND(AVG(orders), 2) AS avg_orders_per_day,
    ROUND(AVG(revenue), 0) AS avg_revenue_per_day
FROM daily
GROUP BY period;


-- ============================================================

-- 8.4 CUSTOMER FUNNEL

SELECT
    COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN session_id END) AS page_view_sessions,
    COUNT(DISTINCT CASE WHEN event_type = 'product_view' THEN session_id END) AS product_view_sessions,
    COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN session_id END) AS add_to_cart_sessions,
    COUNT(DISTINCT CASE WHEN event_type = 'begin_checkout' THEN session_id END) AS checkout_sessions,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN session_id END) AS purchase_sessions
FROM fact_customer_events;


-- ============================================================

-- 8.5 FUNNEL CONVERSION BY TRAFFIC SOURCE

WITH source_funnel AS (
    SELECT
        traffic_source,
        COUNT(DISTINCT session_id) AS sessions,
        COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN session_id END) AS cart_sessions,
        COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN session_id END) AS purchase_sessions
    FROM fact_customer_events
    GROUP BY traffic_source
)
SELECT
    traffic_source,
    sessions,
    cart_sessions,
    purchase_sessions,
    ROUND(100.0 * purchase_sessions / NULLIF(sessions, 0), 2) AS session_conversion_pct
FROM source_funnel
ORDER BY session_conversion_pct DESC;


-- ============================================================

-- 8.6 PEAK SHOPPING HOUR

SELECT
    EXTRACT(HOUR FROM order_datetime)::int AS order_hour,
    COUNT(*) AS completed_orders,
    SUM(recognized_revenue_idr) AS revenue_idr
FROM fact_orders
WHERE order_status = 'Completed'
GROUP BY 1
ORDER BY 1;


-- ============================================================

-- 8.7 TOP CATEGORY DURING NEW YEAR

SELECT
    p.category,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.line_net_sales_idr) AS line_sales_idr
FROM fact_order_items oi
JOIN fact_orders o ON oi.order_id = o.order_id
JOIN dim_product p ON oi.product_id = p.product_id
WHERE o.order_status = 'Completed'
  AND o.order_datetime::date BETWEEN DATE '2025-01-01' AND DATE '2025-01-12'
GROUP BY p.category
ORDER BY line_sales_idr DESC;


-- ============================================================

-- 8.8 TOP 10 PRODUCTS

SELECT
    p.product_name,
    p.category,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.line_net_sales_idr) AS sales_idr
FROM fact_order_items oi
JOIN fact_orders o ON oi.order_id = o.order_id
JOIN dim_product p ON oi.product_id = p.product_id
WHERE o.order_status = 'Completed'
  AND o.order_datetime::date BETWEEN DATE '2025-01-01' AND DATE '2025-01-12'
GROUP BY p.product_name, p.category
ORDER BY sales_idr DESC
LIMIT 10;


-- ============================================================

-- 8.9 MEMBERSHIP SEGMENT

SELECT
    c.membership_level,
    COUNT(DISTINCT o.customer_id) AS customers,
    COUNT(*) AS completed_orders,
    SUM(o.recognized_revenue_idr) AS revenue_idr,
    ROUND(AVG(o.net_sales_idr), 0) AS aov_idr
FROM fact_orders o
JOIN dim_customer c ON o.customer_id = c.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.membership_level
ORDER BY revenue_idr DESC;


-- ============================================================

-- NEW VS EXISTING CUSTOMER

WITH first_purchase AS (
    SELECT
        customer_id,
        MIN(order_datetime::date) FILTER (WHERE order_status = 'Completed') AS first_purchase_date
    FROM fact_orders
    GROUP BY customer_id
)
SELECT
    CASE
        WHEN fp.first_purchase_date BETWEEN DATE '2025-01-01' AND DATE '2025-01-12' THEN 'New Customer'
        ELSE 'Existing Customer'
    END AS customer_type,
    COUNT(DISTINCT o.customer_id) AS customers,
    COUNT(*) AS orders,
    SUM(o.recognized_revenue_idr) AS revenue_idr
FROM fact_orders o
JOIN first_purchase fp ON o.customer_id = fp.customer_id
WHERE o.order_status = 'Completed'
  AND o.order_datetime::date BETWEEN DATE '2025-01-01' AND DATE '2025-01-12'
GROUP BY 1;


-- ============================================================

-- REPEAT PURCHASE RATE

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(*) AS completed_orders
    FROM fact_orders
    WHERE order_status = 'Completed'
    GROUP BY customer_id
)
SELECT
    COUNT(*) AS purchasing_customers,
    COUNT(*) FILTER (WHERE completed_orders >= 2) AS repeat_customers,
    ROUND(100.0 * COUNT(*) FILTER (WHERE completed_orders >= 2) / NULLIF(COUNT(*),0), 2) AS repeat_customer_pct
FROM customer_orders;


-- ============================================================

-- TOP PRODUCT PER CATEGORY

WITH product_sales AS (
    SELECT
        p.category,
        p.product_name,
        SUM(oi.line_net_sales_idr) AS sales_idr
    FROM fact_order_items oi
    JOIN fact_orders o ON oi.order_id = o.order_id
    JOIN dim_product p ON oi.product_id = p.product_id
    WHERE o.order_status = 'Completed'
    GROUP BY p.category, p.product_name
), ranked AS (
    SELECT
        *,
        DENSE_RANK() OVER (PARTITION BY category ORDER BY sales_idr DESC) AS category_rank
    FROM product_sales
)
SELECT *
FROM ranked
WHERE category_rank <= 3
ORDER BY category, category_rank;


-- ============================================================

-- RFM SEGMENTATION

WITH snapshot AS (
    SELECT DATE '2026-01-01' AS snapshot_date
), customer_metrics AS (
    SELECT
        customer_id,
        (SELECT snapshot_date FROM snapshot) - MAX(order_datetime::date) AS recency_days,
        COUNT(*) AS frequency,
        SUM(recognized_revenue_idr) AS monetary
    FROM fact_orders
    WHERE order_status = 'Completed'
    GROUP BY customer_id
), scored AS (
    SELECT
        *,
        6 - NTILE(5) OVER (ORDER BY recency_days ASC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
        NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
    FROM customer_metrics
)
SELECT
    customer_id, recency_days, frequency, monetary,
    r_score, f_score, m_score,
    CASE
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
        WHEN r_score >= 3 AND f_score >= 3 THEN 'Loyal'
        WHEN r_score >= 4 AND f_score <= 2 THEN 'Promising'
        WHEN r_score <= 2 AND f_score >= 3 THEN 'At Risk'
        ELSE 'Regular'
    END AS rfm_segment
FROM scored
ORDER BY monetary DESC;


-- ============================================================

-- CREATE VW_SALES_LINE

CREATE OR REPLACE VIEW vw_sales_line AS
SELECT
    o.order_id,
    o.order_datetime,
    o.customer_id,
    c.gender,
    c.age_group,
    c.city AS customer_city,
    c.province AS customer_province,
    c.membership_level,
    o.campaign_id,
    ca.campaign_name,
    o.channel,
    o.payment_method,
    o.order_status,
    oi.product_id,
    p.product_name,
    p.category,
    p.subcategory,
    p.brand,
    oi.quantity,
    oi.unit_price_idr,
    oi.discount_pct,
    oi.line_net_sales_idr,
    oi.line_cost_idr,
    CASE WHEN o.order_status = 'Completed' THEN oi.line_net_sales_idr ELSE 0 END AS recognized_line_sales_idr,
    CASE WHEN o.order_status = 'Completed' THEN oi.line_net_sales_idr - oi.line_cost_idr ELSE 0 END AS gross_profit_idr
FROM fact_orders o
JOIN fact_order_items oi ON o.order_id = oi.order_id
JOIN dim_product p ON oi.product_id = p.product_id
JOIN dim_customer c ON o.customer_id = c.customer_id
JOIN dim_campaign ca ON o.campaign_id = ca.campaign_id;


-- ============================================================

-- CREATE VW_CUSTOMER_SUMMARY

CREATE OR REPLACE VIEW vw_customer_summary AS
SELECT
    c.customer_id,
    c.gender,
    c.age,
    c.age_group,
    c.city,
    c.province,
    c.membership_level,
    MIN(o.order_datetime::date) FILTER (WHERE o.order_status = 'Completed') AS first_purchase_date,
    MAX(o.order_datetime::date) FILTER (WHERE o.order_status = 'Completed') AS last_purchase_date,
    COUNT(*) FILTER (WHERE o.order_status = 'Completed') AS completed_orders,
    SUM(o.recognized_revenue_idr) AS lifetime_revenue_idr,
    ROUND(AVG(o.net_sales_idr) FILTER (WHERE o.order_status = 'Completed'), 0) AS avg_order_value_idr
FROM dim_customer c
LEFT JOIN fact_orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.gender, c.age, c.age_group, c.city, c.province, c.membership_level;


-- ============================================================

-- CREATE VW_SESSION_FUNNEL

CREATE OR REPLACE VIEW vw_session_funnel AS
SELECT
    session_id,
    MAX(customer_id) AS customer_id,
    MIN(event_timestamp) AS session_start,
    MAX(device) AS device,
    MAX(traffic_source) AS traffic_source,
    MAX(campaign_id) AS campaign_id,
    MAX(CASE WHEN event_type = 'page_view' THEN 1 ELSE 0 END) AS reached_page_view,
    MAX(CASE WHEN event_type = 'product_view' THEN 1 ELSE 0 END) AS reached_product_view,
    MAX(CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END) AS reached_cart,
    MAX(CASE WHEN event_type = 'begin_checkout' THEN 1 ELSE 0 END) AS reached_checkout,
    MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS reached_purchase
FROM fact_customer_events
GROUP BY session_id;
