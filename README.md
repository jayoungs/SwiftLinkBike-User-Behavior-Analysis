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

| **Column** | **Data Type** | **Description** |
|:-------|:----------|:----------|
|ride_id |varchar    |prmary key|
|rideable_type|varchar|values: classic_bike, electric_bike, electric_scooter|
|started_at|varchar -> timestamp|start time|
|ended_at|varchar -> timestamp|end time|
|start_station_name|varchar| |
|start_station_id|varchar| |
|end_station_name|varchar| |
|end_station_id|varchar| |
|start_lat|real -> numeric|start station latitude|
|start_lng|real -> numeric|start station longitude|
|end_lat|real -> numeric |end station latitude|
|end_lng|real -> numeric |end station longitude|
|member_casual|varchar    |values: casual, member|

## 2. Clean and Manipulate Data

### 2-1. Check Duplicates and Missing Values
I started with the April 2024 table to clean one table at a time before combining them all together.
* It had no duplicates and no missing values in all the columns.
* But many empty string values - not NULL values - were found across location-related columns, such as `start_station_name`, `start_station_id`, `end_station_name`, and `end_station_id` columns. For example, the empty string values accounted for 18% in `start_station_name`. In real life, i would check with a person in charge what cause these and whether there's any way to replace them with real values to analyze ride routes of members and casual users. For this case study, I decided to remove these columns for this analysis.

### 2-2. Create a Temporary Table With Key Columns to Test
I then created a temporary table to test by selecting only necessary columns and creating new ones:

<details>
<summary>Click to expand</summary>

```sql

DROP TABLE IF EXISTS temp_table;
CREATE TEMP TABLE temp_table AS (
SELECT 
 ride_id,
 rideable_type,
 started_at,
	ended_at,
	(ended_at - started_at) AS ride_length, 
	EXTRACT(MONTH FROM started_at) AS ride_month,
	EXTRACT(DOW FROM started_at) AS day_of_week, 
	EXTRACT(HOUR FROM started_at) AS hour_of_day,
	member_casual
FROM bikesharing_cyclist."202404_divvy_tripdata"

```

</details>

### 2-3. Inspect the Temporary Table and Validate Data

I inspected the temporary table as below and found that there were other things to fix and clean:
* 188 rides out of 415,025 that their start time was equal to or later than the end time.
* 10,195 rides that took less than 1 minute and 18,782 that took less than 2 minutes.

<details>
<summary>Click to expand</summary>

```sql

-- inspect new dataset
SELECT *
FROM temp_table
LIMIT 10;

SELECT COUNT(*)
FROM temp_table;

-- check the range of day_of_week is correct:
SELECT COUNT(*)
FROM temp_table
WHERE day_of_week NOT BETWEEN 0 AND 6;

-- check the range of hour_of_day:
SELECT 
 MIN(ride_hour),
	MAX(ride_hour)
FROM temp_table

-- check the range of ride_length
SELECT 
 MIN(ride_length), 
 MAX(ride_length) 
FROM temp_table;

-- validate start time and end time
SELECT COUNT(*)
FROM temp_table
WHERE started_at >= ended_at; 

-- how many records have less than 1 minute ride length?
SELECT COUNT(*)
FROM temp_table
WHERE ride_length < '00:01:00.000';

--> how about rides that took less than 2 minutes?
SELECT COUNT(*)
FROM temp_table
WHERE ride_length < '00:02:00.000'; 

```

</details>

These records could have been caused by system or user error or some other reasons. I decided to remove records with start time equal to later than end time and less than 1 minute ride duration.

> **Change Summary**
> 
> Deleted:
> * `start_station_name`, `start_station_id`, `end_station_name`, `end_station_id`, `start_lat`, `start_lng`, `end_lat`, and `end_lng` columns
> * records with start time equal to later than end time
> * records with less than 1 minute ride duration.
>   
> Added: `ride_length`, `ride_month`, `day_of_week`, `ride_hour`


### 2-4. Create clean tables for each month

I created a clean table for April 2024 as below:

<details>
<summary>Click to expand</summary>

```sql

DROP TABLE IF EXISTS bikesharing_cyclist.clean_202404;
CREATE TABLE bikesharing_cyclist.clean_202404 AS (
WITH  t1 AS (
SELECT 
  ride_id,
  rideable_type,
  started_at,
  ended_at,
  (ended_at - started_at) AS ride_length, 
  EXTRACT(MONTH FROM started_at) AS ride_month,
  EXTRACT(DOW FROM started_at) AS day_of_week, 
  EXTRACT(HOUR FROM started_at) AS hour_of_day,
  member_casual
FROM bikesharing_cyclist."202404_divvy_tripdata"
WHERE started_at < ended_at
),
t2 AS (
SELECT *
FROM t1
WHERE ride_length >= '1 minute'
)
SELECT *
FROM t2
);

```

</details>

The number of records reduced to 404,830 from 415,025. I inspected the dataset and confirmed that the records with the above two conditions were completely removed.

I then inpected datasets for the rest of the months and created the cleaned ones in the same way.

### 2-5. Combine 12 Tables
Using `UNION ALL`, I combined the 12 tables all together. The completed table was confirmed to contain 5,650,799 records without duplicates.

<details>
<summary>Click to expand</summary>

```sql

DROP TABLE IF EXISTS complete_table;
CREATE TEMP TABLE complete_table AS (
SELECT *
FROM bikesharing_cyclist.clean_202404 dt 
UNION ALL
SELECT *
FROM bikesharing_cyclist.clean_202405 dt 
UNION ALL
SELECT *
FROM bikesharing_cyclist.clean_202406 dt 
UNION ALL
SELECT *
FROM bikesharing_cyclist.clean_202407 dt 
UNION ALL
SELECT *
FROM bikesharing_cyclist.clean_202408 dt 
UNION ALL
SELECT *
FROM bikesharing_cyclist.clean_202409 dt 
UNION ALL
SELECT *
FROM bikesharing_cyclist.clean_202410 dt
UNION ALL
SELECT *
FROM bikesharing_cyclist.clean_202411 dt
UNION ALL 
SELECT *
FROM bikesharing_cyclist.clean_202412 dt
UNION ALL
SELECT *
FROM bikesharing_cyclist.clean_202501 dt 
UNION ALL
SELECT *
FROM bikesharing_cyclist.clean_202502 dt 
UNION ALL
SELECT *
FROM bikesharing_cyclist.clean_202503 dt 
);

```

## 3. Analyze Data

## 4. Visualize Data

## Takeaways

```
markdown edit
````
