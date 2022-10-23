# r4openeo-usecases

## UC1: Ecosystem Mapping with Machine Learning

:bulb: **Machine Learning Classification using R-UDFs**

The categorization of landscapes into ecosystems based on their complex functionalities and land cover
helps to understand the central biodiversity variables of a natural environment. Key factors such as
species composition and their distribution as well as their status or the ecosystem services provided are
often linked to a specific ecosystem type and the underlying human impact. The extensive mapping of
diverse ecosystems throughout Europe has been accomplished with initiatives such as the CORINE Land
Cover Dataset (CLC) regularly updated since 2000. However, extensive land cover datasets are often
highly generalized or adapted to a specific thematic interest. At the same time existing ecosystem maps
are difficult to apply to mountainous regions given the strong influence of topography, the steady and
dispersed cloud cover or the diverse management practices adapted. The combination of machine
learning techniques and earth observation data with a regional focus in a mountainous area is a powerful
combination to map different ecosystems in higher detail.
This use-case is aligned to a planned service “Ecosystem mapping” in the ESA EO4Alps - ECO4Alps
proposal, starting in January 2021. The planned collaboration and exchange about input-data and
methodological approach will take place with the WP coordinators both from Eurac Research and the
Solenix GmbH. The main aim of this activity is to implement a similar setup as the use-case in the
ECO4Alps project in an R-based environment. The study area for this use-case will be the extent of the
Autonomous province of South Tyrol / Italy (approximately 7400 km2).
Therefore, the openEO R-client and R-UDFs are used with the goal of mapping diverse ecosystem
classes. These classes will be estimated by a Random Forest (RF) machine learning classifier trained
with earth observation imagery from Sentinel-2 MSI as well as ancillary geospatial data such as Digital
Elevation Models (DEM) and land cover classification such as the CORINE land cover dataset. The
Random Forest classifier used for the mapping of the ecosystem classes is therefore trained locally and
applied remotely on an OpenEO back-end using the r-client and R-UDFs. This allows us to showcase a
machine learning algorithm applied to spatial mapping using R in combination with the OpenEO
initiative.
The added value of this use-case is to:
- Propose an openEO-based workflow for ecosystem mapping to regional partners
- Adjacent development to a scientific activity defined in a regional initiative (ECO4Alps)
- Define a detailed showcase to implement machine learning techniques via the openEO R client
and R-UDF service


## UC2: Forest Phenology/Break Detection

:bulb: **Timeseries modelling on pixlel level via R-UDFs**

Phenology is the study of recurrent events occurring to living organisms. In case of vegetation, the plant
phenology generally refers to the cyclic stages of the plant growth throughout the year, so called
phenophases. These stages differ considerably based on the plant species and their distribution as well
as external factors such as the temperature and precipitation. Scientific studies on plant phenology
gained importance in vegetation studies during the past 20 years with a focus on the shifts of
phenophases during the year. The goal is to evaluate episodical, seasonal or long-term changes in the
plant growth linked to human impact or climatological changes. It has become evident that the shifts in
these phases correspond to the predictions of climatological models and are generally visible throughout
the globe. The high topographical changes, the diverse vegetation cover and the lack of in-situ data to
validate those models in mountainous regions are at times misrepresented by the spatially coarse
phenological prediction models. It is of high interest to produce a layer for the diverse phenophases for
the alpine region in order to assess the temporal variability and thus to effectively mitigate present or
future climatic impacts on the alpine vegetation. In order to predict the changes spatially consistent, EO
data has proven to be very effective to derive land surface phenology (LSP) metrics using optical
datasets.
Following the same set-up as use-case 1, the second is adherent to a planned service “Forest Phenology”
in the ESA EO4alps - ECO4Alps project. The planned collaboration and exchange about input-data and
methodological approach will take place with the WP coordinators both from Eurac Research and the
Solenix GmbH. The main aim of this activity is to implement a similar setup as the use-case in the
ECO4Alps project in an R-based environment. The study area will be the extent of the Autonomous
province of South Tyrol / Italy (approximately 7400 km2).
In this use case we are planning to integrate EO data from Sentinel-2 as well as Landsat and adjacent
geospatial layers (e.g. DEMs) in order to predict different phenophases of forest growth from 2016 to
2020 using the R-client as well as the R-UDF functionalities. This allows us to showcase and implement
a prototype for time-series modelling based on phenology using the R-client and the OpenEO
infrastructure.
The added value of this use case is to:
- Propose an openEO-based implementation of forest phenology retrieval to regional partners.
- Adjacent development to a scientific activity defined in a regional initiative (ECO4Alps)
- Define showcases on how to implement time-series modelling through R client and R-UDFs

## UC3: NO2 Monitoring

:bulb: **Shiny Dashboard for easy access to smoothed S5P Data**

TROPOMI is the sensor on board of the Sentinel-5P (S5P) satellite that monitors atmospheric chemistry,
and is in particular of interest for the monitoring of NO2, a gas that has adverse health effects. Recent
studies have investigated the relationship between exposure to NO2 and the severity of effects of
COVID-19 infections. The NO2 measurements from S5P are not straightforward to analyze because they
are collected on a relatively low resolution, raw data are collected in non-rectilinear grids (curvilinear
grids), raw data are noisy and often have to be discarded due to quality constraints. Processing S5P into
useful high-resolution images requires a lot of statistical modelling, including spatial and temporal
smoothing. This use case will compare a number of different spatial and temporal smoothing techniques
available in R packages (e.g., from R packages gstat, FRK, forecast). The products thus created are highresolution, smooth images on regular grids, created for regular time intervals. Such products can be used
regionally e.g. by environmental policy makers or by epidemiological researchers who are for instance
trying to understand spatial variation in mortality or long-term effects of COVID-19 infection.
Use case 3 builds upon and extends “UC4: NO2 Monitoring” of the “openEO Platform” ESA-funded
project, and which is led by the University of Muenster. That means that we wills seek the possibility to
execute it one of the instances of “openEO Platform”, and by that demonstrate the developments of the
currently proposed project in “openEO Platform”, as well as use its dissemination channels (websites,
galleries, workshops, presentations). It will also ensure compatibility and interoperability of the
developments in the currently proposed project with the developments in “openEO Platform”. In
addition, it will create high-resolution maps for European regions where NO2 concentrations are
elevated, for instance north-western Europe (London-Netherlands-Ruhr area in Germany), or Northern
Italy (Po valley). To data analysts, it will show how modern statistical methods for time series analysis
and for spatial, temporal and spatiotemporal smoothing, available as R functions, can be applied to large
volumes of NO2 observations from S5P, and how the results can be integrated in R environments
(Rstudio, Shiny, Jupyter Lab).
The added value of this use case is to:
- Make an openEO-based implementation of NO2 smoothing available to regional stakeholders.
- Verify the connection to openEO Platform.
- Define and publish showcases on how to implement time-series modelling on low-resolution,
noisy S5P data through R-UDFs


## R-UDFs
https://github.com/Open-EO/openeo-udf-python-to-r

## R-Client
https://github.com/Open-EO/openeo-r-client
