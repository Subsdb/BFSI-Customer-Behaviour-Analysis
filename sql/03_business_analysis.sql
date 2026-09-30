
-- =====================================================
-- 1. Customer Coverage

-- This analysis measures how many customers in the Customers table have a corresponding 
-- record in the Accounts table.

-- The objective is to identify customers who have no associated account activity data and 
-- determine whether the dataset represents the full customer base.

-- This also helps identify potential data-quality or data-integration gaps before performing 
-- further customer-level analysis.
-- =====================================================

SELECT
    COUNT(*) AS total_customers,
    COUNT(a.customer_id) AS customers_with_accounts,
    COUNT(*) - COUNT(a.customer_id) AS customers_without_accounts
FROM customers c
LEFT JOIN accounts a
    ON c.customer_id = a.customer_id;


-- =====================================================
-- Finding
-- =====================================================

-- =====================================================
-- Finding — Customer-to-Account Coverage
-- =====================================================

-- There are 11,523 customers in the Customers table.
--
-- 10,391 customers have a corresponding record in the
-- Accounts table.
--
-- 1,132 customers do not have a matching Accounts record.
--
-- This means approximately 90.18% of the customers have
-- corresponding account information, while 9.82% do not.
--
-- The unmatched customers indicate a data-integration gap
-- between the two source tables.
--
-- Analyses requiring both customer and account attributes
-- will therefore use the matched customer population.


-- =====================================================
-- 2. Offer Response by Region
-- Query 1: Response rate by region
-- =====================================================

-- This analysis measures how customers in each region
-- responded to the marketing offer.
--
-- The objective is to compare the number of customers
-- who responded to the offer and calculate the response
-- rate for each region.


select 
 c.region_clean as regions, 
 count(*) as total_customers,
 sum(responded_to_offer_clean) as responded, 
 round(SUM(a.responded_to_offer_clean)*100.0/count(*),2) as response_rate 
from customers c 
inner join accounts a 
on c.customer_id = a.customer_id
group by c.region_clean;


-- =====================================================
-- Findings
-- =====================================================

-- Offer response rates across the four known regions are
-- relatively close, ranging from 62.72% to 65.57%.
--
-- The Unknown region has a lower observed response rate
-- of 59.42%, but this group represents customers whose
-- region information is unavailable and should not be
-- interpreted as a geographic pattern.
--
-- The grouped results contain 10,391 customers, which is
-- lower than the previously observed 10,996 customer rows
-- in the current MySQL Customers table.
--
-- This discrepancy should be investigated before using
-- regional response rates as a major business conclusion.



-- =====================================================
-- 3. Offer Response by Region
-- Customer Distribution by Region
-- =====================================================

-- This query measures how the customer base is distributed
-- across different regions.
--
-- COUNT(*) calculates the number of customers in each region.
--
-- The subquery:
-- (SELECT COUNT(*) FROM customers)
-- calculates the total number of customers in the table.
--
-- Customer share is then calculated as:
--
-- Regional customers / Total customers × 100
--
-- This helps us understand whether differences in response
-- rates are occurring in regions with a large or small
-- share of the overall customer base.


select region_clean AS region,
count(*) as total_customers,
round(
count(*) * 100 / (select count(*)from customers),2) as customer_share
from customers
group by region_clean;

-- =====================================================
-- Finding
-- =====================================================

-- The query shows how the total customer base is distributed
-- across each region.
--
-- `total_customers` represents the number of customers within
-- each individual region.
--
-- `customer_share` shows each region's percentage of the
-- total customer base.
--
-- This helps provide context for the regional offer-response
-- analysis by showing both the response rate and the size of
-- each customer group.


-- =====================================================
-- 4. Offer Response by Number of Products
-- =====================================================

-- This analysis compares offer response rates across
-- customers with different numbers of products.
--
-- The objective is to understand whether relationship
-- depth with the bank is associated with a higher
-- likelihood of responding to the marketing offer.
--
-- This is particularly relevant to the cross-sell and
-- upgrade objective of the project.

select num_products, sum(responded_to_offer_clean) as response , round(sum(responded_to_offer_clean) * 100 / count(*),2) as response_rate
from accounts 
group by num_products;

-- =====================================================
-- Finding — Offer Response by Number of Products
-- =====================================================

-- The strongest difference is between single-product
-- customers and customers with multiple products.
--
-- Single-product customers have an observed response rate
-- of 28.83%.
--
-- Customers with 2, 3, 4, and 5 products have observed
-- response rates ranging from 82.38% to 85.03%, showing
-- relatively little difference within the multi-product
-- group.
--
-- This suggests that the key distinction is between
-- single-product and multi-product customers rather than
-- the exact number of products held.


-- =====================================================
-- 5. Offer Response by Credit Utilization
-- =====================================================

-- This analysis compares offer-response behaviour across
-- different levels of credit utilization.
--
-- Utilization is grouped into business-readable bands:
-- 0%-25%, 25%-50%, 50%-75%, and 75%-100%.
--
-- The objective is to understand whether customers with
-- different levels of credit usage show different observed
-- response rates to the marketing offer.

select 
case 
	when utilization_clean < 0.25 then '0-25%'
    when utilization_clean < 0.50 then '25-50%'
    when utilization_clean < 0.75 then '50-75%'
    else '75-100%'
end as credit_utilization,
count(*) as total_customers,
round(sum(responded_to_offer_clean)*100/count(*),2) as response_rate
from accounts
group by 
	case 
		when utilization_clean < 0.25 then '0-25%'
		when utilization_clean < 0.50 then '25-50%'
		when utilization_clean < 0.75 then '50-75%'
		else '75-100%'
    end;

-- =====================================================
-- Finding — Offer Response by Credit Utilization
-- =====================================================

-- Offer response is relatively high among customers with
-- utilization below 50%, with response rates of 67.06%
-- and 67.54% for the 0-25% and 25-50% groups.
--
-- Response declines substantially for customers with
-- utilization above 50%, falling to 35.39% for the
-- 50-75% group and 25.00% for the 75-100% group.
--
-- This suggests that credit utilization is associated
-- with meaningful differences in observed offer response.
--
-- The 75-100% group contains only 40 customers, so its
-- response rate should be interpreted with caution due
-- to the relatively small group size.
--
-- These results represent observed associations and do
-- not establish that utilization causes differences in
-- offer response.

-- =====================================================
--  Churn Analysis
-- =====================================================

-- =====================================================
--  1. Churn Analysis by Late Payments
-- =====================================================

-- This analysis examines the observed churn rate across
-- different levels of late payments in the last year.
--
-- The objective is to understand whether repayment
-- behaviour is associated with customer churn and identify
-- customer groups that may require retention attention.

select late_payments_last_year, sum(churned_clean) as churned,
round(sum(churned_clean) * 100 / count(*),2) as churn_rate
from accounts
group by late_payments_last_year;

-- =====================================================
-- Finding — Churn by Late Payments
-- =====================================================

-- Observed churn is relatively stable for customers with
-- 0 to 2 late payments, ranging from 11.93% to 13.22%.
--
-- Churn increases substantially for customers with
-- 3 late payments (34.35%) and 4 late payments (35.04%).
--
-- This suggests that higher levels of late-payment
-- behaviour are associated with elevated observed churn.
--
-- The 5-late-payment group should be interpreted with
-- caution because it contains very few customers.
--
-- These results represent observed association and do not
-- establish that late payments cause customer churn.


-- =====================================================
-- 2. Overall Offer Response and Churn
-- =====================================================

-- This analysis establishes the overall response rate
-- to the marketing offer and the overall churn rate.
--
-- These baseline metrics provide a reference point for
-- comparing different customer groups in subsequent
-- analyses.


SELECT
    COUNT(*) AS total_customers,
    SUM(responded_to_offer_clean) AS customers_responded,
    ROUND(
        SUM(responded_to_offer_clean) * 100.0 / COUNT(*),
        2
    ) AS response_rate,
    SUM(churned_clean) AS customers_churned,
    ROUND(
        SUM(churned_clean) * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM accounts;

-- =====================================================
-- Finding — Overall Offer Response and Churn
-- =====================================================

-- Across the 10,996 customers in the Accounts table,
-- 7,020 responded to the marketing offer, resulting in
-- an overall observed response rate of 63.84%.
--
-- A total of 1,561 customers are recorded as churned,
-- resulting in an overall observed churn rate of 14.20%.
--
-- These overall metrics provide baseline benchmarks for
-- comparing response and churn behaviour across different
-- customer groups and segments.

-- =====================================================
-- 3. Churn by Offer Response
-- =====================================================

-- This analysis compares observed churn rates between
-- customers who responded to the marketing offer and
-- customers who did not respond.
--
-- The objective is to understand whether offer-response
-- behaviour is associated with customer churn.

select responded_to_offer_clean as response_to_offer,
 sum(churned_clean) as churned, 
 sum(churned_clean)*100/count(*) as chured_rate 
 from accounts group by responded_to_offer_clean;
 
 -- =====================================================
-- Finding — Churn by Offer Response
-- =====================================================

-- Customers who did not respond to the offer (0) have
-- an observed churn rate of 25.55%.
--
-- Customers who responded to the offer (1) have an
-- observed churn rate of 7.76%.
--
-- The observed churn rate is therefore substantially
-- higher among non-responding customers than among
-- responding customers.
--
-- This indicates an association between offer-response
-- status and observed churn in the dataset.
--
-- This analysis does not establish that responding to
-- the offer causes lower churn.



-- =====================================================
-- 4. Customer Relationship Depth Analysis
-- =====================================================

-- This analysis compares customers with one product
-- against customers with two or more products.
--
-- The objective is to understand whether deeper
-- relationships with the bank are associated with
-- differences in customer activity, offer response,
-- and churn.
--
-- A CTE is used to create the business-friendly
-- product groups before calculating the metrics.

select 
case when num_products = 1 then "1 Product"
	 else "2+ Products"
end as number_of_products, 
count(*) as total_customers, 
round(avg(avg_monthly_spend_clean),2) as monthly_average_spend,
round(avg(txn_count_monthly),2) as monthly_transction_count,
sum(responded_to_offer_clean) as total_customers_responded, 
round(sum(responded_to_offer_clean)*100.0/count(*),2) as response_rate,
sum(churned_clean) as total_churned,
round(sum(churned_clean) * 100.0 / count(*),2) as churned_rate
from accounts
group by 
case when num_products = 1 then "1 Product"
	 else "2+ Products"
     end;
     
     
-- =====================================================
-- Finding — Customer Relationship Depth
-- =====================================================

-- Customers with one product have an observed offer
-- response rate of 28.83% and an observed churn rate
-- of 36.49%.
--
-- Customers with two or more products have a much higher
-- observed offer response rate of 82.90% and a much lower
-- observed churn rate of 2.06%.
--
-- Average monthly spending and transaction activity are
-- very similar between the two groups, indicating that the
-- differences in response and churn are not accompanied
-- by large differences in these two activity measures.
--
-- This suggests that relationship depth is an important
-- characteristic to investigate further in the customer
-- segmentation analysis.
--
-- These are observed associations and do not establish
-- that holding more products causes higher response or
-- lower churn.


-- =====================================================
-- 5. Customer Outcomes by Income Band
-- =====================================================

-- This analysis groups customers into income bands and
-- compares their average monthly spending, offer response,
-- and churn behaviour.
--
-- The objective is to understand whether customer income
-- is associated with differences in engagement and business
-- outcomes.
--
-- The analysis uses the cleaned income field from the
-- Customers table and the behavioural/outcome fields from
-- the Accounts table.


-- =====================================================
-- 6. Customer Outcomes by Income Band
-- =====================================================

-- This analysis groups customers into income bands and
-- compares their average monthly spending, offer response,
-- and churn behaviour.
--
-- The objective is to understand whether customer income
-- is associated with differences in engagement and business
-- outcomes.
--
-- The analysis uses the cleaned income field from the
-- Customers table and the behavioural/outcome fields from
-- the Accounts table.

SELECT
    CASE
        WHEN c.income_clean < 30000 THEN '< 30K'
        WHEN c.income_clean < 50000 THEN '30K-50K'
        WHEN c.income_clean < 75000 THEN '50K-75K'
        ELSE '75K+'
    END AS income_band,

    COUNT(*) AS total_customers,

    ROUND(AVG(a.avg_monthly_spend_clean), 2) AS avg_monthly_spend,

    ROUND(AVG(a.txn_count_monthly), 2) AS avg_monthly_transactions,

    SUM(a.responded_to_offer_clean) AS customers_responded,

    ROUND(
        SUM(a.responded_to_offer_clean) * 100.0 / COUNT(*),
        2
    ) AS response_rate,

    SUM(a.churned_clean) AS customers_churned,

    ROUND(
        SUM(a.churned_clean) * 100.0 / COUNT(*),
        2
    ) AS churn_rate

FROM customers c
JOIN accounts a
    ON c.customer_id = a.customer_id

GROUP BY
    CASE
        WHEN c.income_clean < 30000 THEN '< 30K'
        WHEN c.income_clean < 50000 THEN '30K-50K'
        WHEN c.income_clean < 75000 THEN '50K-75K'
        ELSE '75K+'
    END;
    
    
    
-- =====================================================
-- Finding — Customer Outcomes by Income Band
-- =====================================================

-- Offer response rates are relatively consistent across
-- all income bands, ranging from 62.62% to 64.72%.
--
-- Churn rates are also relatively consistent, ranging from
-- 13.57% to 14.71%.
--
-- The differences are small compared with the overall
-- response rate of 63.84% and overall churn rate of 14.20%.
--
-- Therefore, income does not show a strong observed
-- relationship with offer response or churn in the current
-- dataset.
--
-- Income may still be useful as a segmentation feature
-- because it captures customer value, but it does not appear
-- to be a strong standalone driver of the observed outcomes.


-- =====================================================
-- 7. Customer-Level Analytical Dataset
-- =====================================================

-- This section brings together relevant customer and
-- account-level information into a single analytical view.
--
-- The objective is to create one analysis-ready dataset
-- that combines customer characteristics with account
-- behaviour and business outcomes.
--
-- This dataset will be used for the later customer
-- segmentation and statistical analysis.


create or replace view customer_analytics as 
select 
    c.customer_id,
    c.age_clean,
    c.region_clean,
    c.income_clean,
    c.tenure_months,
    c.signup_date_clean,
    c.has_credit_card,
    a.num_products,
    a.avg_monthly_spend_clean,
    a.txn_count_monthly,
    a.credit_limit,
    a.avg_balance,
    a.utilization_clean,
    a.late_payments_last_year,
    a.responded_to_offer_clean,
    a.churned_clean

from customers c 
inner join accounts a 
 on c.customer_id=a.customer_id;
        
        
-- =====================================================
-- 8. Customer Outcomes by Transaction Activity
-- =====================================================

-- This analysis examines offer response and churn across
-- different levels of monthly transaction activity.
--
-- The objective is to understand whether customer activity
-- is associated with differences in offer response and churn.
--
-- Customers are grouped into business-friendly transaction
-- activity bands to make the comparison easier to interpret.

select 
	case 
		when txn_count_monthly <= 2 then '0-2 Transactions'
        when txn_count_monthly <= 5 then '3-5 Transactions'
        else '6+ Transactions'
	end as Transaction_groups,
count(*) as total_customers, 
sum(responded_to_offer_clean) as customers_responded,
round(sum(responded_to_offer_clean) * 100.0 / count(*),2) as response_rate,
sum(churned_clean) as total_churned,
round(sum(churned_clean) * 100.0 / count(*),2) as churn_rate
from customer_analytics
group by 
case 
		when txn_count_monthly <= 2 then '0-2 Transactions'
        when txn_count_monthly <= 5 then '3-5 Transactions'
        else '6+ Transactions'
	end ;
    
    -- =====================================================
-- Finding — Customer Outcomes by Transaction Activity
-- =====================================================

-- Offer response rates are relatively consistent across
-- the three transaction-activity groups, ranging from
-- 63.33% to 66.20%.
--
-- Churn rates are also relatively consistent, ranging from
-- 13.17% to 14.71%.
--
-- Therefore, monthly transaction count does not show a
-- strong observed relationship with offer response or
-- churn in this dataset.
--
-- Transaction activity may still be useful as a supporting
-- segmentation feature, but it does not appear to be a
-- strong standalone differentiator of these outcomes.


-- =====================================================
-- 9. Customer Outcomes by Monthly Spend
-- =====================================================

-- This analysis compares offer response and churn across
-- different levels of average monthly spending.
--
-- The objective is to understand whether customer spending
-- behaviour is associated with differences in offer response
-- and churn.
--
-- Customers are grouped into business-friendly spending
-- bands to make the comparison easier to interpret.

select 
	case
        WHEN avg_monthly_spend_clean < 250 THEN '< 250'
        WHEN avg_monthly_spend_clean < 500 THEN '250-500'
        WHEN avg_monthly_spend_clean < 1000 THEN '500-1000'
        ELSE '1000+'
    END AS spend_group,
COUNT(*) AS total_customers,
sum(responded_to_offer_clean) as customers_responded,
round(sum(responded_to_offer_clean) * 100.0/count(*),2) as response_rate,
sum(churned_clean) as customers_churned,
sum(churned_clean) * 100.0 / count(*) as churn_rate
from customer_analytics
group by 
case
        WHEN avg_monthly_spend_clean < 250 THEN '< 250'
        WHEN avg_monthly_spend_clean < 500 THEN '250-500'
        WHEN avg_monthly_spend_clean < 1000 THEN '500-1000'
        ELSE '1000+'
    END;
    
    
-- =====================================================
-- Finding — Customer Outcomes by Monthly Spend
-- =====================================================

-- Offer response rates are relatively consistent across
-- the spending bands, ranging from 62.56% to 65.49%.
--
-- Churn rates are also relatively consistent, ranging from
-- 13.38% to 14.86%.
--
-- Therefore, average monthly spend does not show a strong
-- observed relationship with offer response or churn in
-- the current dataset.
--
-- Monthly spend may still be retained as a supporting
-- feature for customer segmentation because it represents
-- customer activity and value.

-- =====================================================
-- Product count      → strong differences
-- Utilization        → strong differences
-- Late payments      → strong churn differences
-- Income             → weak differences
-- Transactions       → weak differences
-- Monthly spend      → weak differences
-- =====================================================
