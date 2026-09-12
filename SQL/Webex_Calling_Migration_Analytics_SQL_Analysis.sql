-- ============================================================
-- Webex Calling Migration Analytics
-- SQL Analysis
-- All queries validated against the uploaded cleaned datasets.
-- ============================================================

-- 1. DATA QUALITY
SELECT 'sites' AS table_name, COUNT(*) AS row_count FROM sites
UNION ALL SELECT 'users', COUNT(*) FROM users
UNION ALL SELECT 'devices', COUNT(*) FROM devices
UNION ALL SELECT 'migration_tracking', COUNT(*) FROM migration_tracking
UNION ALL SELECT 'incidents', COUNT(*) FROM incidents;

SELECT 'sites' AS table_name, COUNT(*) - COUNT(DISTINCT site_id) AS duplicate_ids FROM sites
UNION ALL SELECT 'users', COUNT(*) - COUNT(DISTINCT user_id) FROM users
UNION ALL SELECT 'devices', COUNT(*) - COUNT(DISTINCT device_id) FROM devices
UNION ALL SELECT 'migration_tracking', COUNT(*) - COUNT(DISTINCT migration_id) FROM migration_tracking
UNION ALL SELECT 'incidents', COUNT(*) - COUNT(DISTINCT incident_id) FROM incidents;

SELECT SUM(CASE WHEN site_id IS NULL OR TRIM(site_id)='' THEN 1 ELSE 0 END) AS missing_site_id FROM sites;
SELECT SUM(CASE WHEN user_id IS NULL OR TRIM(user_id)='' THEN 1 ELSE 0 END) AS missing_user_id,
       SUM(CASE WHEN site_id IS NULL OR TRIM(site_id)='' THEN 1 ELSE 0 END) AS missing_site_id FROM users;
SELECT SUM(CASE WHEN device_id IS NULL OR TRIM(device_id)='' THEN 1 ELSE 0 END) AS missing_device_id,
       SUM(CASE WHEN user_id IS NULL OR TRIM(user_id)='' THEN 1 ELSE 0 END) AS missing_user_id,
       SUM(CASE WHEN site_id IS NULL OR TRIM(site_id)='' THEN 1 ELSE 0 END) AS missing_site_id FROM devices;
SELECT SUM(CASE WHEN migration_id IS NULL OR TRIM(migration_id)='' THEN 1 ELSE 0 END) AS missing_migration_id,
       SUM(CASE WHEN site_id IS NULL OR TRIM(site_id)='' THEN 1 ELSE 0 END) AS missing_site_id FROM migration_tracking;
SELECT SUM(CASE WHEN incident_id IS NULL OR TRIM(incident_id)='' THEN 1 ELSE 0 END) AS missing_incident_id,
       SUM(CASE WHEN site_id IS NULL OR TRIM(site_id)='' THEN 1 ELSE 0 END) AS missing_site_id FROM incidents;

-- 2. OVERALL MIGRATION KPIs
SELECT COUNT(DISTINCT site_id) AS total_sites, SUM(users_planned) AS users_planned,
       SUM(users_migrated) AS users_migrated, SUM(devices_planned) AS devices_planned,
       SUM(devices_migrated) AS devices_migrated,
       ROUND(100.0*SUM(users_migrated)/NULLIF(SUM(users_planned),0),2) AS user_migration_pct,
       ROUND(100.0*SUM(devices_migrated)/NULLIF(SUM(devices_planned),0),2) AS device_migration_pct
FROM migration_tracking;

SELECT COUNT(*) AS total_sites,
       SUM(CASE WHEN site_status='Migrated' THEN 1 ELSE 0 END) AS migrated_sites,
       ROUND(100.0*SUM(CASE WHEN site_status='Migrated' THEN 1 ELSE 0 END)/COUNT(*),2) AS site_migration_pct
FROM sites;

SELECT migration_status, COUNT(*) AS users,
       ROUND(100.0*COUNT(*)/SUM(COUNT(*)) OVER (),2) AS percentage
FROM users GROUP BY migration_status ORDER BY users DESC;

SELECT provisioning_status, COUNT(*) AS users
FROM users GROUP BY provisioning_status ORDER BY users DESC;

-- 3. SITE PERFORMANCE
SELECT s.site_id,s.site_name,s.city,s.state,s.site_status,
       m.wave,m.users_planned,m.users_migrated,m.user_migration_pct,
       m.devices_planned,m.devices_migrated,m.device_migration_pct,
       m.uat_status,m.deployment_status
FROM sites s LEFT JOIN migration_tracking m ON s.site_id=m.site_id
ORDER BY m.user_migration_pct DESC;

SELECT s.site_id,s.site_name,s.city,s.state,
       m.users_planned,m.users_migrated,m.user_migration_pct
FROM sites s JOIN migration_tracking m ON s.site_id=m.site_id
ORDER BY m.user_migration_pct ASC LIMIT 10;

SELECT s.site_id,s.site_name,s.city,s.state,
       m.devices_planned,m.devices_migrated,m.device_migration_pct
FROM sites s JOIN migration_tracking m ON s.site_id=m.site_id
ORDER BY m.device_migration_pct ASC LIMIT 10;

SELECT migration_status, COUNT(*) AS users, 
       ROUND(100.0*COUNT(*)/SUM(COUNT(*)) OVER (),2) AS pct
FROM users GROUP BY migration_status ORDER BY users DESC;

-- 4. MIGRATION WAVES AND STATUS
SELECT wave,COUNT(*) AS sites,SUM(users_planned) AS users_planned,
       SUM(users_migrated) AS users_migrated,
       ROUND(100.0*SUM(users_migrated)/NULLIF(SUM(users_planned),0),2) AS user_migration_pct,
       SUM(devices_planned) AS devices_planned,SUM(devices_migrated) AS devices_migrated,
       ROUND(100.0*SUM(devices_migrated)/NULLIF(SUM(devices_planned),0),2) AS device_migration_pct
FROM migration_tracking GROUP BY wave ORDER BY wave;

SELECT wave,uat_status,deployment_status,COUNT(*) AS sites
FROM migration_tracking GROUP BY wave,uat_status,deployment_status ORDER BY wave;

SELECT u.migration_status,s.migration_wave,COUNT(*) AS users
FROM users u JOIN sites s ON u.site_id=s.site_id
GROUP BY u.migration_status,s.migration_wave ORDER BY s.migration_wave,u.migration_status;

-- 5. USER ANALYSIS
SELECT department,COUNT(DISTINCT user_id) AS users
FROM users GROUP BY department ORDER BY users DESC;

SELECT department,migration_status,COUNT(DISTINCT user_id) AS users
FROM users GROUP BY department,migration_status ORDER BY department,users DESC;

SELECT department,COUNT(*) AS total_users,
       SUM(CASE WHEN migration_status='Migrated' THEN 1 ELSE 0 END) AS migrated_users,
       ROUND(100.0*SUM(CASE WHEN migration_status='Migrated' THEN 1 ELSE 0 END)/COUNT(*),2) AS migration_pct
FROM users GROUP BY department ORDER BY migration_pct DESC;

SELECT license_type,COUNT(*) AS users,
       SUM(CASE WHEN migration_status='Migrated' THEN 1 ELSE 0 END) AS migrated_users,
       ROUND(100.0*SUM(CASE WHEN migration_status='Migrated' THEN 1 ELSE 0 END)/COUNT(*),2) AS migration_pct
FROM users GROUP BY license_type ORDER BY migration_pct DESC;

SELECT device_type,COUNT(*) AS users,
       SUM(CASE WHEN migration_status='Migrated' THEN 1 ELSE 0 END) AS migrated_users,
       ROUND(100.0*SUM(CASE WHEN migration_status='Migrated' THEN 1 ELSE 0 END)/COUNT(*),2) AS migration_pct
FROM users GROUP BY device_type ORDER BY migration_pct DESC;

-- 6. DEVICE ANALYSIS
SELECT device_type,COUNT(DISTINCT device_id) AS devices
FROM devices GROUP BY device_type ORDER BY devices DESC;

SELECT device_type,registration_status,COUNT(*) AS devices
FROM devices GROUP BY device_type,registration_status ORDER BY device_type,devices DESC;

SELECT device_type,provisioning_status,COUNT(*) AS devices
FROM devices GROUP BY device_type,provisioning_status ORDER BY device_type,devices DESC;

SELECT d.device_type,
       COUNT(*) AS total_devices,
       SUM(CASE WHEN u.migration_status='Migrated' THEN 1 ELSE 0 END) AS devices_owned_by_migrated_users,
       ROUND(100.0*SUM(CASE WHEN u.migration_status='Migrated' THEN 1 ELSE 0 END)/COUNT(*),2) AS pct_owned_by_migrated_users
FROM devices d LEFT JOIN users u ON d.user_id=u.user_id
GROUP BY d.device_type ORDER BY pct_owned_by_migrated_users DESC;

SELECT site_id,COUNT(DISTINCT device_id) AS devices
FROM devices GROUP BY site_id ORDER BY devices DESC;

-- 7. INCIDENT ANALYSIS
SELECT COUNT(*) AS total_incidents FROM incidents;

SELECT severity,COUNT(*) AS incidents,
       ROUND(100.0*COUNT(*)/SUM(COUNT(*)) OVER (),2) AS incident_pct
FROM incidents GROUP BY severity ORDER BY incidents DESC;

SELECT status,COUNT(*) AS incidents,
       ROUND(100.0*COUNT(*)/SUM(COUNT(*)) OVER (),2) AS incident_pct
FROM incidents GROUP BY status ORDER BY incidents DESC;

SELECT category,COUNT(*) AS incidents
FROM incidents GROUP BY category ORDER BY incidents DESC;

SELECT issue_type,COUNT(*) AS incidents
FROM incidents GROUP BY issue_type ORDER BY incidents DESC;

SELECT device_type,COUNT(*) AS incidents
FROM incidents GROUP BY device_type ORDER BY incidents DESC;

SELECT i.site_id,s.site_name,COUNT(*) AS incidents
FROM incidents i LEFT JOIN sites s ON i.site_id=s.site_id
GROUP BY i.site_id,s.site_name ORDER BY incidents DESC;

SELECT i.site_id,s.site_name,COUNT(*) AS incidents
FROM incidents i LEFT JOIN sites s ON i.site_id=s.site_id
GROUP BY i.site_id,s.site_name ORDER BY incidents DESC LIMIT 20;

-- 8. INCIDENT RESOLUTION
SELECT severity,COUNT(*) AS incidents,
       ROUND(AVG(resolution_time_hours),2) AS avg_resolution_hours,
       ROUND(MIN(resolution_time_hours),2) AS min_resolution_hours,
       ROUND(MAX(resolution_time_hours),2) AS max_resolution_hours
FROM incidents GROUP BY severity ORDER BY avg_resolution_hours DESC;

SELECT category,COUNT(*) AS incidents,
       ROUND(AVG(resolution_time_hours),2) AS avg_resolution_hours
FROM incidents GROUP BY category ORDER BY avg_resolution_hours DESC;

SELECT issue_type,COUNT(*) AS incidents,
       ROUND(AVG(resolution_time_hours),2) AS avg_resolution_hours
FROM incidents GROUP BY issue_type ORDER BY avg_resolution_hours DESC;

SELECT status,COUNT(*) AS incidents,
       ROUND(AVG(resolution_time_hours),2) AS avg_resolution_hours
FROM incidents GROUP BY status ORDER BY incidents DESC;

-- 9. MIGRATION + INCIDENT ANALYSIS
SELECT s.site_id,s.site_name,m.user_migration_pct,
       m.device_migration_pct,COUNT(i.incident_id) AS incidents
FROM sites s
LEFT JOIN migration_tracking m ON s.site_id=m.site_id
LEFT JOIN incidents i ON s.site_id=i.site_id
GROUP BY s.site_id,s.site_name,m.user_migration_pct,m.device_migration_pct
ORDER BY incidents DESC;

SELECT s.site_id,s.site_name,m.user_migration_pct,
       COUNT(i.incident_id) AS incidents,
       ROUND(AVG(i.resolution_time_hours),2) AS avg_resolution_hours
FROM sites s JOIN migration_tracking m ON s.site_id=m.site_id
LEFT JOIN incidents i ON s.site_id=i.site_id
GROUP BY s.site_id,s.site_name,m.user_migration_pct
ORDER BY m.user_migration_pct ASC,incidents DESC;

WITH site_incidents AS (
    SELECT site_id, COUNT(*) AS incidents
    FROM incidents
    GROUP BY site_id
)
SELECT m.deployment_status,
       COUNT(DISTINCT m.site_id) AS sites,
       SUM(m.users_migrated) AS users_migrated,
       COALESCE(SUM(si.incidents),0) AS incidents,
       ROUND(1.0*COALESCE(SUM(si.incidents),0)/NULLIF(COUNT(DISTINCT m.site_id),0),2) AS avg_incidents_per_site
FROM migration_tracking m
LEFT JOIN site_incidents si ON m.site_id=si.site_id
GROUP BY m.deployment_status
ORDER BY incidents DESC;

SELECT m.deployment_status,i.severity,COUNT(*) AS incidents
FROM migration_tracking m
JOIN incidents i ON m.site_id=i.site_id
GROUP BY m.deployment_status,i.severity
ORDER BY m.deployment_status,incidents DESC;

-- 10. MIGRATION DATE/TREND
SELECT substr(migration_date,1,7) AS migration_month,
       COUNT(*) AS sites,SUM(users_migrated) AS users_migrated,
       SUM(devices_migrated) AS devices_migrated
FROM migration_tracking
GROUP BY substr(migration_date,1,7) ORDER BY migration_month;

SELECT migration_date,COUNT(*) AS sites,SUM(users_migrated) AS users_migrated,
       SUM(devices_migrated) AS devices_migrated
FROM migration_tracking GROUP BY migration_date ORDER BY migration_date;

SELECT migration_wave,COUNT(*) AS sites,
       ROUND(AVG(julianday(actual_migration_date)-julianday(planned_migration_date)),2) AS avg_days_from_plan
FROM sites WHERE actual_migration_date IS NOT NULL
GROUP BY migration_wave ORDER BY migration_wave;

-- 11. SITE RANKINGS
WITH x AS (
 SELECT s.site_id,s.site_name,m.user_migration_pct,m.device_migration_pct
 FROM sites s JOIN migration_tracking m ON s.site_id=m.site_id
)
SELECT *,RANK() OVER(ORDER BY user_migration_pct DESC) AS user_migration_rank
FROM x ORDER BY user_migration_rank;

WITH x AS (
 SELECT s.site_id,s.site_name,COUNT(i.incident_id) AS incidents
 FROM sites s LEFT JOIN incidents i ON s.site_id=i.site_id
 GROUP BY s.site_id,s.site_name
)
SELECT *,RANK() OVER(ORDER BY incidents DESC) AS incident_rank
FROM x ORDER BY incident_rank;

-- 12. EXECUTIVE SUMMARY
SELECT
 (SELECT COUNT(*) FROM sites) AS total_sites,
 (SELECT COUNT(*) FROM users) AS total_users,
 (SELECT COUNT(*) FROM devices) AS total_devices,
 (SELECT COUNT(*) FROM incidents) AS total_incidents,
 (SELECT SUM(users_planned) FROM migration_tracking) AS users_planned,
 (SELECT SUM(users_migrated) FROM migration_tracking) AS users_migrated,
 (SELECT ROUND(100.0*SUM(users_migrated)/NULLIF(SUM(users_planned),0),2) FROM migration_tracking) AS user_migration_pct,
 (SELECT SUM(devices_planned) FROM migration_tracking) AS devices_planned,
 (SELECT SUM(devices_migrated) FROM migration_tracking) AS devices_migrated,
 (SELECT ROUND(100.0*SUM(devices_migrated)/NULLIF(SUM(devices_planned),0),2) FROM migration_tracking) AS device_migration_pct,
 (SELECT ROUND(AVG(resolution_time_hours),2) FROM incidents) AS avg_incident_resolution_hours;
