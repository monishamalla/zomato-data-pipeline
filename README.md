                     Zomato Data Engineering & AI Pipeline — End-to-End Project

The project demonstrates a modern data platform workflow covering **data ingestion, cloud data warehousing, ELT transformations, dimensional modeling, incremental processing, data quality, workflow orchestration, Docker, LLM-based review enrichment, RAG, and natural-language-to-SQL**.

### End-to-End Flow

```text
Zomato CSV Data
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
      ├──────────────► Analytical Data Marts
      │
      ▼
Apache Airflow
      │
      ├──────────────► AI Review Enrichment
      │
      ├──────────────► RAG Review Chat
      │
      └──────────────► Text-to-SQL
```

---

# 📌 Project Overview

This project simulates a production-style data platform for a food-delivery business.

The pipeline takes raw Zomato-style datasets representing restaurants, customers, food, menus, orders, order items, and reviews and transforms them into analytics-ready datasets in Snowflake.

The project follows a layered warehouse architecture:

```text
RAW
 │
 ▼
STAGING
 │
 ▼
MARTS
```

On top of the analytical warehouse, an AI layer provides:

* LLM-based customer review enrichment
* Review sentiment and topic analysis
* Retrieval-Augmented Generation (RAG)
* Natural-language-to-SQL querying

Apache Airflow is used to orchestrate the batch workflow, while Docker provides a reproducible local Airflow environment.

---

# 🏗️ Architecture

```text
                       ┌────────────────────────┐
                       │   Zomato Source Data   │
                       │                        │
                       │ restaurants.csv        │
                       │ users.csv              │
                       │ food.csv               │
                       │ menu.csv               │
                       │ orders.csv             │
                       │ order_items.csv        │
                       │ reviews.csv            │
                       └───────────┬────────────┘
                                   │
                                   ▼
                       ┌────────────────────────┐
                       │    Snowflake RAW       │
                       │                        │
                       │  Source-aligned tables │
                       └───────────┬────────────┘
                                   │
                                   ▼
                       ┌────────────────────────┐
                       │    dbt STAGING         │
                       │                        │
                       │  Cleaning              │
                       │  Type casting          │
                       │  Standardization       │
                       │  Business logic        │
                       └───────────┬────────────┘
                                   │
                                   ▼
                       ┌────────────────────────┐
                       │     dbt MARTS           │
                       │                        │
                       │ Dimensions              │
                       │ Facts                   │
                       │ Business marts          │
                       └───────────┬────────────┘
                                   │
                  ┌────────────────┼─────────────────┐
                  │                │                 │
                  ▼                ▼                 ▼
             Analytics        Airflow             AI Layer
                                │                    │
                                │              ┌─────┴─────┐
                                │              │           │
                                ▼              ▼           ▼
                         Batch Pipeline      RAG     Text-to-SQL
                                               │
                                               ▼
                                         Review Insights
```

---

# 🎯 What This Project Demonstrates

The project brings together several important Data Engineering concepts:

* Data ingestion
* Cloud data warehousing
* ELT architecture
* Snowflake
* SQL
* Python
* dbt
* Medallion architecture
* Dimensional modeling
* Fact and dimension tables
* Incremental models
* MERGE strategy
* Data quality testing
* Analytical marts
* Apache Airflow
* Docker
* Batch orchestration
* LLM integration
* Sentiment analysis
* Text classification
* Embeddings
* Retrieval-Augmented Generation
* Text-to-SQL
* Environment and secret management
* Git and GitHub

---

# 🗂️ Source Data

The project works with seven logical source datasets:

| Dataset       | Description                        |
| ------------- | ---------------------------------- |
| `restaurants` | Restaurant information and ratings |
| `users`       | Customer information               |
| `food`        | Food/menu item information         |
| `menu`        | Restaurant-menu relationships      |
| `orders`      | Customer order transactions        |
| `order_items` | Individual items within orders     |
| `reviews`     | Customer reviews and feedback      |

The raw datasets are intentionally **not committed to GitHub**.

This keeps the repository lightweight and avoids unnecessarily publishing the local dataset.

---

# 🧱 Data Warehouse Architecture

The Snowflake warehouse follows a layered approach.

```text
ZOMATO
│
├── RAW
│   └── Source-aligned data
│
├── STAGING
│   └── Cleaned and standardized models
│
└── MARTS
    ├── Dimensions
    ├── Facts
    └── Business marts
```

## RAW Layer

The RAW layer represents the source data with minimal transformation.

The objective is to preserve the source information before applying business transformations.

---

# 🧹 dbt Transformation Layer

dbt is responsible for transforming the RAW data into analytics-ready datasets.

The project follows:

```text
RAW → STAGING → MARTS
```

## Staging Layer

The staging layer contains one model for each major source.

```text
stg_restaurants
stg_users
stg_food
stg_menu
stg_orders
stg_order_items
stg_reviews
```

Typical staging transformations include:

* Data type conversion
* Null handling
* Column standardization
* Cleaning source-specific values
* Business-friendly column naming
* Deriving useful attributes
* Joining related source information where required

For example, restaurant data requires parsing fields such as:

```text
Rating:
"--" → NULL

Cost:
"₹ 200" → 200

Rating Count:
String representation → numeric value
```

The staging layer therefore acts as the **cleaning and standardization layer** before analytical modeling.

---

# ⭐ Dimensional Modeling

The MARTS layer follows dimensional modeling principles.

## Dimension Tables

```text
dim_customer
dim_date
dim_food
dim_restaurants
```

These tables provide descriptive attributes used to analyze business events.

## Fact Tables

```text
fct_orders
fct_order_items
```

These tables represent transactional business events.

Conceptually:

```text
                         dim_customer
                              │
                              │
                              ▼
dim_restaurants ───────► fct_orders ◄────── dim_date
                              │
                              │
                              ▼
                       fct_order_items
                              │
                              ▼
                          dim_food
```

This model supports analytical questions across:

* Customers
* Restaurants
* Food
* Orders
* Order items
* Time

---

# 📊 Business Data Marts

The project includes several analytical marts designed around business questions.

### `mart_daily_city_revenue`

Provides city-level revenue metrics such as:

* Orders
* Delivered orders
* Cancellation rate
* GMV
* Average order value

### `mart_restaurant_performance`

Provides restaurant-level performance metrics.

Examples include:

* Order volume
* Revenue
* Customer ratings
* Restaurant activity

### `mart_delivery_sla`

Analyzes delivery performance using delivery-time metrics.

The project calculates delivery percentiles such as:

```text
P50
P90
```

and enables analysis by dimensions such as city and hour.

### `mart_review_insights`

Provides an analytical layer for customer review insights.

---

# ⚡ Incremental Data Processing

The `fct_orders` model uses an incremental strategy.

Instead of rebuilding the entire fact table during every execution, incremental processing allows new or changed records to be incorporated efficiently.

Conceptually:

```text
Initial Load
     │
     ▼
Full Dataset
     │
     ▼
Incremental Runs
     │
     ├── New records
     │
     └── Updated records
```

The model uses a unique key and MERGE-style incremental processing.

This demonstrates an important production Data Engineering concept: **processing only the data that needs to be processed rather than rebuilding large datasets unnecessarily.**

---

# 🧪 Data Quality & dbt Tests

The dbt project includes source definitions and model-level validation.

Data quality checks are designed around concepts such as:

* Uniqueness
* Not-null validation
* Relationships
* Accepted values
* Source validation

The overall dbt workflow can therefore be represented as:

```text
Source
  │
  ▼
dbt Model
  │
  ▼
Tests
  │
  ├── Pass → Continue
  │
  └── Fail → Investigate
```

This ensures data quality issues can be identified as part of the transformation workflow.

---

# ⏱️ Apache Airflow Orchestration

Apache Airflow orchestrates the batch pipeline.

The primary DAG is:

```text
zomato_batch
```

The workflow coordinates the processing stages rather than requiring each component to be executed manually.

Conceptually:

```text
                  Airflow DAG
                      │
                      ▼
                 Raw Data Load
                      │
                      ▼
                  dbt Build
                      │
                      ▼
               Data Transformations
                      │
                      ▼
                AI Enrichment
                      │
                      ▼
               Analytical Models
```

Airflow provides:

* Scheduling
* Dependency management
* Task execution
* Pipeline monitoring
* Retry capabilities
* Centralized workflow management

---

# 🐳 Dockerized Airflow Environment

Airflow is containerized using Docker Compose.

The project includes:

```text
airflow/
├── Dockerfile
├── docker-compose.yaml
└── dags/
    └── zomato_batch.py
```

The Docker environment provides the components required to run Airflow locally, including:

* Airflow API Server
* Scheduler
* DAG Processor
* PostgreSQL metadata database

This makes the orchestration environment reproducible across development machines.

---

# 🤖 AI / LLM Layer

The project extends the traditional Data Engineering pipeline with an AI layer.

```text
Snowflake Data
      │
      ▼
Customer Reviews
      │
      ├───────────────┐
      │               │
      ▼               ▼
LLM Enrichment       Embeddings
      │               │
      ▼               ▼
Structured        RAG Retrieval
Insights               │
      │                ▼
      │             LLM Answer
      │
      ▼
Review Analytics
```

The AI implementation is contained in:

```text
ai/
├── enrich_reviews.py
├── rag_chat.py
└── text_to_sql.py
```

---

# 🧠 1. LLM Review Enrichment

`ai/enrich_reviews.py` uses an LLM to transform unstructured customer reviews into structured analytical attributes.

The enrichment process extracts information such as:

```text
sentiment_label
sentiment_score
topic
key_issue
```

Supported review topics include:

```text
food quality
delivery
pricing
service
packaging
other
```

Example:

```text
Input:
"Food was great but delivery was very late."

             │
             ▼

          LLM

             │
             ▼

sentiment_label → negative
topic           → delivery
key_issue       → late delivery
```

This converts free-text customer feedback into structured data that can be analyzed using SQL.

---

# 🔎 2. Retrieval-Augmented Generation

`ai/rag_chat.py` implements a conversational interface for customer reviews.

The RAG workflow is:

```text
Customer Reviews
      │
      ▼
Text Embeddings
      │
      ▼
Vector Representations
      │
      ▼
Similarity Search
      │
      ▼
Relevant Reviews
      │
      ▼
LLM
      │
      ▼
Grounded Response
```

The project uses `SentenceTransformer` embeddings to represent review text.

Users can ask questions such as:

```text
"What are customers saying about delivery?"

"What are the common complaints?"

"What do customers think about food quality?"
```

The system retrieves relevant reviews before generating the response.

This helps ground the generated response in the underlying review data.

---

# 💬 3. Text-to-SQL

`ai/text_to_sql.py` provides a natural-language interface to the analytical warehouse.

The workflow is:

```text
Natural Language Question
          │
          ▼
          LLM
          │
          ▼
      SQL Query
          │
          ▼
       Snowflake
          │
          ▼
      Query Result
```

Example:

```text
Question:

"Show the top restaurants by revenue."
```

The LLM can generate an SQL query against the analytical models.

This enables users without extensive SQL knowledge to interact with the warehouse through natural language.

---

# 📁 Repository Structure

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
│   ├── analyses/
│   │
│   ├── macros/
│   │   └── generate_schema_name.sql
│   │
│   ├── models/
│   │   ├── staging/
│   │   │   ├── _ai_sources.yml
│   │   │   ├── _sources.yml
│   │   │   ├── _staging.yml
│   │   │   ├── stg_food.sql
│   │   │   ├── stg_menu.sql
│   │   │   ├── stg_order_items.sql
│   │   │   ├── stg_orders.sql
│   │   │   ├── stg_restaurants.sql
│   │   │   ├── stg_reviews.sql
│   │   │   └── stg_users.sql
│   │   │
│   │   └── marts/
│   │       ├── _marts.yml
│   │       ├── dim_customer.sql
│   │       ├── dim_date.sql
│   │       ├── dim_food.sql
│   │       ├── dim_restaurants.sql
│   │       ├── fct_order_items.sql
│   │       ├── fct_orders.sql
│   │       ├── mart_daily_city_revenue.sql
│   │       ├── mart_delivery_sla.sql
│   │       ├── mart_restaurant_performance.sql
│   │       └── mart_review_insights.sql
│   │
│   ├── seeds/
│   ├── snapshots/
│   ├── tests/
│   ├── dbt_project.yml
│   └── README.md
│
├── .gitignore
└── README.md
```

---

# 🛠️ Technology Stack

| Layer             | Technology                   |
| ----------------- | ---------------------------- |
| Programming       | Python                       |
| Query Language    | SQL                          |
| Data Warehouse    | Snowflake                    |
| Transformation    | dbt                          |
| Orchestration     | Apache Airflow               |
| Containerization  | Docker / Docker Compose      |
| AI                | Gemini-compatible OpenAI API |
| Embeddings        | Sentence Transformers        |
| Application Layer | Streamlit                    |
| Version Control   | Git / GitHub                 |

---

# 🔐 Configuration & Secrets

Credentials are deliberately excluded from the Git repository.

The `.gitignore` prevents sensitive/local files from being committed:

```text
.env
.env.*
profiles.yml
.user.yml
data/
target/
logs/
dbt_packages/
*.parquet
```

Sensitive values such as:

```text
SNOWFLAKE_ACCOUNT
SNOWFLAKE_USER
SNOWFLAKE_PASSWORD
GEMINI_API_KEY
```

should be supplied through local environment variables or local configuration files.

**Never commit credentials or API keys to GitHub.**

---

# 🚀 Getting Started

## Prerequisites

Install:

* Python 3.11+
* Git
* Docker Desktop
* Snowflake account
* dbt
* Docker Compose
* An LLM API key for the AI components

---

## 1. Clone the Repository

```bash
git clone https://github.com/monishamalla/zomato-data-pipeline.git

cd zomato-data-pipeline
```

---

## 2. Configure Snowflake

Create a local:

```text
zomato/profiles.yml
```

with your Snowflake connection details.

The file is intentionally ignored by Git.

Validate the connection:

```bash
cd zomato
dbt debug
```

---

## 3. Install dbt

Install the Snowflake adapter:

```bash
pip install dbt-snowflake
```

Verify:

```bash
dbt --version
```

---

## 4. Run dbt

Install dependencies if required:

```bash
dbt deps
```

Build the project:

```bash
dbt build
```

Or run models only:

```bash
dbt run
```

Run tests:

```bash
dbt test
```

---

# 🐳 Running Airflow

Navigate to:

```bash
cd ../airflow
```

Start the Docker environment:

```bash
docker compose up -d
```

Check the running containers:

```bash
docker compose ps
```

View logs when required:

```bash
docker compose logs -f
```

The Airflow web interface is available locally on the configured Airflow port.

Once Airflow is running:

1. Open the Airflow UI.
2. Locate `zomato_batch`.
3. Enable/unpause the DAG.
4. Trigger the DAG manually or allow its schedule to execute it.
5. Monitor task execution from the Airflow UI.

---

# 🤖 Running the AI Components

## Review Enrichment

Configure the required API key and run:

```bash
python ai/enrich_reviews.py
```

The script reads customer reviews and generates structured enrichment fields.

---

## RAG Chat

Run:

```bash
streamlit run ai/rag_chat.py
```

The application allows users to ask questions about customer reviews.

---

## Text-to-SQL

Run:

```bash
streamlit run ai/text_to_sql.py
```

The application allows users to interact with the Snowflake analytical layer using natural-language questions.

---

# 📈 Example Business Questions

The resulting warehouse can answer questions such as:

### Revenue

* What is the daily revenue by city?
* What is the average order value?
* Which restaurants generate the highest revenue?

### Restaurant Performance

* Which restaurants have the highest order volume?
* How does restaurant rating relate to performance?
* Which restaurants have high cancellation rates?

### Delivery

* What is the median delivery time?
* What is the P90 delivery time?
* How does delivery performance vary by city?
* Which hours experience slower deliveries?

### Customer

* Which customers place the most orders?
* What are the major customer complaints?
* What sentiment trends appear in reviews?

### Reviews

* What are customers saying about food quality?
* What are the most common delivery complaints?
* What issues are associated with negative reviews?

---

# 🔄 End-to-End Pipeline

The complete workflow can be summarized as:

```text
                    ┌──────────────┐
                    │ Source Data  │
                    └──────┬───────┘
                           │
                           ▼
                    ┌──────────────┐
                    │ Snowflake    │
                    │ RAW          │
                    └──────┬───────┘
                           │
                           ▼
                    ┌──────────────┐
                    │ dbt          │
                    │ STAGING      │
                    └──────┬───────┘
                           │
                           ▼
                    ┌──────────────┐
                    │ dbt          │
                    │ MARTS        │
                    └──────┬───────┘
                           │
             ┌─────────────┼─────────────┐
             │             │             │
             ▼             ▼             ▼
         Analytics      Airflow         AI
                           │             │
                           │       ┌─────┼─────┐
                           │       │     │     │
                           ▼       ▼     ▼     ▼
                       Pipeline  LLM   RAG  Text-to-SQL
```

---

# 🔑 Key Engineering Concepts

## ELT

Transformations are performed after data reaches the analytical warehouse.

```text
Extract → Load → Transform
```

Snowflake provides the scalable analytical processing layer while dbt manages SQL transformations.

---

## Medallion Architecture

The project follows a layered approach similar to:

```text
Bronze → Silver → Gold
  │        │       │
 RAW    STAGING   MARTS
```

### Bronze

Raw source data.

### Silver

Cleaned and standardized data.

### Gold

Business-ready analytical datasets.

---

## Dimensional Modeling

Facts represent measurable business events while dimensions provide descriptive context.

```text
Facts
  │
  ├── Orders
  └── Order Items

Dimensions
  │
  ├── Customer
  ├── Restaurant
  ├── Food
  └── Date
```

---

## Incremental Processing

Incremental models avoid unnecessary full-table rebuilds and demonstrate how larger analytical datasets can be processed efficiently.

---

## Workflow Orchestration

Airflow manages dependencies between pipeline stages and provides visibility into pipeline execution.

---

## AI as a Data Transformation Layer

The LLM enrichment process demonstrates how unstructured data can be transformed into structured analytical attributes.

```text
Unstructured Review
        │
        ▼
       LLM
        │
        ▼
Structured Attributes
        │
        ▼
Analytical Warehouse

---

# 👩‍💻 Author

**Monisha Malla**

Data Engineering | SQL | Python | Snowflake | dbt | AWS | Airflow

---

# ⭐ Project Objective

The objective of this project is to demonstrate an end-to-end modern Data Engineering workflow that combines:

**Data Warehousing + ELT + Dimensional Modeling + Orchestration + Data Quality + AI**

The project is designed as a practical portfolio implementation of how raw operational data can be transformed into reliable analytical datasets and then exposed through both traditional SQL analytics and modern AI-powered interfaces.
