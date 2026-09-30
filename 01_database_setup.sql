-- ## SQL Database Setup — Customers and Accounts Table]

USE banking_analysis;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    age DECIMAL(5,2),
    region VARCHAR(20),
    income VARCHAR(30),
    tenure_months INT,
    signup_date VARCHAR(50),
    has_credit_card TINYINT,
    age_clean DECIMAL(5,2),
    region_clean VARCHAR(20),
    income_clean DECIMAL(12,2),
    signup_date_clean DATE

);


CREATE TABLE accounts (
    customer_id INT,
    num_products INT,
    avg_monthly_spend DECIMAL(12,2),
    txn_count_monthly INT,
    credit_limit DECIMAL(12,2),
    avg_balance DECIMAL(12,2),
    utilization VARCHAR(20),
    late_payments_last_year INT,
    responded_to_offer VARCHAR(10),
    churned VARCHAR(10),
    avg_monthly_spend_clean DECIMAL(12,2),
    utilization_clean DECIMAL(10,4),
    responded_to_offer_clean TINYINT,
    churned_clean TINYINT
);

