#  Zomato Data Engineering & AI Pipeline

An end-to-end **Data Engineering project** built using **Snowflake, dbt, Apache Airflow, Docker, Python, SQL, and AI/LLM technologies**.

The project demonstrates how raw Zomato-style data can be transformed into analytics-ready datasets and enriched with AI-powered customer review insights.

---

##  Architecture

```text
                  Zomato Source Data
                         │
                         ▼
                  Snowflake RAW
                         │
                         ▼
                    dbt STAGING
                         │
                         ▼
                     dbt MARTS
                         │
              ┌──────────┴──────────┐
              │                     │
              ▼                     ▼
        Analytics Layer          AI Layer
                                    │
                         ┌──────────┼──────────┐
                         ▼          ▼          ▼
                       Review      RAG     Text-to-SQL
                    Enrichment
                         │
                         ▼
                   AI Insights
```

---

## Project Overview

This project simulates a modern data platform for a food-delivery business.

The pipeline processes seven datasets:

* Restaurants
* Users
* Food
* Menu
* Orders
* Order Items
* Reviews

The data is loaded into **Snowflake**, transformed using **dbt**, and organized into fact, dimension, and analytical tables.

**Apache Airflow** orchestrates the batch workflow, while the AI layer provides review enrichment, RAG-based analysis, and natural-language SQL querying.

---

## Technology Stack

| Area             | Technology            |
| ---------------- | --------------------- |
| Language         | Python, SQL           |
| Data Warehouse   | Snowflake             |
| Transformation   | dbt                   |
| Orchestration    | Apache Airflow        |
| Containerization | Docker                |
| AI / LLM         | Gemini-compatible API |
| Embeddings       | Sentence Transformers |
| Application      | Streamlit             |
| Version Control  | Git / GitHub          |

---

##  Project Structure

```text
zomato-data-pipeline/
│
├── ai/
│   ├── enrich_reviews.py
│   ├── rag_chat.py
│   └── text_to_sql.py
│
├── airflow/
│   ├── dags/
│   │   └── zomato_batch.py
│   ├── Dockerfile
│   └── docker-compose.yaml
│
├── zomato/
│   ├── macros/
│   ├── models/
│   │   ├── staging/
│   │   └── marts/
│   ├── tests/
│   ├── seeds/
│   ├── snapshots/
│   └── dbt_project.yml
│
└── .gitignore
```

Raw datasets and credentials are intentionally excluded from the repository.

---

## Data Transformation

The dbt project follows a layered approach:

```text
RAW → STAGING → MARTS
```

### Staging

The staging layer cleans and standardizes source data.

Models include:

```text
stg_restaurants
stg_users
stg_food
stg_menu
stg_orders
stg_order_items
stg_reviews
```

### Marts

The marts layer provides analytics-ready models.

**Dimensions**

```text
dim_customer
dim_date
dim_food
dim_restaurants
```

**Facts**

```text
fct_orders
fct_order_items
```

**Analytical Marts**

```text
mart_daily_city_revenue
mart_delivery_sla
mart_restaurant_performance
mart_review_insights
```

The project also includes **incremental processing** for the orders fact table and dbt-based data quality testing.

---

## Airflow & Docker

Apache Airflow is used to orchestrate the batch pipeline.

The Airflow environment is containerized using Docker Compose.

The main DAG is:

```text
zomato_batch
```

This provides scheduling, task dependencies, execution monitoring, and repeatable local pipeline execution.

---

## AI Layer

The project extends the traditional data pipeline with three AI capabilities.

### 1. Review Enrichment

Customer reviews are processed using an LLM to extract structured information such as:

```text
sentiment_label
sentiment_score
topic
key_issue
```

Topics include food quality, delivery, pricing, service, and packaging.

### 2. RAG Review Chat

A Retrieval-Augmented Generation workflow uses **Sentence Transformer embeddings** to retrieve relevant customer reviews before generating an answer.

Example:

> "What are the common delivery complaints?"

### 3. Text-to-SQL

Natural-language questions can be converted into SQL queries that can be executed against the Snowflake analytical layer.

Example:

> "Show the top restaurants by revenue."

---

## 📊 Analytics Use Cases

The transformed data supports analysis such as:

* Revenue by city
* Restaurant performance
* Average order value
* Order trends
* Delivery SLA performance
* Customer behavior
* Food-level sales
* Customer review sentiment
* Common customer complaints

---

## 🚀 Getting Started

### Prerequisites

* Python 3.11+
* Docker Desktop
* Snowflake account
* dbt
* Git

### Clone the repository

```bash
git clone https://github.com/monishamalla/zomato-data-pipeline.git
cd zomato-data-pipeline
```

### Configure dbt

Create a local:

```text
zomato/profiles.yml
```

with your Snowflake connection details.

Then:

```bash
cd zomato
dbt debug
dbt deps
dbt build
```

### Start Airflow

```bash
cd ../airflow
docker compose up -d
```

Open the Airflow UI and enable/trigger the `zomato_batch` DAG.

---

## Security

Sensitive files are excluded from version control, including:

```text
.env
profiles.yml
.user.yml
data/
target/
logs/
*.parquet
```

API keys and Snowflake credentials should always be stored locally through environment variables or configuration files.

---

## Author

**Monisha Malla**

Data Engineering | SQL | Python | Snowflake | dbt | AWS | Airflow

---

## 🔗 Repository

[GitHub – Zomato Data Engineering Pipeline](https://github.com/monishamalla/zomato-data-pipeline)
