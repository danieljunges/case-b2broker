# Multi-Asset Brokerage Trading Analytics

Daniel Junges | eudanieljunges@gmail.com

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
- **PostgreSQL on Azure Cloud:** Data storage & querying
- **Power BI:** Dashboard and reporting  
- **Python / Jupyter Notebook:** Analysis and scripting  

---

## **Architecture**



## **How to Run**

1. **Clone the repository**

```bash
git clone https://github.com/<your_username>/case-b2broker.git
cd case=b2broker
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
For security reasons, all the informations were sent by Telegram to Aidana.


3. **Initialize dbt project**
```bash
dbt deps
dbt debug
```
<img width="504" height="207" alt="image" src="https://github.com/user-attachments/assets/24f9bad4-e88d-45b1-97e8-c0dd401f5849" />

To install dbt packages and test connections and environment.

4. **Initialize dbt project (if not done)**
```bash
dbt init
```
**Note:** If the terminal prompts for PostgreSQL credentials during initialization, use the connection details that were shared via Telegram.

5. **Run seeds (loads CSV data into the database)**
```bash
dbt seeds
```

6. **Build the project (staging models, dimensions, facts and tests)**
```bash
dbt build
```

7. **Run tests separately (optional)**
```bash
dbt test
```

## Notes
   - Follow the directory structure for models, seeds, and tests to avoid errors.
8. **Connect to Power BI**


## **Architecture**

--

# Analysis Output

**Client Performance & Profitability
The platform's profitability is highly concentrated among a small number of clients. The Top 5 Clients by Net PnL chart clearly shows that client C0038 is the top performer, with a net PnL of over $339K. This indicates that a significant portion of the total profit comes from a handful of high-volume or highly successful traders. This presents a potential risk; any change in their trading behavior could have a large impact on overall performance.
<img width="584" height="451" alt="image" src="https://github.com/user-attachments/assets/a559f401-4f41-4b22-99eb-6a2b85c04e0b" />


**Trade Characteristics & Volume**
The Trade Volume Share: Buy vs Sell pie chart reveals that trading activity is nearly balanced between buy and sell orders. Buy volume is $900.00 (49.34%), and sell volume is $924.00 (50.66%). This balanced distribution suggests a healthy, two-sided market with active participants on both long and short positions, rather than a strong one-way bias.
<img width="592" height="591" alt="image" src="https://github.com/user-attachments/assets/2f15bc0f-200b-4a9f-9a6c-7afc8ac5185b" />


**Asset Trading Behavior**
The Average Trade Size by Symbol chart highlights significant differences in the value of trades for various assets. GER40 and US30 have the largest average trade sizes, at $67.93 and $58.67, respectively. This suggests that traders are either more confident or are using larger capital when trading these specific index CFDs.
<img width="600" height="285" alt="image" src="https://github.com/user-attachments/assets/5eb3233c-2651-40f8-989c-b11103d1fb96" />


In contrast, assets like EUR/USD and USD/JPY have some of the lowest average trade sizes, at $30.50 and $30.84. While these are often highly liquid pairs, their lower average trade size may indicate that traders are taking smaller positions or are being more cautious with them.

   - Ensure all environment variables are correctly set before running dbt.
   - Monetary values in dashboards are in USD.

# Summary Insights

- Profitability is highly concentrated. A significant portion of the total profit comes from a handful of clients. The top client, C0038, is a major contributor, making the platform's overall performance heavily reliant on a small group of high-volume traders.

- Market activity is well-balanced. The even split between buy and sell volumes ($900.00 vs. $924.00) suggests a healthy and active market. This indicates that traders are actively participating on both sides of the market, a positive sign for liquidity.

- Trading behavior varies by asset. The average trade size is not consistent across all symbols. Traders are committing larger capital on instruments like GER40 and US30, which may indicate greater confidence or a preference for trading indices. Conversely, forex pairs like EUR/USD show a lower average trade size, suggesting traders might be taking more cautious positions on those assets.

