# Cyclistic User Behavior Analysis

*This case study was completed as a capstone project of the Google Data Analytics Certificate.*  

## Introduction
Cyclistic, a fictional bike-share company, has 5,824 bicycles and 692 docking stations running across Chicago. It offers three pricing plans: single-ride passes, full-day passes, and annual memberships. Their users are more likely to ride for leisure, but about 30% use the bikes to commute to work each day. Based on a belief that the company's future success depends on maximizing the number of annual memberships, the director of marketing wants to understand how casual riders - those who purchased single-ride or full-day passes - and annual members use Cyclistic bikes differently to start designing a new marketing strategy to convert casual riders into annual members instead of targeting new customers. The stakeholders involve the marketing analytics team and executive team.

 > Key Question: How Do Annual Members and Casual Riders Use Cyclistic Bikes Differently?

## 1. Prepare Data

### 1-1. Data
The Cyclistic's historical trip data is available to download [here](https://divvy-tripdata.s3.amazonaws.com/index.html). In this case study, monthly trip data in csv format for the previous 12 months, April 2024 through March 2025, was to be analyzed. Just the April 2024 file contained 415,025 rows so it seemed desirable to use SQL instead of Excel to process and analyze the combined data for the 12 months. 

### 1-2. PostgreSQL Installment and Set Up
I installed [Postgres.app](https://postgresapp.com) to run PostgreSQL on MacOS smoothly and [DBeaver](https://dbeaver.io), a free, open-source universal database tool, to connect to my PostgreSQL. Previously, when I downloaded the PostgresSQL server and pgAdmin through [its website](https://www.postgresql.org/download/macosx/), they did not operate properly on MacOS and I ran into a "connection failed" error every time I tried opening them.

### 1-3. Import data to PostgreSQL through DBeaver
I imported the 12 monthly csv files to PostgreSQL and changed the data type of 
| Column | Data Type |
|:-------|:----------|
|ride_id |varchar    |
|rideable_type|varchar|
|started_at|varchar -> timestamp|
|ended_at|varchar -> timestamp|
|start_station_name|varchar|
|start_station_id|varchar|
|end_station_name|varchar|
|end_station_id|varchar|
|start_lat|  -> numeric|
|start_lng| -> numeric|
|end_lat|  -> numeric |
|end_lng|  -> numeric |
|member_casual|varchar    |


## 2. Clean Data

## 3. Analyze Data

## 4. Visualize Data

## Takeaways

```
markdown edit
````
