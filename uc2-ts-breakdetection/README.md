# UC2: Forest Phenology/Break Detection

Use case for implemenation of machin learning with an R UDF. Available with notebook and executable at openEO backend.  

## Description
This use case shows how R UDFs are used to do advanced time series modelling which is not available through native openEO processes. 
In this use case the `bfast` break detection method is chosen to detect breaks in forested areas. It demonstrates a blue-print how to apply
time series modelling on  a single pixel time series. Other methods could also be used by replacing the function in the UDF, e.g. for phenology analysis 
or time series smoothing.

## User Guide

* Create the process graph for preparing your NDVI time series

* How to write the UDF

* How to insert the UDF into the process graph


## Dependencies

* R version
* RStudio version
* all packages and versions
