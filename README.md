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

<img width="2560" height="1440" alt="Screenshot 2026-03-20 at 12 53 24 PM (2)" src="https://github.com/user-attachments/assets/d857c002-85fd-4da7-b647-23a802a04192" />

<img width="2560" height="1440" alt="Screenshot 2026-03-20 at 12 58 33 PM (2)" src="https://github.com/user-attachments/assets/d44a074c-6e43-4337-9343-4923984588a6" />

<img width="2560" height="1440" alt="Screenshot 2026-03-20 at 12 53 42 PM (2)" src="https://github.com/user-attachments/assets/98bb2478-f23f-4992-926e-161b2897a612" />

<img width="2560" height="1440" alt="Screenshot 2026-03-19 at 7 03 10 PM (2)" src="https://github.com/user-attachments/assets/2c9d9eb8-84fc-44ad-ad68-6a10ab00b4a5" />

<img width="2560" height="1440" alt="Screenshot 2026-03-20 at 1 22 36 PM (2)" src="https://github.com/user-attachments/assets/04278142-7ce0-47c0-9af1-99fdeee5eb8d" />

<img width="2560" height="1440" alt="Screenshot 2026-03-20 at 1 02 26 PM (2)" src="https://github.com/user-attachments/assets/36cfa265-0d9a-4116-9204-5f061a4b5666" />

<img width="2560" height="1440" alt="Screenshot 2026-03-20 at 12 54 03 PM (2)" src="https://github.com/user-attachments/assets/17775b4d-2425-410d-b25e-ede253a9be40" />

<img width="2560" height="1440" alt="Screenshot 2026-03-20 at 12 54 07 PM (2)" src="https://github.com/user-attachments/assets/5309cbcc-cc3b-4161-856b-6a6f2001d2f0" />




