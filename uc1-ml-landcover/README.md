# UC1 : MACHINE LEARNING LANDCOVER CLASSIFICATION

## Description 
The categorization of landscapes into ecosystems based on their complex functionalities and land cover helps to understand the central biodiversity variables of a natural environment. Key factors such as species composition and their distribution as well as their status or the ecosystem services provided are often linked to a specific ecosystem type and the underlying human impact. The extensive mapping of diverse ecosystems throughout Europe has been accomplished with initiatives such as the CORINE Land Cover Dataset (CLC) regularly updated since 2000. However, extensive land cover datasets are often highly generalized or adapted to a specific thematic interest. At the same time existing ecosystem maps are difficult to apply to mountainous regions given the strong influence of topography, the steady and dispersed cloud cover or the diverse management practices adapted. The combination of machine learning techniques and earth observation data with a regional focus in a mountainous area is a powerful combination to map different ecosystems in higher detail. This use-case is aligned to a planned service “Ecosystem mapping” in the ESA EO4Alps - ECO4Alps proposal, starting in January 2021. The planned collaboration and exchange about input-data and methodological approach will take place with the WP coordinators both from Eurac Research and the Solenix GmbH. The main aim of this activity is to implement a similar setup as the use-case in the ECO4Alps project in an R-based environment. The study area for this use-case will be the extent of the Autonomous province of South Tyrol / Italy (approximately 7400 km2). Therefore, the openEO R-client and R-UDFs are used with the goal of mapping diverse ecosystem classes. These classes will be estimated by a Random Forest (RF) machine learning classifier trained with earth observation imagery from Sentinel-2 MSI as well as ancillary geospatial data such as Digital Elevation Models (DEM) and land cover classification such as the CORINE land cover dataset. The Random Forest classifier used for the mapping of the ecosystem classes is therefore trained locally and applied remotely on an OpenEO back-end using the r-client and R-UDFs. This allows us to showcase a machine learning algorithm applied to spatial mapping using R in combination with the OpenEO initiative. The added value of this use-case is to:

Propose an openEO-based workflow for ecosystem mapping to regional partners
Adjacent development to a scientific activity defined in a regional initiative (ECO4Alps)
Define a detailed showcase to implement machine learning techniques via the openEO R client and R-UDF service

## Data and Extent

The data set:
* Sentinel-2 L2A
* Cloud masked with SCL
* 10 m resolution

Two AOIs and models:
* test: A small test area within the province of South Tyrol for small scale testing only with 4 features (Sentinel-2 band 2, 3, 4, 8). 
  95 by 100 pixels (9500 pixels), 0.95 km2.
* Bolzano: A bigger area spatially including a mixture of various classes: artificial lands, forests, vegetation, agricultural area and river etc. 
  This area is also used in the ECO4Alps project to test the classifaction of land use mapping. 910 by 936 pixels (85000 pixels), 8.5 km2.
  Features as similarly used in the ECO4Alps project were extracted using openEO, this was downloaded to process locally in R and the local udf example.

### Test
![image](https://user-images.githubusercontent.com/44399454/201882958-537b5ad8-20fa-455d-9b99-c2683879930d.png)

### Bolzano
![image](https://user-images.githubusercontent.com/44399454/201881665-1f4ab6bb-cee5-4111-93a0-80f623d0815d.png)

## Method
OpenEO native functions do not allow to train various models for classification where as using the R-UDF's we can use train custom models and change parameters.
It is upto the user to develope from a basic model to a more instensive model based on the application and present training data.
Giving the user the independence to train a model as required and then export and save it as an RDS object, in the examples these models objects are 
uploaded and then called in the UDF from a Github URL.
An already trained model can be called in to the udf and can be deployed on data with all the required features. 
Two tests were done, one with a simple model based on 4 Sentinel-2 bands while the other has a model trained on intensive features extracted from 
all the Sentinel-2 bands and multiple indices. The LUCAS layer is used in these cases to train the model.
The following table shows the band from Sentinel-2 used,

![image](https://user-images.githubusercontent.com/44399454/202458681-12dfd750-1670-417b-a9e8-9c6b0416f275.png)
whereas the next table shows all the features generated from all these Sentinel-2 bands. All these features were used to train the model in this UC.


![image](https://user-images.githubusercontent.com/44399454/202458916-a006009c-639b-4adf-8248-b9fda4864233.png)

## Results
Classifcation was run with various experimental methods and the figure below shows the comparison of classification results using these various methods.
![image](https://user-images.githubusercontent.com/44399454/201896154-7b7959a2-ff58-49bd-968c-b3e3bc6e6aa5.png)

For the validation of the different processing, the results were compared with each other and the table below shows the agreement between the classification runs.


![image](https://user-images.githubusercontent.com/44399454/202462174-642e8abd-3c72-4884-af6f-673c2e947c07.png)

### On the fly calculation on Eurac backend
The results of the use case can be computed directly on the fly on the Eurac backend by using [the process graph](https://github.com/Open-EO/r4openeo-usecases/blob/main/uc1-ml-landcover/eco4alps/openeo_eurac/Eco4alps_udf_OpenEO_Eurac.json). 
This allows interactive and on the fly classification. The process graph includes masking clouds, generating of the feature dataset, then using the already trained model to predict results for the selected extent and finally displaying the results.

![image](https://user-images.githubusercontent.com/44399454/202466490-58c2619a-0409-4987-8139-09fdd46fc236.png)


## Timing
### Experiment 

Four ways of producing the classified results from machine learning models are carried out on two different AOIs. This is mainly done for benchmarking and 
for demonstrating the different ways of interacting with openEO platform, the R-Client and the R-UDF library.

Four ways:

* local_r: The udf is run directly in R
* local_udf: The udf is run on a local instance of the UDF service
* openeo_eurac: The udf is run on Eurac Researchs openEO instance
* openeo_platform: The udf is run on openEO platform (VITO dev backend) 
  
#### Test

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

#### Bolzano

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

## Conclusion
This use case shows how R UDFs are used to do prediction using any trained model varrying from Random Forest to Nueral Network which is not available through native openEO processes. With the current UDF processing the user is independent to train a model and choose feature sets accroding to their requiremnet and then run this model throught the R-UDF.

## Outlook
The results provided good result over smaller tested area over Bolzano, In the next step it would be great to test with other models and comapring the same features as the ones used in Eco4Alps project. But would be imporatnt to see how the prediction looks like with different trained models. It would be an interesting test to run the UC for a much larger area covering the whole province.
## Dependencies

* R version
* RStudio version
* all packages and versions
