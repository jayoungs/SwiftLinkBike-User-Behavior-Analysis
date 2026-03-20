<img align="left" width="25%" height="25%" alt="ceb067dc-611f-4d67-b6ef-a5ff8900f248" src="https://github.com/user-attachments/assets/a3bb8fe4-22ef-4932-99e5-e93d118afcb3" />

SwiftLink Bike, a sample bike-share company, launched its service in 2016. Since then, the program has grown to a fleet of 5,824 geotracked bicycles integrated into a network of 692 stations across Chicago.</br>
</br>
Historically, SwiftLink Bike’s marketing strategy focused on building general awareness through three flexible pricing plans: Single-Ride passes, Full-Day passes, and Annual Memberships. Financial analysis has recently concluded that annual members are significantly more profitable than casual riders (single-ride and full-day users). Consequently, the Director of Marketing believes there is a substantial growth opportunity in converting existing casual riders into members, rather than exclusively targeting new customer acquisitions.
</br>
</br>
**Stakeholder Questions:** 
* How do annual members and casual riders use SwiftLink Bike differently?
* What are the distinct temporal and spatial patterns between the two groups?
  
**Key Metrics:** Ride Volume • Average Trip Duration • Median Trip Duration • Long-Ride Volume </br> 
</br> 

## Data and Tools

### About the Data
The dataset comprises 12 monthly tables covering the period from April 2024 through March 2025. These were aggregated into a single primary table containing over **5.7 million records** for this analysis.
 
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

### Tools Used
* SQL (PostgreSQL): Utilized for data cleaning and analysis. **Postgres.app** was used to run PostgreSQL on MacOS, with **DBeaver** serving as the database management tool.
	* [SQL queries for data inspection, cleaning, and manipulation](https://github.com/jayoungs/SwiftLinkBike-User-Behavior-Analysis/blob/main/01_inspection_cleaning_manipulation.sql)
	* [SQL queries for Exploratory Data Analysis](https://github.com/jayoungs/SwiftLinkBike-User-Behavior-Analysis/blob/main/02_EDA.sql)
* Google Sheets: Used for pivot tables and initial charting.
* Google Slides: Final presentation with dynamic charts linked to Google Sheets.
* Tableau: Used for geospatial visualizations and heatmaps.

## Presentation Sample

<img width="2560" height="1440" alt="Screenshot 2026-03-19 at 7 03 00 PM (2)" src="https://github.com/user-attachments/assets/db41a381-62fc-429f-ab84-a93cbf1dd606" />

<img width="2560" height="1440" alt="Screenshot 2026-03-19 at 7 02 52 PM (2)" src="https://github.com/user-attachments/assets/7b730e23-2497-46dd-b099-62d8785938e4" />

<img width="2560" height="1440" alt="Screenshot 2026-03-19 at 7 03 08 PM (2)" src="https://github.com/user-attachments/assets/5dbec9b7-1495-494f-812b-035bfcb22d86" />

<img width="2560" height="1440" alt="Screenshot 2026-03-19 at 7 03 10 PM (2)" src="https://github.com/user-attachments/assets/2c9d9eb8-84fc-44ad-ad68-6a10ab00b4a5" />

<img width="2560" height="1440" alt="Screenshot 2026-03-19 at 7 03 12 PM (2)" src="https://github.com/user-attachments/assets/c40e1e3c-bdee-433c-b2bc-177519cf1057" />

<img width="2560" height="1440" alt="Screenshot 2026-03-19 at 7 03 16 PM (2)" src="https://github.com/user-attachments/assets/d64561ca-ff8a-45a7-b303-605421e95ba3" />

<img width="2560" height="1440" alt="Screenshot 2026-03-19 at 7 03 19 PM (2)" src="https://github.com/user-attachments/assets/ade70f20-dbdb-46b4-8381-8cd45066f50e" />

<img width="2560" height="1440" alt="Screenshot 2026-03-19 at 7 03 22 PM (2)" src="https://github.com/user-attachments/assets/0c9b3c99-686a-4a43-9dff-bc4c11055c96" />






