# UC1 : MACHINE LEARNING LANDCOVER CLASSIFICATION

## Description 

Land use and land cover classification is a basic application that uses machine learning for Earth Observation data. There are numerous models that are used
for this purpose. There are alos a lot of ways to implement a classification form various open source softwares to packages in R and Python.
There are continous efforts in this regard to improve the accuracies of such models and refine thr training samples and features to train the models. 
Various class schemes are also present to provide results of various level of details.
These classification maps can be used to identify temporal changes in such maps generated over the years to specify certain areas of interest where classes
are changing naturally or enthroprogenically. This is important to understand the land surface dynamics and also iportant in cases like resource mangement for 
agriculture areas and urban sprawl. 
Thus this use case shows how R UDFs are used to do advanced time series modelling which is not available through native openEO processes.
This particular use case focusses on implemenation of machine learning with an R UDF. 
It is upto the user to develope from a basic model to a more instensive model based on the application and present training data.
Giving the user the independence to train a model as required and then export and save it as an RDS object, in our examples these models objects are 
uploaded and then called in the UDF from a Github URL.
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

## Extent
### Test
![image](https://user-images.githubusercontent.com/44399454/201882958-537b5ad8-20fa-455d-9b99-c2683879930d.png)

### Bolzano
![image](https://user-images.githubusercontent.com/44399454/201881665-1f4ab6bb-cee5-4111-93a0-80f623d0815d.png)

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
  * data generation
    * 15 sec
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
    * 34000 sec
* openeo_eurac
  * data generation
    * 157 sec
  * with reduce dimension udf
    * 163 sec
  * with reduce dimension udf chunk
    * ~ sec
* openeo_platform
  * processgraph
  
## Results
Comparison of classification results using various processing methods
![image](https://user-images.githubusercontent.com/44399454/201896154-7b7959a2-ff58-49bd-968c-b3e3bc6e6aa5.png)

## Dependencies

* R version
* RStudio version
* all packages and versions
