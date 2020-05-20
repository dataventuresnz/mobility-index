# Mobility index

Data Ventures uses aggregated and anonymised cellphone data to estimate the amount of mobility within regional councils, or based on categories such as recreation, retail, workplace areas. This README briefly outlines how we developed our mobility index and the repository includes our code for data released on mobility for a week in lockdown relative to the week before, or relative to a similar period in 2019.

**NB:** If you are looking for the deprecated methodology used in the easter report, the repo can still be found [here](https://github.com/dataventuresnz/easter-mobility-index).

## Overview of the repository

A lot of the method is now implemented within SQL so we have included two sample scripts which give suffcient information around the business rules we are implementing while cleaning and aggregating the data. The `baseline_comparisons.R` script then uses some SQL wrappers to pull the data into R and estimate an overall mobility measure.

## Background to the cellphone data

Our data is built off counts of people each hour at a Statistical Area Level Two  geography (SA2; a small neighbourhood size). Estimates are further segmented based on whether the counts of people are people who normally reside in the neighbourhood (local residents), or people who reside outside a given neighbourhood (domestic visitors). As an example, you would normally be considered local to your home neighbourhood, but you would be considered a domestic visitor when you visit another neighbourhood to shop at the supermarket.

We identified six categories which we report alongside regional council data: Retail, Transit, Residential, Tourism, Workplace, and Recreational categories. These categories were estimated using unsupervised time series clustering on SA2 level data and then qualitatively labelled based on subsequent exploratory analysis. We then aggregated up counts across the SA2s to get a total measure for each category.

## Converting aggregated counts to create a mobility index

* We remove oceanic or inlet SA2s which sometimes have people misallocated into waterbodies which adds noise to the data.

* We remove estimates from 2am until and including 4am because we determined that estimates over this period have reasonable noise due to a reduced likelihood of devices to show activity.

* We then subtract the minimum population from the maximum population count in a given day for an SA2.

* We sum the deltas' in each SA2 for each category or regional council to get an overall mobility measure for the area.

* We calculate the percentage difference between each day of the observed week and an average week from 2019 (we then use this for our mobility plots).

* We then average the seven daily percentage differences to get a single mobility measure for a week in each region or category (this is used for our tables at the end of each report).
