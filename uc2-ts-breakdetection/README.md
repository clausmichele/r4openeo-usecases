# UC2: Timeseries Break Detection

:bulb: **Timeseries modelling on pixel level via R-UDFs**

## Description
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

## Data and Extent
*Data*
* Sentinel-2 L2A collection
* Cloud masking using S2 scene classification
* 2016 to 2020
* 10 m resolution

*Extents*
* test: A test area within the vaja storm region for small scale testing. 100 by 100 pixels (10000 pixels), 1 km2
* vaja: the area where the vaja storm hit in 2018. This area is also used in the ECO4Alps project to test the bfast service there. 2238 by 2670 pixels (6 mio. pixels), 600 km2

## Methods

OpenEO native functions do not allow to cover specialized cases
There are many software packages available that solve these problems.
UDFs allow to use the capabilities of specialized methods and also combine them with
custom refinements in arbitrary R code. 
In this use case the timeseries modelling package `bfast` is used to estimate breaks
in a NDVI timeseries. 
The timeseries that is fed into `bfast` is created with native openEO processes. 
The `bfast` method is then called within a `reduce_dimension` to operate on single 
pixel locations along the time dimension.

The UDF can be coded so that the parametrization is taken care of via the openEO
context parameter. This enables to pass different parameters to a function without
replacing the whole code for the UDF. In this example the `bfast` parameters 
`start_monitor` (when the monitoring period should start), 
`val` (which value should be returned: breakpoint timing or magnitude of change),

It is also showcased that two UDFs can be included in one processgraph and that the
results can be used further. In this example it is shown that the breakpoint timing
is refined with a threshold of the magnitude of change, so that only very certain
breaks are kept.

- process graph
- bfast udf + context for parameters


## Results
### Compared to ECO4Alps

- Link to ECO4Alps Results Repo/Service
- Compare the tif for Vaja extent with ECO4Alps
  - RScript
  - Results in Readme
- Explain difference in input data set
- Explain difference in calculation

### On the fly calculation on Eurac backend
The results of the use case can be computed directly on the fly on the 
Eurac backend by using this process graph (and reducing the extent to a relevant forest patch).
This allows interactive and on the fly monitoring of forest patches. 
The process graph is masking clouds, calculating the NDVI, detecting breakpoints in the timeseries, 
estimating the magnitude of change and finally keeping the most probably detected breaktpoint timings.

1. [Detect breakpoints](https://editor.openeo.org/?server=https%3A%2F%2Fopeneo.eurac.edu&process=https://raw.githubusercontent.com/Open-EO/r4openeo-usecases/main/uc2-ts-breakdetection/openeo_eurac/processgraph_eurac_test.json&discover=1)
2. [Estimate magnitude of breakpoints](https://editor.openeo.org/?server=https%3A%2F%2Fopeneo.eurac.edu&process=https://raw.githubusercontent.com/Open-EO/r4openeo-usecases/main/uc2-ts-breakdetection/openeo_eurac/magnitude_masking/processgraph_eurac_test_magnitude.json&discover=1)
3. [Mask breakpoints with magnitude](https://editor.openeo.org/?server=https%3A%2F%2Fopeneo.eurac.edu&process=https://raw.githubusercontent.com/Open-EO/r4openeo-usecases/main/uc2-ts-breakdetection/openeo_eurac/magnitude_masking/processgraph_eurac_test_magnitude_mask.json&discover=1)

![webviewer_eurac](./openeo_eurac/magnitude_masking/uc2_bfast.gif)

## Timings 
### Experiment
Four ways of producing the bfast forest break detection are carried out on the two different AOIs mentioned above. This is mainly done for prototyping, benchmarking and for demonstrating the different ways of interacting with openEO platform, the R-Client and the R-UDF library. 

* local_r: The udf is run directly in R
* local_udf: The udf is run on a local instance of the UDF service
* openeo_eurac: The udf is run on Eurac Researchs openEO instance
* openeo_platform: The udf is run on openEO platform (VITO dev backend) 

### Runtime Test Extent

* local_r
  * processgraph_data_local.R: 216 s (26126 cpusec)
  * run_local_r_udf.r: 34 s
  * total: 250 s
* local_udf 
  * processgraph_data_local.R: 216 s (26126 cpusec)
  * run_bfast_udf.ipynb: 78 s
  * total: 294 s
* openeo_eurac
  * processgraph_eurac_test.json: 118 s
* openeo_platform
  * processgraph_vito_test.json: NA (libs not installed)

### Runtime Vaja Extent

* local_r
  * processgraph_data_local.R: 4775 s (1.3 h) (933550 cpusec)
  * run_local_r_udf.r: 4.8 h
  * total: 6.1 h
* local_udf 
  * processgraph_data_local.R: 4775 s (1.3 h) (933550 cpusec)
  * run_bfast_udf.ipynb: NA (runs out of memory (96GB) after 1h15)
  * total: NA
* openeo_eurac
  * processgraph_eurac_vaja.json: NA (currently error)
* openeo_platform
  * processgraph_vito_vaja.json: NA (libs not installed)

## Conclusion
This use case shows how R UDFs are used to do advanced time series modelling which is not available through native openEO processes. 
In this use case the `bfastmonitor` break detection method is chosen to detect breaks in forested areas. 
It demonstrates a blue-print how to apply time series modelling on  a single pixel time series. 
Additionally, it is shown how the openEO context parameter can be used to
parametrize a UDF without recoding it. This UDF allows to pass on bfast parameters
such as level, value and start_monitor to parametrize the functin without recoding the UDF.
Other methods could also be used by replacing the function in the UDF, e.g. for phenology analysis 
or time series smoothing.
It is especially valuable for on-demand scenarios, where small patches are analyzed ad-hoc.

## Outlook
* The `bfast` process can be replaced by phenology packages like `phenopix` to study phenology. Which is also a pixel based time series modelling approach.
* The processgraph that calculates breakpoints and masks them with the magnitude can be exposed as a User Defined Process (UDP). Any user can then use it and parametrize it to his liking (e.g. start of the modelling period, threshold for the magnitude masking, etc.)

## Dependencies

### Running locally in R (without UDF)

### Running a local UDF backend

### Running on an openEO backend
* R version
* RStudio version
* all packages and versions
