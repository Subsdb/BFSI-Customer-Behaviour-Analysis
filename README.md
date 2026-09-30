# BFSI Customer Behaviour, Offer Response & Churn Analysis

## Project Overview

This independent banking analytics project examines customer behaviour, marketing-offer response, and churn using customer and account activity data.

The analysis was designed around a practical banking business problem: understand which customer characteristics are associated with stronger response to a credit-card upgrade offer, and which characteristics are associated with higher observed churn.

The project combines **Python, Pandas, NumPy, MySQL, SQL, SciPy, and Matplotlib** to move from data preparation and validation to business analysis, statistical testing, and evidence-based recommendations.

---

## Business Problem

A banking business wants to improve response to a credit-card upgrade offer while also identifying customers who may require retention attention.

The project focuses on two questions:

1. Which customer characteristics are associated with higher observed offer-response rates?
2. Which customer characteristics are associated with higher observed churn?

The objective is not to claim causation, but to identify meaningful patterns that can support further marketing and retention analysis.

---

## Data Sources

The project uses two source tables:

### Customers

Customer-level information such as:

- Customer ID
- Age
- Income
- Region
- Tenure
- Signup date
- Credit-card ownership

### Accounts

Account and behavioural information such as:

- Number of products
- Average monthly spend
- Monthly transaction count
- Credit limit
- Average balance
- Credit utilization
- Late payments in the last year
- Offer response
- Churn status

The project guide specifies these customer and account characteristics as the core variables for analysis.

---

## Project Workflow

```text
Source Data
    ↓
Python Data Cleaning
    ↓
Data Quality & Duplicate Checks
    ↓
MySQL Database Setup
    ↓
SQL Data Validation
    ↓
Customer-Level Analytical View
    ↓
Behaviour & Outcome Analysis
    ↓
Statistical Validation
    ↓
Business Recommendations
    ↓
Visual Summary
```

---

## Data Preparation & Validation

Python was used to prepare the source data and create cleaned analytical fields.

Key activities included cleaning inconsistent values, preparing analytical variables, and checking data quality before analysis.

MySQL was then used to validate the imported data and examine the relationship between the Customers and Accounts tables.

### Current MySQL analysis population

| Dataset / relationship | Records |
|---|---:|
| Customers | 11,523 |
| Accounts | 10,996 |
| Customer IDs present in both tables | 10,391 |
| Customers without a matching Account record | 1,132 |
| Account records without a matching Customer record | 605 |

Combined analyses that require information from both tables use the matched population.

A reusable SQL view, `customer_analytics`, was created to bring together relevant customer and account attributes for analysis.

---

## SQL Analysis

MySQL was used to answer the main business questions through grouped analysis, joins, conditional logic, aggregations, subqueries, and a reusable analytical view.

### Key SQL concepts demonstrated

- `SELECT`
- `COUNT()`
- `SUM()`
- `AVG()`
- `MIN()` / `MAX()`
- `ROUND()`
- `CASE WHEN`
- `GROUP BY`
- `ORDER BY`
- `INNER JOIN`
- `LEFT JOIN`
- Subqueries
- Views

### Business analyses performed

- Overall offer-response and churn rates
- Offer response by region
- Customer distribution by region
- Offer response by number of products
- Offer response by credit utilization
- Churn by late-payment behaviour
- Churn by offer-response status
- Customer relationship depth analysis
- Outcomes by income band
- Outcomes by transaction activity
- Outcomes by monthly spend

---

## Key Findings

### Overall baseline

Across the 10,996 records in the Accounts analysis population:

- **7,020 customers responded** to the offer.
- **Observed offer-response rate: 63.84%**
- **1,561 customers were recorded as churned.**
- **Observed churn rate: 14.20%**

These metrics were used as baseline benchmarks for the group-level analyses.

### Product relationship depth

The strongest observed difference was between single-product and multi-product customers.

| Product group | Offer response | Churn |
|---|---:|---:|
| 1 Product | 28.83% | 36.49% |
| 2+ Products | 82.90% | 2.06% |

This indicates a substantial observed association between relationship depth and both offer response and churn.

### Credit utilization

Offer response varied materially by utilization:

| Credit utilization | Offer response |
|---|---:|
| 0–25% | 67.06% |
| 25–50% | 67.54% |
| 50–75% | 35.39% |
| 75–100% | 25.00% |

The 75–100% group contains only 40 customers, so that rate should be interpreted cautiously.

### Late payments and churn

Observed churn was relatively stable for customers with 0–2 late payments, then increased substantially for customers with higher late-payment counts:

- **3 late payments: 34.35% churn**
- **4 late payments: 35.04% churn**

The 5-late-payment group is small and should be interpreted cautiously.

### Offer response and churn

Churn also differed substantially by offer-response status:

| Offer response | Churn rate |
|---|---:|
| Did not respond | 25.55% |
| Responded | 7.76% |

This shows an observed association between offer-response status and churn.

### Variables with limited standalone separation

Income, monthly transaction activity, monthly spend, and region showed relatively small differences in the current analysis and therefore did not appear to be strong standalone differentiators of response or churn.

---

## Statistical Validation

Two key relationships identified during the SQL analysis were statistically tested using **chi-square tests of independence**.

### Product group and offer response

- **Chi-square statistic: 3175.81**
- **Degrees of freedom: 1**
- **P-value: extremely small; Python reported 0.0 due to numerical precision**

The result provides strong statistical evidence of an association between product group and offer-response status in the analysis population.

### Late-payment group and churn

Late payments were grouped into `0–2` and `3+` for the test.

- **Chi-square statistic: 254.02**
- **Degrees of freedom: 1**
- **P-value: 3.455 × 10⁻⁵⁷**

The result provides strong statistical evidence of an association between late-payment group and churn status.

**Important:** statistical association does not establish causation.

---

## Business Recommendations

### Potential cross-sell / relationship-deepening opportunity

Single-product customers showed substantially lower observed offer response and substantially higher observed churn than customers with multiple products.

This group could be investigated further for relationship-deepening or cross-sell opportunities, with targeting refined using additional customer characteristics and business constraints.

### Retention attention for higher late-payment customers

Customers with higher late-payment counts showed substantially higher observed churn.

These customers may warrant additional retention or risk attention rather than being treated solely as marketing targets.

### Use credit utilization as supporting context

Higher utilization levels were associated with substantially lower observed offer response.

Utilization can therefore be considered as supporting context when designing marketing or retention strategies.

### Avoid over-relying on weak standalone variables

Income, transaction count, monthly spend, and region showed relatively limited separation in the current analysis.

These variables can still provide useful context, but the analysis does not support treating them as strong standalone indicators of response or churn.

---

## Visual Analysis

Four business-focused charts were created in Matplotlib to communicate the strongest findings:

1. **Offer Response Rate by Product Group**
2. **Offer Response Rate by Credit Utilization**
3. **Churn Rate by Late-Payment Group**
4. **Churn Rate by Offer Response**

The original PNG files are stored in the `charts/` folder.

---

## Tools & Technologies

- **Python** — analysis and visualization
- **Pandas** — data manipulation and aggregation
- **NumPy** — conditional transformations
- **SciPy** — chi-square statistical testing
- **Matplotlib** — business visualizations
- **MySQL** — database analysis and validation
- **MySQL Workbench** — SQL development
- **Jupyter Notebook** — Python analysis environment

---

## Repository Structure

```text
BFSI-Customer-Behaviour-Analysis/
│
├── README.md
│
├── data/
│   ├── customers_final.csv
│   └── accounts_final.csv
│
├── sql/
│   ├── 01_database_setup.sql
│   ├── 02_data_validation.sql
│   └── 03_business_analysis.sql
│
├── python/
│   ├── 01_data_cleaning.ipynb
│   ├── 02_statistical_analysis.ipynb
│   └── 03_visual_analysis.ipynb
│
├── charts/
│   ├── Offer Response Rate by Product Group.png
│   ├── response_by_credit_utilization.png
│   ├── Churn Rate by Late Payment Group.png
│   └── Churn Rate by Offer Response.png
│
└── analysis/
    └── Final_Business_Analysis.docx
```

Adjust filenames in the structure if your local project filenames differ.

---

## Limitations

- The current MySQL dataset contains mismatched customer and account records, so combined analyses use the matched population.
- Some groups are relatively small, particularly the 75–100% utilization group and customers with five late payments.
- The analysis identifies observed associations rather than causal relationships.
- The results are based on the currently available portfolio dataset and should be validated against additional data before operational use.

---

## Project Scope Note

The original project guide included customer segmentation using K-Means. During development, that stage was explored but was not included in the final analytical scope.

The completed project therefore focuses on the parts that were fully analysed and validated:

**Data Cleaning → SQL Business Analysis → Behaviour & Outcome Analysis → Statistical Testing → Visual Analysis → Business Recommendations**

This keeps the final project focused on analyses that can be clearly explained and defended in an interview.

---

## Conclusion

The analysis identified meaningful differences in customer outcomes associated with product relationship depth, credit utilization, late-payment behaviour, and offer-response status.

The strongest observed patterns were also statistically validated using chi-square tests of independence. The results provide a data-driven basis for further investigation of cross-sell and retention opportunities while maintaining an important distinction between association and causation.
