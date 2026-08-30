-- Databricks notebook source
-- Code from today's class from the Notebook. Please fix the spellings, etc

SELECT *
FROM workspace.default.user_profiles;

-- CHECKING FOR DUPLICATES INFORMAL WAY--
SELECT COUNT (DISTINCT UserID) AS Subs
FROM workspace.default.user_profiles;

-- CHECKING FOR DUPLICATES FORMAL WAY --
SELECT COUNT(*),
       UserID
FROM workspace.default.user_profiles
GROUP BY UserID
HAVING COUNT(*) > 1;

-- INSPECTING OUR GENDER COLUMN--
SELECT DISTINCT Gender
FROM workspace.default.user_profiles;

-- CLEANING THE GENDER COLUMN USING CASE STATEMENT --
SELECT DISTINCT
            CASE 
                WHEN Gender = 'None' THEN 'unknown'
                WHEN Gender = ' ' THEN 'unknown'
                WHEN Gender IS NULL THEN 'unknown'
            ELSE Gender
            END AS Sex
FROM workspace.default.user_profiles;

SELECT *
FROM workspace.default.user_profiles;

-- INSPECTING THE RACE COLUMN --
SELECT DISTINCT Race
FROM workspace.default.user_profiles;

-- CLEANING THE RACE COLUMN USING CASE STATEMENT or standazing then unknown race --
SELECT DISTINCT
            CASE 
                WHEN Race = 'None' THEN 'unknown'
                WHEN Race = ' ' THEN 'unknown'
                WHEN Race = 'other' THEN 'unknown'
                WHEN Race IS NULL THEN 'unknown'
            ELSE Race
            END AS Ethnicity
FROM workspace.default.user_profiles;

-- i want to understand my data, i want to know how many viwers are from each race as well as the unknowns--

SELECT COUNT(DISTINCT userid) AS Subs,
            CASE 
                WHEN Race = 'None' THEN 'unknown'
                WHEN Race = ' ' THEN 'unknown'
                WHEN Race = 'other' THEN 'unknown'
                WHEN Race IS NULL THEN 'unknown'
            ELSE Race
            END AS Ethnicity
FROM workspace.default.user_profiles
GROUP BY Ethnicity;

-- province checks --
SELECT DISTINCT Province
FROM workspace.default.user_profiles;

-- CLEANING THE PROVINCE COLUMN --
SELECT DISTINCT
            CASE 
                WHEN Province = 'None' THEN 'Unclassified'
                WHEN Province = ' ' THEN 'Unclassified'
                WHEN Province = 'other' THEN 'Unclassified'
                WHEN Province IS NULL THEN 'Unclassified'
            ELSE Province
            END AS REGION
FROM workspace.default.user_profiles;


-- Age checks
SELECT MIN(age) AS Min_age, 
       MAX(age) AS Max_age, 
       AVG(age) AS Mean_age 
From workspace.default.user_profiles;

SELECT DISTINCT 
      CASE 
          WHEN Age = 0 THEN 'infant'
          WHEN Age BETWEEN 1 AND 12 THEN 'Kids'
          WHEN Age BETWEEN 13 AND 17 THEN 'youth'
          WHEN Age BETWEEN 18 AND 35 THEN 'youth Adults'
          WHEN Age BETWEEN 36 AND 50 THEN 'Adults'
          WHEN Age > 50 AND Age<=60 THEN 'Elder'
          WHEN Age > 60 THEN 'Pensioner'
    END AS Age_group
From workspace.default.user_profiles;


---------------------------------------------------
--Temporary table
---------------------------------------------------
CREATE OR REPLACE TEMPORARY TABLE processed_user_profiles As 
(SELECT 
     UserID,
        Email,
        CASE 
            WHEN 'Email' IS NOT NULL THEN 1
            WHEN 'Email'<> ' ' THEN 1
            ELSE 0
        END AS email_flag,

        CASE 
            WHEN 'Social Media Handle' IS NOT NULL THEN 1
            ELSE 0
        END AS Social_media_handle_flag,

        CASE
            WHEN gender = 'None' THEN 'unknown'
            WHEN gender = ' ' THEN 'unknown'
            WHEN gender IS NULL THEN 'unknown' 
        ELSE gender 
        END AS sex,
    
        CASE
            WHEN race = 'other' THEN 'unknown'
            WHEN race = ' ' THEN 'unknown'
            WHEN race = 'None' THEN 'unknown'
            WHEN race IS NULL THEN 'unknown'
        ELSE race
        END AS ethnicity,

        CASE
            WHEN Province = 'None' THEN 'Unknown'
            WHEN Province = ' ' THEN 'Unknown'
            WHEN Province IS NULL THEN 'Unknown'
        ELSE Province
        END AS Region,

        CASE
            WHEN Age = 0 THEN 'Infant'
            WHEN Age BETWEEN 1 AND 12 THEN 'Kids'
            WHEN Age BETWEEN 13 AND 19 THEN 'Youth'
            WHEN Age BETWEEN 18 AND 36 THEN 'Young Adult'
            WHEN Age BETWEEN 36 AND 50 THEN 'Adults'
            WHEN Age > 50 AND AGE <=60  THEN 'Elder'
            WHEN Age > 60 THEN 'Pensioner'
        END AS Age_group

FROM workspace.default.user_profiles);

SELECT*
FROM processed_user_profiles;

-------------------------------------------------------------------
--Checking for duplicates
-----------------------------------------------------------------
select count (*) as cnt,
userid
from processed_user_profiles
group by userid
having count(*)>1;