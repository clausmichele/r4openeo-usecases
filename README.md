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


## UC2: Forest Break Detection

:bulb: **Timeseries modelling on pixel level via R-UDFs**

Mountain forests produce a large number of ecosystem services that will likely be affected by climate
change. In light of the possible rise in extreme climatic events, changes in the forest disturbance regime will
be very detrimental to the economic system, protection against natural hazards and biodiversity. The
extreme weather events in Northern Italy are a good example to underline the frequency and scale of these
impacts: In spring 2017, vast areas totalling 800 ha of pines dried up in the Vinschgau Valley as a result of a
severe drought in the previous two years combined with an increased vulnerability towards pest
infestations. The north-eastern regions of Italy were hit by a storm event in autumn 2018 with wind gusts
exceeding 200 km/h. The registered damage summed up to 42’500 ha and resulted in a growing stock
volume of fallen trees of 8.5 million m³. In November 2019 strong snowfall and associated heavy snow load
on trees resulted in extensive snow break within the province of South Tyrol. These examples are typical for
the entire Alps and show the necessity to understand the impacts of climate change on the forest
disturbance regime in the alpine region in order to evaluate the resilience of the forest ecosystem with
respect to composition and cover density.
Earth Observation is a key instrument for forest ecosystem monitoring, yet, up-to-date, there are no high
spatial resolution maps available to characterize - and dynamically update - the small-scale forest
disturbances for the Alpine region. Our proposed Forest Disturbance Service will make use of previous
project developments (e.g. EU-GMES project EUFODOS) and employ Sentinel-2 data covering the period
from 2016 to 2020 and employ time-series interpretation techniques such as `bfast` to detect breakpoints in
the temporal profiles of vegetation indices.
Following the same set-up as use-case 1, the second is adherent to a planned service “Forest Break Detection” in the ESA EO4alps - ECO4Alps project. The planned collaboration and exchange about input-data and methodological approach will take place with the WP coordinators both from Eurac Research and the Solenix GmbH. The main aim of this activity is to implement a similar setup as the use-case in the ECO4Alps project in an R-based environment. The study area will be the extent of the region where the Vaja Storm affected the south-eastern region of South Tyrol / Italy (approximately 600 km2). 
In this use case we are planning to integrate EO data from Sentinel-2 retreive forest disturbances from 2016 to 2020 using the R-client as well as the R-UDF functionalities. This allows us to showcase and implement a prototype for time-series modelling based on time series break detection using the R-client and the OpenEO infrastructure. The added value of this use case is to:

- Propose an openEO-based implementation of forest disturbance detection to regional partners. 
- Adjacent development to a scientific activity defined in a regional initiative (ECO4Alps).
- Define showcases on how to implement time-series modelling through R client and R-UDFs.


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
