<img align="left" width="25%" height="25%" alt="Logo wihtout background" src="https://github.com/user-attachments/assets/7280f0e3-9efd-403c-90af-3958c288b4e3" /> </br>
Cyclistic, a sample bike-share company, launched a successful bike-share offering in 2016. Since then, the program has grown to a fleet of 5,824 bicycles that are geotracked and locked into a network of 692 stations across Chicago. </br>  
Until now, Cyclistic’s marketing strategy relied on building general awareness and appealing to broad consumer segments, by offering the flexibility of three pricing plans: single-ride passes, full-day passes, and annual memberships. Now, finance analysts have concluded that annual members are much more profitable than casual riders (single-ride and full-day pass users), and the director of marketing also believes that there is a solid growth opportunity to convert casual riders into members rather than continuing to target all-new customers.
</br>
</br>
**Stakeholder Questions:** 
* How do annual members and casual riders use Cyclistic bikes differently?
* Are there different temporal or spatial patterns between two groups?
  
**Key Metrics:** Rides • Trip Duration • Long-Ride Frequency

**Table of Contents** 

## About Data and Tools

#### About Data
The dataset comprises 12 tables for each month for the most recent 12 months from April 2024 through March 2025, which were combined into a single table containing **+5.7M records** for this analysis.
 
<details>
<summary>Data Dictionary: Click to expand</summary> 
	 
| **Column** | **Data Type** | **Description** |
|:-------|:----------|:----------|
|ride_id |varchar    |primary key|
|rideable_type|varchar|values: classic_bike, electric_bike, electric_scooter|
|started_at|timestamp|start time|
|ended_at|timestamp|end time|
|start_station_name|varchar| |
|start_station_id|varchar| |
|end_station_name|varchar| |
|end_station_id|varchar| |
|start_lat|numeric|start station latitude|
|start_lng|numeric|start station longitude|
|end_lat|numeric|end station latitude|
|end_lng|numeric|end station longitude|
|member_casual|varchar|values: casual, member|
	
</details>

**Tools Used**
* SQL for data cleaning and analysis: **Postgres.app** installed to run PostgreSQL on MacOS smoothly and **DBeaver**(a free, open-source universal database tool) to connect and import data to PostgreSQL.
	* SQL queries for data inspection, cleaning, and manipulation can be found [here](https://github.com/jayoungs/Cyclistic-User-Behavior-Analysis/blob/main/01_inspection_cleaning_manipulation.sql).
 	* SQL queries for EDA can be found [here](https://github.com/jayoungs/Cyclistic-User-Behavior-Analysis/blob/main/02_EDA.sql).
* Tableau for visualization and dashboards

## Presentation on Insights and Recommendation


* The whole slides can be found here.

## Caveat

```
markdown edit
````
