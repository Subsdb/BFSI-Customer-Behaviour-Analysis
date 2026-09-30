-- =====================================================
-- 1. Customer-to-Account Coverage
-- =====================================================

-- This analysis checks the relationship between the
-- Customers and Accounts tables using customer_id.
--
-- It identifies how many customers have a corresponding
-- account record and highlights any unmatched records.

SELECT
    (SELECT COUNT(*) FROM customers) AS customer_rows,
    (SELECT COUNT(DISTINCT customer_id) FROM customers) AS unique_customer_ids,
    (SELECT COUNT(*) FROM accounts) AS account_rows,
    (SELECT COUNT(DISTINCT customer_id) FROM accounts) AS unique_account_ids;


-- =====================================================
-- 2. Accounts Without Customer Records
-- =====================================================

-- This query identifies account records whose customer_id
-- does not exist in the Customers table.

SELECT COUNT(*) AS accounts_without_customer
FROM accounts a
LEFT JOIN customers c
    ON a.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- =====================================================
-- 3. Customers Without Account Records
-- =====================================================

-- This query identifies customers whose customer_id
-- does not exist in the Accounts table.

SELECT COUNT(*) AS customers_without_accounts
FROM customers c
LEFT JOIN accounts a
    ON c.customer_id = a.customer_id
WHERE a.customer_id IS NULL;


-- =====================================================
-- Findings
-- =====================================================

-- The Customers and Accounts tables do not have complete
-- one-to-one coverage.
--
-- 10,391 customer IDs are present in both tables.
--
-- 1,132 customers are present in Customers but have no
-- corresponding record in Accounts.
--
-- 605 account records are present in Accounts but have no
-- corresponding record in Customers.
--
-- These unmatched records indicate a data-integration gap
-- between the two source tables.
--
-- Analyses requiring both customer and account attributes
-- will use the matched customer population.