# B2Broker Analytics Engineering Case

Daniel Junges | eudanieljunges@gmail.com

---

## **Project Overview and Approach**

This case study was developed for **B2Broker** to demonstrate an **end-to-end analytics engineering workflow**. The goal was to transform raw brokerage data into **trusted**, **analysis-ready data marts** that enable reporting on client performance, trading activity, and account health.

The project addresses the following business questions:  

- **Performance:** Identify top performers and underperformers by net PnL.  
- **Activity:** Track the number of active traders (clients/accounts) per day and week.  
- **Risk / Account Health:** Identify accounts and clients at risk, including those marked as deleted but still trading.  
- **Additional Insights:** Analyze trade sizes and symbol losses.

---

## **Datasets**

The raw datasets provided (CSV format) include:  

<img width="1559" height="736" alt="image" src="https://github.com/user-attachments/assets/f888e50e-20bc-416a-9079-d11d2e7758d3" />


---

## **Data Modeling**

The data was transformed into the following **dbt models**:

### **Dimensions**
- `dim_client` – standardized client data with surrogate keys.  
- `dim_account` – account-level information linked to clients.  
- `dim_symbol` – normalized symbols using `symbols_ref`.

### **Facts**
- `fact_trades` – detailed trade information, including net PnL, trade duration, standardized symbols, and client/account references, with uniqueness ensured per trade ID.
- `fact_account_eod` – daily account metrics including balances, equity, and floating PnL.  
- `f_client_performance_daily` – aggregated client performance metrics for reporting.

### **Staging**
- Staging models were created for raw tables (`stg_trades`, `stg_accounts`, `stg_clients`) to **clean, normalize, and enrich** data before loading into dimensional tables.

---

## **Data Quality & Testing**

Data quality is ensured using **dbt tests**:  

- **Uniqueness:** Ensures unique keys for `trade_id`, `account_sk`, `client_sk`.  
- **Not Null:** Verifies that critical fields are not null.  
- **Accepted Values / Business Logic:** Tests to validate segment names, jurisdictions, and account status.
- **Custom Business Logic Test**: Validate that all trades have **positive volume**.

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

1. **Total PnL:**
    - Shows the total net profit and loss for the selected period.

2. **Total Volume:**:
      -  Displays the total trading volume.

3. **Total PnL per Month:**:
      - A line chart that tracks the trend of total net PnL over time.

4. **Average Trade Size by Symbol:**
    -  Compares the average trade size across different trading symbols.

5. **Top 10 Clients by Net PnL:**
     -  Ranks the top 10 clients by their total net profit and loss.

6. **Loss per Symbol:**
    - Visualizes the total loss (realized PnL + commission) for each trading symbol.

7. **Daily Active Clients:**  
   - A line chart that tracks the number of unique active clients on a daily basis.

8. **Weekly Active Clients:**
   - A line chart that displays the number of unique active clients per week. The tooltip shows the number of active accounts for a given week number.

9. **Top Clients by Equity Drawdown:**
   - A table that provides a detailed list of individual trades from accounts that have been marked as deleted. The table includes the trade **date**, **account_sk**, and **client_sk**, which is a key tool for risk investigation.



---

## **Technologies Used**

- **dbt (Data Build Tool):** Transformation and modeling  
- **PostgreSQL on Azure Cloud:** Data storage & querying
- **Power BI:** Dashboard and reporting

<img width="1392" height="475" alt="image" src="https://github.com/user-attachments/assets/7c1e263e-e481-476e-beb5-2dd9155b0fbc" />


---

## **Architecture**

<img width="3840" height="309" alt="Untitled diagram _ Mermaid Chart-2025-09-14-011320" src="https://github.com/user-attachments/assets/09680236-646c-4d42-8285-0ecb2d20ecdc" />

## **How to Run**

1. **Clone the repository**

```bash
git clone https://github.com/<your_username>/case-b2broker.git
cd case-b2broker
```

2. **Install dbt**
```bash
pip install dbt-postgres
```

3. **Configure Environment Variables (Secure)**
Use VS Code or Windows PowerShell to set the environment with the following content:
```bash
$env:DBT_HOST="your_host"
$env:DBT_USER="your_user"
$env:DBT_PASSWORD="your_password"
$env:DBT_DB="your_database"
$env:DBT_PORT="5432"
$env:DBT_SCHEMA="public"
```
For security reasons, all the information was sent to Aidana via Telegram.


3. **Initialize dbt project**
```bash
dbt deps
dbt debug
```
<img width="504" height="207" alt="image" src="https://github.com/user-attachments/assets/24f9bad4-e88d-45b1-97e8-c0dd401f5849" />

To install dbt packages and test connections and environment.

4. **Run the project (staging models, dimensions and facts) - option 1**
```bash
dbt run
```
Or  **Build the project (staging models, dimensions, facts and tests) - option 2**
```bash
dbt build
```

5. **Run tests separately (optional)**
```bash
dbt test
```

6. **Connect to Power BI**
- Open the .pbix file in Power BI Desktop.
- Make sure your data source credentials are correctly set (if prompted).
- Refresh the data to load the latest tables and facts from the database.

You can now explore the dashboards, visuals, and reports using the available fact and dimension tables.

## Notes
   - Follow the directory structure for models, seeds, and tests to avoid errors.

# Analysis Output

**Market & Asset Behavior**
  - **Trade Volume:** The analysis shows a well-balanced market with a total volume of $81,14K. The distribution between buy and sell orders is nearly even, which suggests a healthy, two-sided market with active participation on both sides, a positive sign for liquidity.
  - **Average Trade Size:** Shows significant differences in trade value across various assets. GER40 and US30 have the largest average trade sizes, at **$67.93** and **$90.94** respectively. This suggests traders may be using larger capital or feel more confident when trading these specific index CFDs.
  - **Loss per Symbol:** Shows that while some assets are profitable, others contribute to the platform's overall loss. Symbols like **WTI** ($-184,88k) and **US500** ($-179,76K) show significant losses.

**Risk and Compliance Insights**
 - **Equity Dradown:** The Clients with the largest equity drawdown chart is a crucial risk indicator. It identifies clients with the most significant capital losses. The top clients by drawdown are **C0028** ($1.62M), **C0000** ($1.58M), and **C0025** ($1.58M), which signals significant **risk** in these accounts.

<img width="1312" height="731" alt="image" src="https://github.com/user-attachments/assets/da48117e-818f-492d-9963-e1eb5f089b1e" />




# Summary Insights

- Profitability is highly concentrated. A significant portion of the total profit comes from a handful of high-volume clients, making the platform's overall performance heavily reliant on a small group of traders.

- Market activity is well-balanced. The nearly even split between buy and sell volumes suggests a healthy and active market, where traders are participating on both sides.

- Trading behavior varies by asset. The average trade size is not consistent across all symbols. Traders are committing larger capital on instruments like **GER40** and **US30**, which may indicate greater confidence or a preference for trading indices.

# Challenges Faced

During the development of the analytics workflow, several challenges were encountered and addressed:

**Data Quality Issues**
- Some trades had missing client_external_id or account_sk, requiring careful linkage between accounts and clients to maintain accuracy. Missing client IDs, duplicate trades, and null values were handled via account-based client mapping, deduplication with **ROW_NUMBER()**, and **COALESCE** logic in staging.

**Inconsistent Symbol Naming**
- Trade symbols from different platforms were inconsistent in format and casing. reference table **(symbols_ref)** was used to normalize symbols to a standardized **std_symbol**, ensuring consistent aggregation in reports.

**Dashboard Design & Metrics Calculation**
- Some derived metrics (e.g., total trade size, Net PnL per client or symbol) required careful calculation using DAX in Power BI. Ensuring meaningful visualizations while keeping them concise on a single page dashboard was a balancing challenge.

**Environment & Deployment**
- Handling dbt profiles securely with environment variables was essential to avoid exposing credentials.
- Ensuring the project could be run reproducibly on another machine required detailed “How to Run” instructions.
  

**Outcome:** Each challenge was addressed with a combination of dbt transformations, testing, and clear documentation, resulting in a robust, reproducible, and insightful analytics workflow ready for management reporting.
