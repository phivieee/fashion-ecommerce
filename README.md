# Fashion E-Commerce Customer Behaviour Dashboard 2025

## Project Overview

This project analyses fashion e-commerce sales and customer behaviour throughout 2025 using transactional, customer, product, campaign, and behavioural event data. SQL is used to prepare and analyse the data, while Power BI is used to present the results in an interactive dashboard.

The analysis focuses on sales performance, monthly revenue trends, campaign analysis, customer and product performance, membership behaviour, customer demographics, and high-value customer identification.

## Objective

- Track overall e-commerce sales, orders, quantity, and revenue performance.
- Analyse monthly order and revenue trends to identify seasonal and peak-performing periods.
- Evaluate the performance of marketing campaigns and compare campaign outcomes when campaign-level metrics are available.
- Analyse customer behaviour and demographics, including age group, gender, and customer value.
- Identify top-performing categories, products, and brands based on revenue and sales volume.
- Analyse membership-level revenue and average customer spending.
- Identify high-value customers and opportunities for customer retention and targeting.
- Prepare dashboard-ready customer, sales, product, campaign, and behavioural data for Power BI.

## Tools Used

**Microsoft Excel / CSV**  
Used as the source format for the raw customer, product, campaign, order, order-item, and behavioural event datasets.

**SQL**  
Used for data cleaning, validation, transformation, joins, aggregations, KPI calculation, and analytical queries.

**Power BI**  
Used for data modelling and interactive visualisation of sales, customer, product, category, brand, membership, and campaign-related analysis.

## Workflow Process

### Raw Data
The project starts with Excel and CSV datasets containing customer profiles, product information, campaigns, orders, order items, and customer behavioural events for 2025.

### Data Cleaning & Validation
The datasets are loaded into the SQL database using the defined schema. Data types, primary and foreign key relationships, and row counts are checked before analysis to ensure the tables are structured correctly.

### Transformation
SQL is used to join dimension and fact tables, calculate business metrics, and prepare analysis-ready datasets. Three analytical views are created: `vw_sales_line`, `vw_customer_summary`, and `vw_session_funnel`.

### Analysis
SQL analysis is performed to evaluate monthly sales, campaign performance, revenue trends, customer and product performance, category and brand contribution, membership behaviour, customer demographics, high-value customers, and repeat purchasing behaviour.

### Visualization
The prepared data is connected to Power BI and presented through interactive dashboard pages covering sales performance, customer behaviour, product and category performance, brand performance, membership analysis, and customer-level insights.

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

## Key Insights

- **Revenue performance is seasonal.** Monthly revenue fluctuates throughout the year, with December reaching the highest level at approximately **IDR 416M**, while February records the lowest at approximately **IDR 253M**. This indicates that demand is not evenly distributed and that peak-period planning can have a meaningful impact on annual performance.

- **Revenue and sales volume tell different stories.** Tops and Accessories lead product volume at roughly **1.9K and 1.8K units**, respectively, while Outerwear is the strongest revenue category at approximately **IDR 830M**. This suggests that unit volume alone is not sufficient for evaluating commercial performance; product value and category mix also matter.

- **Outerwear is the strongest revenue driver.** Outerwear contributes approximately **IDR 830M**, ahead of Footwear at **IDR 697M** and Bottoms at **IDR 616M**. The concentration of revenue in these categories makes them important priorities for merchandising, inventory planning, and promotional activity.

- **A small group of hero products drives substantial revenue.** Chunky Sneakers are the top product by revenue at approximately **IDR 247.9M**, followed by Minimal Loafers at **IDR 192M** and Relaxed Work Blazer at **IDR 188M**. This indicates that selected high-performing products can have an outsized effect on overall sales and may be suitable for featured placements or targeted promotions.

- **Membership revenue is concentrated in lower-tier or non-member customers.** Non-members account for the largest revenue share at **45.65%**, followed by Silver at **29.54%**, Gold at **19.74%**, and Platinum at **5.06%**. This creates an opportunity to examine whether non-members and lower-tier members can be converted into more engaged long-term customers.

- **Higher membership level does not correspond to higher average spending in the dashboard.** Average spending is approximately **IDR 4.6M for Non-members**, **IDR 4.4M for Silver**, **IDR 4.2M for Gold**, and **IDR 3.7M for Platinum**. This unexpected pattern suggests that membership level and customer value are not directly aligned in the current dataset and may warrant further investigation into tier definitions and customer behaviour.

- **The customer base is predominantly female.** Female customers represent **60.9%** of customers compared with **39.1% male**, indicating a clear dominant customer segment that can inform assortment, merchandising, and campaign targeting.

- **Customer demand is concentrated in several age groups.** The largest age groups contain approximately **238–240 customers**, while the smallest contains only **19**. This suggests that customer acquisition and campaign targeting could be prioritised around the dominant age segments rather than treating all age groups equally.

- **Brand performance is relatively concentrated among the leading brands.** Aster & Co generates the highest revenue at approximately **IDR 1.1B**, followed by Northline at around **IDR 1.0B** and Stride Lab at around **IDR 0.97B**. The presence of several strong brands provides an opportunity to compare which product and category combinations are driving their performance.

- **High-value customers represent an important retention opportunity.** The leading customer contributes close to **IDR 50M** in revenue, considerably above the lower-ranked customers in the top-customer analysis. This indicates that targeted retention and personalised offers could be valuable for protecting revenue from high-value customers.

- **Overall performance should be assessed using multiple dimensions.** The dashboard shows that the category with the highest unit volume is not the same as the category with the highest revenue, and the highest membership revenue segment is not the segment with the highest average spending. Therefore, sales volume, revenue, customer value, and membership status should be evaluated together when making commercial decisions.

## Campaign Analysis Note

The dataset contains **7 marketing campaigns**, so campaign analysis is included as part of the project scope. However, the dashboard pages shown in this project do not provide enough campaign-level figures to support a reliable comparison of all seven campaigns. Campaign conclusions should therefore be based on the underlying campaign-level data rather than attributing the dashboard's overall sales figures to a single campaign.

## Dashboard Summary

The Power BI dashboard provides an integrated view of:

- Overall revenue, orders, quantity, average order value, and customer KPIs
- Monthly sales trends
- Top products by revenue
- Revenue contribution by category
- Product volume by category
- Revenue distribution and average spending by membership level
- Customer distribution by age group and gender
- Brand revenue performance
- Top customers by revenue
- Product-level ranking and performance

The dashboard is designed to support data-driven decisions around **sales planning, product and category strategy, customer segmentation, membership strategy, brand performance, and campaign evaluation**.
