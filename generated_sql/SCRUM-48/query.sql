-- Databricks notebook source
-- Generated for: SCRUM-48
-- Merged from multiple query sources
--
-- Query 1: Tamsyn Lofts_transformation
--   Purpose: Transform and load data into Tamsyn Lofts
-- Query 2: Version update By_transformation
--   Purpose: Transform and load data into Version update By
--

WITH tamsyn_lofts_transformation as (
-- Query: Tamsyn Lofts_transformation
-- Purpose: Transform and load data into 'Tamsyn Lofts'
-- Query Type: SELECT

WITH
  _source_tamsyn_lofts_0 AS (
SELECT
  CAST(NULL AS STRING) AS `Changed to non mandatory`,
  CAST(NULL AS STRING) AS `Added`,
  CAST(NULL AS STRING) AS `Changed to mandatory`,
  CAST(NULL AS STRING) AS `Definition update`,
  CAST(NULL AS STRING) AS `Updated Field Name`
FROM (SELECT 1) AS dummy
  ),
  _source_tamsyn_lofts_1 AS (
SELECT
  CAST(NULL AS STRING) AS added,
  CAST(NULL AS STRING) AS updated_field_name,
  CAST(NULL AS STRING) AS changed_to_mandatory,
  CAST(NULL AS STRING) AS definition_update,
  CAST(NULL AS STRING) AS changed_to_non_mandatory
FROM (SELECT 1) AS dummy
  ),
  _source_tamsyn_lofts_2 AS (
SELECT
  CAST(NULL AS STRING) AS added
FROM True
  ),
  _transformed AS (
  SELECT
    `Changed to non mandatory` AS `Changed to non mandatory`,
    `Added` AS `Added`,
    `Changed to mandatory` AS `Changed to mandatory`,
    `Definition update` AS `Definition update`,
    `Updated Field Name` AS `Updated Field Name`,
    added AS added,
    updated_field_name AS updated_field_name,
    changed_to_mandatory AS changed_to_mandatory,
    definition_update AS definition_update,
    changed_to_non_mandatory AS changed_to_non_mandatory
  FROM _source_tamsyn_lofts_2
  )
SELECT * FROM _transformed
),
version_update_by_transformation as (
-- Query: Version update By_transformation
-- Purpose: Transform and load data into 'Version update By'
-- Query Type: SELECT

WITH
  _source_version_update_by_0 AS (
SELECT
  CAST(NULL AS STRING) AS change_desc
FROM is_primary_key
  ),
  _transformed AS (
  SELECT
    change_desc AS change_desc
  FROM _source_version_update_by_0
  )
SELECT * FROM _transformed
)
SELECT * FROM tamsyn_lofts_transformation UNION ALL
SELECT * FROM version_update_by_transformation