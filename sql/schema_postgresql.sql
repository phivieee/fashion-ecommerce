-- Fashion E-Commerce Customer Behaviour 2025
-- Synthetic portfolio dataset
CREATE DATABASE fashion_ecommerce_2025;
SELECT current_database();
CREATE TABLE dim_customer (
    customer_id VARCHAR(10) PRIMARY KEY,
    gender VARCHAR(10),
    age INT,
    age_group VARCHAR(10),
    city VARCHAR(50),
    province VARCHAR(50),
    registration_date DATE,
    membership_level VARCHAR(20),
    preferred_channel VARCHAR(20)
);

CREATE TABLE dim_product (
    product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(30),
    subcategory VARCHAR(40),
    target_gender VARCHAR(10),
    brand VARCHAR(50),
    available_sizes VARCHAR(50),
    normal_price_idr NUMERIC(14,2),
    unit_cost_idr NUMERIC(14,2),
    gross_margin_rate NUMERIC(8,4)
);

CREATE TABLE dim_campaign (
    campaign_id VARCHAR(10) PRIMARY KEY,
    campaign_name VARCHAR(100),
    start_date DATE,
    end_date DATE,
    campaign_type VARCHAR(30),
    headline_discount_pct NUMERIC(8,2),
    campaign_channel VARCHAR(100)
);

CREATE TABLE fact_orders (
    order_id VARCHAR(12) PRIMARY KEY,
    order_datetime TIMESTAMP,
    customer_id VARCHAR(10) REFERENCES dim_customer(customer_id),
    campaign_id VARCHAR(10) REFERENCES dim_campaign(campaign_id),
    channel VARCHAR(20),
    payment_method VARCHAR(30),
    order_status VARCHAR(20),
    city VARCHAR(50),
    province VARCHAR(50),
    total_items INT,
    gross_sales_idr NUMERIC(14,2),
    discount_amount_idr NUMERIC(14,2),
    shipping_cost_idr NUMERIC(14,2),
    net_sales_idr NUMERIC(14,2),
    recognized_revenue_idr NUMERIC(14,2),
    voucher_code VARCHAR(30)
);

CREATE TABLE fact_order_items (
    order_id VARCHAR(12) REFERENCES fact_orders(order_id),
    line_number INT,
    product_id VARCHAR(10) REFERENCES dim_product(product_id),
    product_name VARCHAR(100),
    category VARCHAR(30),
    subcategory VARCHAR(40),
    quantity INT,
    unit_price_idr NUMERIC(14,2),
    discount_pct NUMERIC(8,2),
    discount_amount_idr NUMERIC(14,2),
    line_net_sales_idr NUMERIC(14,2),
    line_cost_idr NUMERIC(14,2),
    PRIMARY KEY(order_id, line_number)
);

CREATE TABLE fact_customer_events (
    event_id VARCHAR(12) PRIMARY KEY,
    session_id VARCHAR(12),
    customer_id VARCHAR(10),
    event_timestamp TIMESTAMP,
    event_type VARCHAR(30),
    product_id VARCHAR(10),
    order_id VARCHAR(12),
    device VARCHAR(20),
    traffic_source VARCHAR(30),
    campaign_id VARCHAR(10) REFERENCES dim_campaign(campaign_id),
    page_name VARCHAR(50)
);

CREATE INDEX idx_orders_datetime ON fact_orders(order_datetime);
CREATE INDEX idx_orders_customer ON fact_orders(customer_id);
CREATE INDEX idx_orders_campaign ON fact_orders(campaign_id);
CREATE INDEX idx_order_items_product ON fact_order_items(product_id);
CREATE INDEX idx_events_session ON fact_customer_events(session_id);
CREATE INDEX idx_events_timestamp ON fact_customer_events(event_timestamp);
CREATE INDEX idx_events_customer ON fact_customer_events(customer_id);
