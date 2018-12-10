SELECT COUNT(DISTINCT(utm_campaign)) AS num_campaign
FROM page_visits;

SELECT COUNT(DISTINCT(utm_source)) AS num_source
FROM page_visits;

SELECT DISTINCT(utm_campaign), utm_source
FROM page_visits;

SELECT DISTINCT(page_name)
FROM page_visits;

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) AS first_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
        pv.utm_campaign,
        COUNT(utm_campaign)
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
   GROUP BY 4,3
    ORDER BY 5 DESC;

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) AS last_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT lt.user_id,
    lt.last_touch_at,
    pv.utm_source,
        pv.utm_campaign,
        COUNT(utm_campaign)
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
GROUP BY 4,3
ORDER BY 5 DESC;

SELECT COUNT (DISTINCT user_id)
FROM page_visits
WHERE page_name = '4 - purchase';


WITH last_touch AS (
SELECT user_id,
        MAX(timestamp) AS last_touch_at
FROM page_visits
  where page_name = '4 - purchase'
GROUP BY user_id)
SELECT lt.user_id,
    lt.last_touch_at,
    pv.utm_source,
    pv.utm_campaign,
    COUNT(utm_campaign) AS 'Number of purchases'
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
GROUP BY 4
ORDER BY 5 DESC;

SELECT utm_source,utm_campaign, COUNT(utm_campaign)AS 'Total touches'
FROM page_visits
GROUP BY 2
ORDER BY 3 DESC;

SELECT ft.utm_source as 'Source',ft.utm_campaign 'Campaign',COUNT(ft.user_id) 'Sales'
FROM (WITH last_touch AS (
SELECT user_id,
        MAX(timestamp) AS last_touch_at
FROM page_visits
  where page_name = '4 - purchase'
GROUP BY user_id)
SELECT lt.user_id,
    lt.last_touch_at,
    pv.utm_source,
    pv.utm_campaign,
    COUNT(utm_campaign) 
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
GROUP BY 1
ORDER BY 5 DESC) lt join (WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) AS first_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
        pv.utm_campaign,
        COUNT(utm_campaign)
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
   GROUP BY 1
    ORDER BY 5 DESC) ft on lt.user_id = ft.user_id
    GROUP BY 1
    ORDER BY 3 DESC;



