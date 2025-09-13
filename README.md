# Multi-Asset Brokerage Trading Analytics

**Author:** [Your Name]  
**Date:** [Date]  

---

## **Project Overview**

This project demonstrates an end-to-end analytics engineering workflow for a global multi-asset brokerage. The objective is to transform raw trading and account data into **clean, analysis-ready data marts** and produce actionable insights for management.  

The project addresses the following business questions:  

- **Performance:** Identify top performers and underperformers by net PnL.  
- **Activity:** Track the number of active traders (clients/accounts) per day and week.  
- **Risk / Account Health:** Identify accounts and clients at risk, including those marked as deleted but still trading.  
- **Additional Insights:** Analyze trade sizes, symbol losses, and buy/sell distributions.  

---

## **Datasets**

The raw datasets provided (CSV format) include:  

| Table | Description | Key Fields |
|-------|------------|------------|
| `trades_raw` | Trade records | trade_id, platform, account_id, client_external_id, symbol, side, volume, open_time, close_time, open_price, close_price, commission, realized_pnl, book_flag, counterparty, quote_currency, status |
| `accounts_raw` | Trading account registry | account_id, platform, client_id, base_currency, created_at, closed_at, salesforce_account_id, is_system, is_deleted |
| `clients_raw` | Client master | client_id, client_external_id, jurisdiction, segment, created_at |
| `balances_eod_raw` | End-of-day balances | account_id, platform, date, balance, equity, floating_pnl, credit, margin_level |
| `symbols_ref` | Symbol normalization reference | platform, platform_symbol, std_symbol, asset_class, quote_currency, tick_value |

---

## **Data Modeling**

The data was transformed into the following **dbt models**:

### **Dimensions**
- `dim_client` – standardized client data with surrogate keys.  
- `dim_account` – account-level information linked to clients.  
- `dim_symbol` – normalized symbols using `symbols_ref`.

### **Facts**
- `fact_trades` – detailed trade information, enriched with trade duration and standardized symbols.  
- `fact_account_eod` – daily account metrics including balances, equity, and floating PnL.  
- `f_client_performance_daily` – aggregated client performance metrics for reporting.

### **Staging**
- Staging models were created for raw tables (`stg_trades`, `stg_accounts`, `stg_clients`) to **clean, normalize, and enrich** data before loading into dimensional tables.

---

## **Data Quality & Testing**

Data quality is ensured using **dbt tests**:  

- **Uniqueness:** Ensures unique keys for `trade_id`, `account_sk`, `client_sk`.  
- **Not Null:** Verifies that critical fields are not null.  
- **Accepted Values / Business Logic:** Custom tests to validate segment names, jurisdictions, and account status.  

All test failures are logged and provide evidence for data inconsistencies.

---

## **Assumptions & Sign Conventions**

- **Currency:** All monetary values are in **USD**.  
- **Client & Account Linking:** Some trades with missing `client_external_id` are linked via account information.  
- **Symbol Normalization:** Symbols are standardized using `symbols_ref`.  
- **Sign Conventions:**  
  - Realized PnL and commissions are additive for net PnL calculations.  
  - Buy/Sell side values are standardized as `BUY` or `SELL`.

---

## **Dashboard & Analytics**

A **Power BI dashboard** was built to visualize key metrics:

1. **Top Clients by Net PnL**  
   - **Type:** Table / Bar chart  
   - **X-axis:** Net PnL  
   - **Y-axis:** Client Name (`dim_client`)  
   - **Filter:** Top 5 clients  

2. **Symbol Loss by Symbol**  
   - **Type:** Bar chart with negative values highlighted in red  
   - **X-axis:** Symbol (`dim_symbol`)  
   - **Y-axis:** Loss (realized PnL + commission)

3. **Average Trade Size per Symbol**  
   - **Type:** Column chart  
   - **X-axis:** Symbol  
   - **Y-axis:** Average trade volume in USD  

4. **Buy vs Sell Distribution**  
   - **Type:** Pie chart  
   - **Values:** Count of trades  
   - **Legend:** Trade side (`BUY` / `SELL`)  

All dashboards **filter dynamically** by client, account, and date ranges.

---

## **Technologies Used**

- **dbt (Data Build Tool):** Transformation and modeling  
- **PostgreSQL:** Data storage and querying  
- **Power BI:** Dashboard and reporting  
- **Python / Jupyter Notebook:** Optional analysis  

---

## **Architecture**

```text
Raw Data (CSV)
       |
       v
 Staging Models (stg_*)
       |
       v
 Dimension & Fact Models (dim_*, fact_*)
       |
       v
     dbt Tests (uniqueness, not null, business logic)
       |
       v
   Power BI Dashboard & Analytics
