# Cyclistic User Behavior Analysis

*This case study was completed as a capstone project of the Google Data Analytics Certificate.*  

## Introduction
Cyclistic, a fictional bike-share company, has 5,824 bicycles and 692 docking stations running across Chicago. It offers three pricing plans: single-ride passes, full-day passes, and annual memberships. Their users are more likely to ride for leisure, but about 30% use the bikes to commute to work each day. Based on a belief that the company's future success depends on maximizing the number of annual memberships, the director of marketing wants to understand how casual riders - those who purchased single-ride or full-day passes - and annual members use Cyclistic bikes differently to start designing a new marketing strategy to convert casual riders into annual members instead of targeting new customers. The stakeholders involve the marketing analytics team and executive team.

 > Key Question: How Do Annual Members and Casual Riders Use Cyclistic Bikes Differently?

## 1. Prepare Data

### 1-1. About Data
The Cyclistic's historical trip data is available to download [here](https://divvy-tripdata.s3.amazonaws.com/index.html). In this case study, monthly trip data in csv format for the previous 12 months, April 2024 through March 2025, was to be analyzed. Tthe April 2024 file alone contained 415,025 rows so it seemed desirable to use SQL instead of Excel to process and analyze the combined data for the 12 months. The combined dataset turned out to have more than 5.7 million records.

### 1-2. Install PostgreSQL and Set Up
I installed [Postgres.app](https://postgresapp.com) to run PostgreSQL on MacOS smoothly and [DBeaver](https://dbeaver.io), a free, open-source universal database tool, to connect to my PostgreSQL. Previously, when I downloaded the PostgresSQL server and pgAdmin through [its website](https://www.postgresql.org/download/macosx/), they did not operate properly on MacOS and I ran into a "connection failed" error almost every time I tried opening them.

### 1-3. Import data to PostgreSQL through DBeaver
I imported the 12 csv files to PostgreSQL and ensured that the data type of `started_at`and `ended-at` is timestamp.

| **Column** | **Data Type** |
|:-------|:----------|
|ride_id |varchar    |
|rideable_type|varchar|
|started_at|varchar -> timestamp|
|ended_at|varchar -> timestamp|
|start_station_name|varchar|
|start_station_id|varchar|
|end_station_name|varchar|
|end_station_id|varchar|
|start_lat|real -> numeric|
|start_lng|real -> numeric|
|end_lat|real -> numeric |
|end_lng|real -> numeric |
|member_casual|varchar    |

## 2. Clean Data
I started with the April 2024 table to clean one table at a time before combining them all together.
* It had no duplicates and no missing values in all the columns.
* But many empty string values - not NULL values - were found across location-related columns, such as `start_station_name`, `start_station_id`, `end_station_name`, and `end_station_id` columns. For example, the empty string values accounted for 18% in `start_station_name`. In real life, i would check with a person in charge what cause these and whether there's any way to replace them with real values to analyze ride routes of members and casual users. For this case study, I decided to remove these columns from analysis.



## 3. Analyze Data

## 4. Visualize Data

## Takeaways

```
markdown edit
````
