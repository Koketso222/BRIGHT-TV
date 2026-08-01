-- Databricks notebook source
-- Inspecting our table - find out what is in the table columns 
SELECT *
FROM workspace.default.viewership
LIMIT 10;

-- Applying the DATE FUNCTIONS, they allow us to extract days, months, years YYYY-MM-DD  (RecordDate2)
SELECT
    RecordDate2,
    TO_DATE(RecordDate2) AS watch_date -- TO-DATE function helps convert a timestamp into a date YYYY-MM-DD
    FROM workspace.default.viewership;

-- Extracting the dates using DATE Functions (year, months, day)
SELECT 
    UserID0,
    RecordDate2,
    TO_DATE(RecordDate2) AS watch_date, -- Convert a string into a date YYYY-MM=-DD
    DAYNAME(TO_DATE(RecordDate2))AS day_name, -- Extract the day name 
    MONTHNAME(TO_DATE(RecordDate2)) AS month_name, -- Extracts the month name
    YEAR(TO_DATE(RecordDate2)) AS event_year, -- Extracts the year value
    DAY(TO_DATE(RecordDate2)) AS event_day -- Extracts the day value 
FROM workspace.default.viewership;

-- Creating a temporary table/view - helps us analyze subscribers/viewing pattern/trend
CREATE OR REPLACE TEMPORARY TABLE processed_viewership AS(
    SELECT
        COUNT(DISTINCT UserID0) AS number_of_subs,
        RecordDate2,
        TO_DATE(RecordDate2) AS watch_date,
        DAYNAME(TO_DATE(RecordDate2)) AS day_name,
        CASE 
            WHEN DAYNAME(TO_DATE(RecordDate2)) IN ('Sat', 'Sun') THEN '02. Weekend'
            ELSE '01. Weekday'
            END AS day_classification,
            MONTHNAME(TO_DATE(RecordDate2)) AS month_name,
            YEAR(TO_DATE(RecordDate2)) AS event_year, 
            DAY(TO_DATE(RecordDate2)) AS event_day
    FROM workspace.default.viewership 
    WHERE UserID0 IS NOT NULL
    GROUP BY ALL
    ORDER BY watch_date DESC
);

-- How many people are watching Weekdays and Weekends
SELECT SUM (number_of_subs) AS subs,
        day_classification
FROM processed_viewership
Group BY day_classification;

-- Inspect the temporary table 
SELECT*
FROM  processed_viewership;