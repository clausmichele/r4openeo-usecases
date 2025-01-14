# UC1 : MACHINE LEARNING LANDCOVER CLASSIFICATION

## Description 

This use case shows how R UDFs are used to do advanced time series modelling which is not available through native openEO processes.
This particular use case focusses on implemenation of machine learning with an R UDF. 
An already trained model can be called in to the udf and can be deployed on data with all the required features. 
Two tests were done, one with a simple model based on 4 Sentinel-2 bands while the other has a model trained on intensive features extracted from 
all the Sentinel-2 bands and multiple indices. The Corine layer is used in these cases to train the model.
Available with notebook and executable at openEO backend.  

## Experiment 

Four ways of producing the classified results from machine learning models are carried out on two different AOIs. This is mainly done for benchmarking and 
for demonstrating the different ways of interacting with openEO platform, the R-Client and the R-UDF library.

Four ways:

* local_r: The udf is run directly in R
* local_udf: The udf is run on a local instance of the UDF service
* openeo_eurac: The udf is run on Eurac Researchs openEO instance
* openeo_platform: The udf is run on openEO platform (VITO dev backend) 

Two AOIs and models:
* test: A small test area within the province of South Tyrol for small scale testing only with 4 features (Sentinel-2 band 2, 3, 4, 8). 
  95 by 100 pixels (9500 pixels), 0.95 km2.
* Bolzano: A bigger area spatially including a mixture of various classes: artificial lands, forests, vegetation, agricultural area and river etc. 
  This area is also used in the ECO4Alps project to test the classifaction of land use mapping. 910 by 936 pixels (85000 pixels), 8.5 km2.
  Features as similarly used in the ECO4Alps project were extracted using openEO, this was downloaded to process locally in R and the local udf example.

The data set:
* Sentinel-2 L2A
* Cloud masked with SCL
* 10 m resolution

## Timing

### Test

* local_r
  * 0.074 sec 
* local_udf 
  * with reduce dimension udf
    * 6.997 sec
  * with reduce dimension udf chunk
    * 32.857 sec
* openeo_eurac
  * with reduce dimension udf
    * 32 sec
  * with reduce dimension udf chunk
    * 48 sec
* openeo_platform
  * processgraph

### Bolzano

* local_r
  * 16.74 sec 
* local_udf 
  * with reduce dimension udf
    * 17.928 sec
  * with reduce dimension udf chunk
    * 32.857 sec
* openeo_eurac
  * with reduce dimension udf
    * 163 sec
  * with reduce dimension udf chunk
    * ~ sec
* openeo_platform
  * processgraph
  

## Dependencies

* R version
* RStudio version
* all packages and versions
