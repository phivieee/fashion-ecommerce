# Fashion E-Commerce Customer Behaviour Dashboard 2025

## Project Overview

This project analyses fashion e-commerce sales and customer behaviour throughout 2025 using transactional, customer, product, campaign, and behavioural event data. SQL is used to prepare and analyse the data, while Power BI is used to present the results in an interactive dashboard.

The analysis focuses on sales performance, campaign effectiveness, customer conversion, product performance, membership behaviour, and repeat purchasing patterns.

## Objective

- Track overall e-commerce sales and revenue performance.
- Analyse monthly order and revenue trends.
- Measure the performance of the **New Year Fashion Reset** campaign.
- Evaluate the customer journey from page view to purchase.
- Compare conversion performance across traffic sources.
- Identify top-performing categories and products.
- Analyse membership segments and repeat purchase behaviour.
- Prepare dashboard-ready customer, sales, and session-level data for Power BI.

## Tools Used

**Microsoft Excel / CSV**  
Used as the source format for the raw customer, product, campaign, order, order-item, and behavioural event datasets.

**SQL**  
Used for data cleaning, validation, transformation, joins, aggregations, KPI calculation, and analytical queries.

**Power BI**  
Used for data modelling and interactive visualisation of sales, customer behaviour, campaign performance, conversion funnel, and product performance.

## Workflow Process

### Raw Data
The project starts with Excel and CSV datasets containing customer profiles, product information, campaigns, orders, order items, and customer behavioural events for 2025.

### Data Cleaning & Validation
The datasets are loaded into the SQL database using the defined schema. Data types, primary and foreign key relationships, and row counts are checked before analysis to ensure the tables are structured correctly.

### Transformation
SQL is used to join dimension and fact tables, calculate business metrics, and prepare analysis-ready datasets. Three analytical views are created: `vw_sales_line`, `vw_customer_summary`, and `vw_session_funnel`.

### Analysis
SQL analysis is performed to evaluate monthly sales, campaign performance, revenue per day, customer funnel conversion, traffic-source conversion, peak shopping hours, product and category performance, membership behaviour, new versus existing customers, repeat purchase rate, and RFM segments.

### Visualization
The prepared data is connected to Power BI and presented through an interactive dashboard containing KPI cards, sales trends, campaign performance, customer funnel, traffic-source conversion, product preferences, and customer behaviour insights.

## Dataset

The project uses a synthetic fashion e-commerce dataset covering **1 January 2025 to 31 December 2025**.

| Dataset | Rows | Description |
|---|---:|---|
| `dim_customer` | 1,000 | Customer profile, demographics, membership, and preferred channel |
| `dim_product` | 35 | Product, category, brand, pricing, cost, and margin information |
| `dim_campaign` | 7 | Marketing campaign period, type, discount, and channel information |
| `fact_orders` | 5,000 | Order-level transactions, status, sales, discounts, and recognised revenue |
| `fact_order_items` | 8,700 | Product-level details for each order |
| `fact_customer_events` | 10,000 | Session and customer behavioural events across the purchase journey |

The main campaign analysed is **New Year Fashion Reset**, which ran from **1 January to 12 January 2025**.

## Insights

- **4,445 of 5,000 orders** were completed, generating approximately **IDR 3.57 billion** in recognised revenue.
- The average order value for completed orders was approximately **IDR 795.8 thousand**.
- During the **New Year Fashion Reset** campaign, completed orders averaged **37.25 orders per day**, compared with approximately **11.33 orders per day** outside the campaign period.
- Average recognised revenue during the campaign reached approximately **IDR 26.69 million per day**, compared with approximately **IDR 9.19 million per day** on other days.
- The behavioural funnel recorded **3,000 page-view sessions**, **1,739 add-to-cart sessions**, **1,142 checkout sessions**, and **800 purchase sessions**.
- **Instagram** had the highest session conversion rate among tracked traffic sources at approximately **28.97%**.
- **Outerwear** generated the highest category sales during the New Year campaign at approximately **IDR 70.25 million**.
- **Chunky Sneakers** were the highest-selling product during the campaign, generating approximately **IDR 19.83 million** in sales.
- Approximately **81.66%** of purchasing customers placed at least two completed orders during the year.
