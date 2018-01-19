<!-- README.md is generated from README.Rmd. Please edit that file -->
statnettapi
===========

The goal of statnettapi is to get data from their [API](http://driftsdata.statnett.no/restapi)

Installation
------------

Install from github using the devtools package.


    devtools::install_github("krose/statnettapi")

Examples
--------

This is a basic example which shows you how to solve a common problem:

``` r

library(statnettapi)
library(tidyverse)
#> -- Attaching packages ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- tidyverse 1.2.1 --
#> v ggplot2 2.2.1     v purrr   0.2.4
#> v tibble  1.3.4     v dplyr   0.7.4
#> v tidyr   0.7.2     v stringr 1.2.0
#> v readr   1.1.1     v forcats 0.2.0
#> -- Conflicts ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- tidyverse_conflicts() --
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()

glimpse(stat_physical_flow(from_date = as.Date("2018-01-17")))
#> Observations: 3
#> Variables: 2
#> $ date                       <dttm> 2018-01-16 23:00:00, 2018-01-17 23...
#> $ physical_flow_net_exchange <dbl> 31586.97, 46933.25, 33475.53
glimpse(stat_primary_reserves_day(local_date = as.Date("2018-01-17")))
#> Observations: 480
#> Variables: 4
#> $ local_date <date> 2018-01-17, 2018-01-17, 2018-01-17, 2018-01-17, 20...
#> $ hour       <chr> "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", ...
#> $ variable   <chr> "NO1-FNR-Price", "NO1-FNR-Price", "NO1-FNR-Price", ...
#> $ value      <chr> "14", "14", "14", "14", "21", "17", "14", "18", "17...
glimpse(stat_production_consumption(from_date = as.Date("2018-01-01")))
#> Observations: 19
#> Variables: 3
#> $ date        <dttm> 2017-12-31 23:00:00, 2018-01-01 23:00:00, 2018-01...
#> $ production  <int> 343282, 489850, 486955, 527653, 511581, 507867, 43...
#> $ consumption <int> 420642, 453375, 470348, 466056, 470881, 464445, 46...
glimpse(stat_production_consumption_latest_overview())
#> Observations: 56
#> Variables: 4
#> $ measured_at <dttm> 2018-01-19 08:38:00, 2018-01-19 08:38:00, 2018-01...
#> $ variable    <chr> "ProductionData", "ProductionData", "ProductionDat...
#> $ country     <chr> "SE", "DK", "NO", "FI", "EE", "LT", "LV", "SE", "D...
#> $ value       <int> NA, NA, NA, NA, NA, 522, NA, NA, NA, NA, NA, NA, N...
glimpse(stat_frequency_minute(from_date = as.Date("2018-01-18")))
#> Observations: 2,019
#> Variables: 2
#> $ date        <dttm> 2018-01-17 23:00:00, 2018-01-17 23:01:00, 2018-01...
#> $ measurement <dbl> 50.092, 50.014, 50.031, 50.008, 50.023, 50.038, 49...
glimpse(stat_frequency_second(from_date = as.Date("2018-01-18")))
#> Observations: 3,588
#> Variables: 2
#> $ date        <dttm> 2018-01-19 07:39:32, 2018-01-19 07:39:33, 2018-01...
#> $ measurement <dbl> 50.033, 50.033, 50.033, 50.033, 50.033, 50.033, 50...
glimpse(stat_physical_flow_map())
#> Observations: 36
#> Variables: 4
#> $ OutAreaElspotId <chr> "DE", "DK1", "DK1", "DK2", "DK2", "DK2", "EE",...
#> $ InAreaElspotId  <chr> "SE4", "DE", "SE3", "DE", "DK1", "SE4", "RU", ...
#> $ Value           <dbl> 0.6931, -220.1175, 170.6518, -600.0800, -404.2...
#> $ MeasureDate     <dttm> 2018-01-19 08:39:00, 2018-01-19 08:39:00, 201...
```
