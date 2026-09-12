# Webex Calling Migration Analytics

A modern, single-screen analytics dashboard for monitoring **Webex
Calling migration progress, users, devices, sites, and operational
readiness**.

The dashboard is designed for support, migration, and operations teams
that need a quick executive-level view of migration progress without
scrolling.

## Dashboard Preview

![Webex Calling Migration Analytics Dashboard](Screenshot/Screenshot%202026-09-12%20054029.png)

> **Preview:** The image above shows the current dashboard layout and
> visualization design.

## Overview

The **Webex Calling Migration Analytics** dashboard provides a
consolidated view of:

-   Overall migration progress
-   Planned vs. migrated users
-   Planned vs. migrated devices
-   User migration completion
-   Device migration completion
-   Site-level migration performance
-   Migration activity over time
-   Site migration status
-   Key Business Insights
-   Migration filtering by wave, site status, and deployment status

The layout is optimized to keep the major migration metrics and charts
visible on a **single desktop screen**.

## Key Metrics

  Metric                      Current Value
  ------------------------- ---------------
  Total Sites                            35
  Planned Users                       3,174
  Migrated Users                      2,868
  User Migration                      90.4%
  Planned Devices                     3,658
  Migrated Devices                    3,302
  Device Migration                    90.3%
  Total Incidents                     5,000
  Average Resolution Time        4.31 hours

## Visualizations

### 1. User & Device Migration Over Time

A line chart showing monthly migration activity for:

-   Users migrated
-   Devices migrated

This helps identify migration peaks, slower periods, and changes in
migration velocity.

### 2. User Migration Progress

A doughnut chart showing the percentage of planned users who have
completed migration.

**Current view:** 90.4% migrated.

### 3. Top 10 Sites by Users Migrated

A horizontal bar chart ranking the sites with the highest number of
migrated users.

This provides a quick way to identify the sites contributing most to
overall migration progress.

### 4. Device Migration Progress

A doughnut chart showing planned devices versus migrated devices.

**Current view:** 90.3% migrated.

### 5. Site Migration Status

A horizontal bar chart showing the current distribution of sites across
migration states:

-   Migrated
-   In Progress
-   Ready
-   Blocked

## Filters

A reset option is also included to return the dashboard to the default
view.

## Tools Used

-   SQL
-   Power BI
-   Python
-   Excel
-   Data Cleaning and Transformation
-   Data Visualization

The dashboard includes interactive filters for:

-   **Migration Wave**
-   **Site Status**
-   **Deployment Status**

A **Reset Filters** button returns the selections to `All`.

## Key Business Insights

The dashboard includes a dedicated **Key Business Insights** section at
the bottom.

Current insights include:

-   **Migration:** 2,868 of 3,174 planned users are migrated,
    representing 90.4% completion.
-   **Device rollout:** 3,302 of 3,658 planned devices are migrated,
    representing 90.3% completion.
-   **Operations:** 5,000 incidents were recorded with an average
    resolution time of 4.31 hours.

## Design Principles

The dashboard was designed with the following goals:

-   Clean enterprise dashboard appearance
-   Single-screen desktop experience
-   Clear separation between chart headers and chart areas
-   No overlapping chart components
-   Centered KPI values
-   Consistent spacing and typography
-   Responsive behavior for smaller screens
-   Easy-to-understand visual hierarchy
-   Executive-friendly summary information

## Jupyter Notebook

The dashboard can be maintained and extended as a **Jupyter Notebook
(`.ipynb`)**.

The notebook can contain:

-   Data loading and preparation
-   Data cleaning and transformation
-   Migration KPI calculations
-   User and device migration analysis
-   Site-level analysis
-   Incident analysis
-   Interactive visualizations
-   Key Business Insights
-   Dashboard presentation

Recommended notebook name:

``` text
webex-calling-migration-analytics.ipynb
```

## Running the Notebook

1.  Open `webex-calling-migration-analytics.ipynb` in Jupyter Notebook,
    JupyterLab, or a compatible notebook environment.
2.  Load the required migration, device, site, and incident datasets.
3.  Run the notebook cells from top to bottom.
4.  Review the generated KPIs, charts, and Key Business Insights.
5.  Update the data source and rerun the notebook when new migration
    data becomes available.

## Project Structure

``` text
webex-calling-migration-analytics/
├── README.md
├── webex-calling-migration-analytics.ipynb
└── webex-calling-migration-analytics-preview.png
```

## Dashboard Layout

``` text
┌─────────────────────────────────────────────────────────────────────┐
│                 WEBEX CALLING MIGRATION ANALYTICS                   │
├─────────────────────────────────────────────────────────────────────┤
│ KPI │ KPI │ KPI │ KPI │ KPI │ KPI                                  │
├────────────┬───────────────────────────────┬────────────────────────┤
│            │ User & Device Migration       │ User Migration Progress │
│  FILTERS   │ Over Time                     │                        │
│            ├───────────────────────────────┼────────────────────────┤
│            │ Top 10 Sites                  │ Device Migration        │
│            │ by Users Migrated             │ Progress │ Site Status  │
├────────────┴───────────────────────────────┴────────────────────────┤
│                         KEY BUSINESS INSIGHTS                        │
└─────────────────────────────────────────────────────────────────────┘
```

## Data Notes

The values displayed in the current dashboard are based on the supplied
dashboard design/reference and are intended to demonstrate the
visualization structure.

For production use, the notebook should be connected to the
organization's actual migration, device, site, and incident data
sources.

## License

This project is intended for internal analytics and dashboard
development purposes. Add your organization's preferred license and
usage terms before public distribution.

## Note

This is a synthetic portfolio project created to demonstrate practical
data analyst skills. Dashboard values and business scenarios are for
demonstration purposes.

## Author

**Sai Teja**

Data Analyst Portfolio Project
