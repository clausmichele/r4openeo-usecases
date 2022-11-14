library(openeo)
library(raster)
library(sf)
library(stars)
library(geojsonsf)
library(rjson)
library(ggplot2)
library(rnaturalearth)
library(dplyr)

# FUNCTIONS
# Moving average
ma = function(x){
  filter(x, rep(1/31, 31))
}

# Moving average benchmarking
udf = "R"
if (udf == "R"){
  ma_udf <- function(data, context){
    p$run_udf(data = data, udf = readr::read_file("src/udf.py"),
              runtime = "Python"
    )
  }
} else{
  ma_udf <- function(data, context){
    p$run_udf(data = data, udf = readr::read_file("src/py-udf.py"),
              runtime = "Python"
    )
  }
}

# Download data from openeo
download_tif = function(date1,
                        date2,
                        w, s, e, n,
                        output_path = "."){

    # acquire data for the extent
    datacube = p$load_collection(
      id = "TERRASCOPE_S5P_L3_NO2_TD_V1",
      spatial_extent = list(west = w, south = s, east = e, north = n),
      temporal_extent=c(date1, date2),
      bands=c("NO2")
    )

  #graph = as(datacube,"Graph")
  #compute_result(graph = graph, output_file = "test.tif")

  cat("queuing computation... \n")
  cat("it may take a while... \n")
  formats = list_file_formats()
  result = p$save_result(data = datacube,
                         format = formats$output$GeoTiff)
  job = create_job(graph=result, title = "local-test")
  start_job(job = job)
  jobs = list_jobs()
  while (jobs[[job$id]]$status == 'running' | jobs[[job$id]]$status == 'queued' | jobs[[job$id]]$status == 'created' ){

    print(paste0('this may take a moment, your process is ', jobs[[job$id]]$status))
    Sys.sleep(60)

    jobs = list_jobs()
    if (jobs[[job$id]]$status == 'finished' | jobs[[job$id]]$status == 'error'){

      break
    }
  }

  cat("downloading results")
  try(dir.create(output_path))
  download_results(job = job$id, folder = output_path)

}

# Run Moving Average as UDF in openEO
run_ma_udf_openeo = function(date1,
                        date2,
                        w, s, e, n,
                        output_path = "."){

    # acquire data for the extent
    datacube = p$load_collection(
      id = "TERRASCOPE_S5P_L3_NO2_TD_V1",
      spatial_extent = list(west = w, south = s, east = e, north = n),
      temporal_extent=c(date1, date2),
      bands=c("NO2")
    )

  datacube = p$apply_dimension(process = ma_udf,
                                  data = datacube, dimension = "t")

  #graph = as(datacube,"Graph")
  #compute_result(graph = graph, output_file = "test.tif")

  cat("queuing computation... \n")
  cat("it may take a while... \n")
  formats = list_file_formats()
  result = p$save_result(data = datacube, format = formats$output$GeoTiff)
  job = create_job(graph=result, title = "udf-benchmarking")
  start_job(job = job)
  jobs = list_jobs()
  openeo_runtime = character()
  while (jobs[[job$id]]$status == 'running' | jobs[[job$id]]$status == 'queued' | jobs[[job$id]]$status == 'created' ){

    cat(paste0('this may take a moment, your process is ', jobs[[job$id]]$status, "\n"))
    Sys.sleep(60)

    jobs = list_jobs()
    if (jobs[[job$id]]$status == 'finished' | jobs[[job$id]]$status == 'error'){
      tak = Sys.time()
      openeo_runtime = tak - tik
      cat(openeo_runtime, "\n")
      break
    }
    if (jobs[[job$id]]$status == 'running'){
      tik = Sys.time()
    }
  }

  cat("downloading results \n")
  try(dir.create(output_path))
  download_results(job = job$id, folder = output_path)

  return(openeo_runtime)
}

# MAIN
# open connection
con = connect(host = "https://openeo.cloud")

# login
login()

#   _____         _ _                _                 _
#  / ____|       (_) |              | |               | |
# | (_____      ___| |_ _______ _ __| | __ _ _ __   __| |
#  \___ \ \ /\ / / | __|_  / _ \ '__| |/ _` | '_ \ / _` |
#  ____) \ V  V /| | |_ / /  __/ |  | | (_| | | | | (_| |
# |_____/ \_/\_/ |_|\__/___\___|_|  |_|\__,_|_| |_|\__,_|
#

# define working directory
path = "switzerland"

# log starting time
tik = Sys.time()

# User defined process
p = processes()

# download data for switzerland
## extract bbox
country_sf = ne_countries(country = "switzerland", returnclass = "sf", scale = 'large')

download_tif(date1 = "2019-01-01", date2 = "2019-03-31",
             w = st_bbox(country_sf)[1], s = st_bbox(country_sf)[2],
             e = st_bbox(country_sf)[3], n = st_bbox(country_sf)[4],
             output_path = path)
download_tif(date1 = "2019-04-01", date2 = "2019-06-30",
             w = st_bbox(country_sf)[1], s = st_bbox(country_sf)[2],
             e = st_bbox(country_sf)[3], n = st_bbox(country_sf)[4],
             output_path = path)
download_tif(date1 = "2019-07-01", date2 = "2019-09-30",
             w = st_bbox(country_sf)[1], s = st_bbox(country_sf)[2],
             e = st_bbox(country_sf)[3], n = st_bbox(country_sf)[4],
             output_path = path)
download_tif(date1 = "2019-10-01", date2 = "2019-12-31",
             w = st_bbox(country_sf)[1], s = st_bbox(country_sf)[2],
             e = st_bbox(country_sf)[3], n = st_bbox(country_sf)[4],
             output_path = path)

# list files and build cube
tik2 = Sys.time()
ls = list.files(path, pattern = ".tif", all.files = T, full.names = T)

# local moving average
cube = read_stars(ls) %>%
  merge() %>%
  st_apply(., c("x", "y"), ma) %>%
  aperm(c(2,3,1))

raw_cube = read_stars(ls) %>%
  merge()

# log ending time
tak = Sys.time()
local_swiss_bm_d = tak - tik # 21 min
local_swiss_bm = tak - tik2 # 7 sec
cat(local_swiss_bm_d, " for local run with download")
cat(local_swiss_bm, " for local run without download")

# ma cube
plot(cube[,,,1:41])

# compare to raw data
plot(raw_cube[,,,1:41])

########## openEO runtime ######################################################
tik = Sys.time()
runtime1 = run_ma_udf_openeo(date1 = "2019-01-01", date2 = "2019-03-31",
                             w = -15.0, s = 34.0,
                             e = 45.0, n = 72.0,
                             output_path = path)
runtime2 = run_ma_udf_openeo(date1 = "2019-04-01", date2 = "2019-06-30",
                             w = -15.0, s = 34.0,
                             e = 45.0, n = 72.0,
                             output_path = path)
runtime3 = run_ma_udf_openeo(date1 = "2019-07-01", date2 = "2019-09-30",
                             w = -15.0, s = 34.0,
                             e = 45.0, n = 72.0,
                             output_path = path)
runtime4 = run_ma_udf_openeo(date1 = "2019-10-01", date2 = "2019-12-31",
                             w = -15.0, s = 34.0,
                             e = 45.0, n = 72.0,
                             output_path = path)
tak = Sys.time()

vito_swiss_bm_d = tak - tik
vito_swiss_bm = runtime1 + runtime2 + runtime3 + runtime4
cat(vito_swiss_bm_d, " for openeo run with download") # 26 min
cat(vito_swiss_bm, " for openeo run without download") # 4 min

########## openEO runtime ######################################################
ˇ
#  ______
# |  ____|
# | |__  _   _ _ __ ___  _ __   ___
# |  __|| | | | '__/ _ \| '_ \ / _ \
# | |___| |_| | | | (_) | |_) |  __/
# |______\__,_|_|  \___/| .__/ \___|
#                       | |
#                       |_|

# define working directory
path = "europe"

# log starting time
tik = Sys.time()

# download data for europe
## extract bbox
download_tif(date1 = "2019-01-01", date2 = "2019-03-31",
             w = -15.0, s = 34.0,
             e = 45.0, n = 72.0,
             output_path = path)
download_tif(date1 = "2019-04-01", date2 = "2019-06-30",
             w = -15.0, s = 34.0,
             e = 45.0, n = 72.0,
             output_path = path)
download_tif(date1 = "2019-07-01", date2 = "2019-09-30",
             w = -15.0, s = 34.0,
             e = 45.0, n = 72.0,
             output_path = path)
download_tif(date1 = "2019-10-01", date2 = "2019-12-31",
             w = -15.0, s = 34.0,
             e = 45.0, n = 72.0,
             output_path = path)

# list files and build cube
tik2 = Sys.time()
ls = list.files(path, pattern = ".tif", all.files = T, full.names = T)

### ATTENTION : THIS WILL VERY LIKELY BREAK YOUR PC !!! ########################
# local moving average
cube = stars::read_stars(ls) %>%
  merge() %>%
  st_apply(c("x", "y"), ma) %>%
  aperm(c(2,3,1))

raw_cube = stars::read_stars(ls) %>%
  merge()
################################################################################

# log ending time
tak = Sys.time()
local_europe_bm_d = tak - tik
local_europe_bm = tak - tik2
cat(local_europe_bm_d, " for Europe for local run with download") # failed
cat(local_europe_bm, " for Europe for local run without download") # failed

########## openEO runtime ######################################################
tik = Sys.time()
runtime1 = run_ma_udf_openeo(date1 = "2019-01-01", date2 = "2019-03-31",
             w = -15.0, s = 34.0,
             e = 45.0, n = 72.0,
             output_path = path)
runtime2 = run_ma_udf_openeo(date1 = "2019-04-01", date2 = "2019-06-30",
             w = -15.0, s = 34.0,
             e = 45.0, n = 72.0,
             output_path = path)
runtime3 = run_ma_udf_openeo(date1 = "2019-07-01", date2 = "2019-09-30",
             w = -15.0, s = 34.0,
             e = 45.0, n = 72.0,
             output_path = path)
runtime4 = run_ma_udf_openeo(date1 = "2019-10-01", date2 = "2019-12-31",
             w = -15.0, s = 34.0,
             e = 45.0, n = 72.0,
             output_path = path)
tak = Sys.time()

vito_europe_bm_d = tak - tik
vito_europe_bm = runtime1 + runtime2 + runtime3 + runtime4
cat(vito_europe_bm_d, " for openeo run with download") # 27 min
cat(vito_europe_bm, " for openeo run without download") # 5 min

########## comparison ##########################################################
cat(local_swiss_bm_d, " for Switzerland for local run with download \n")
cat(local_swiss_bm, " for Switzerland for local run without download \n")
cat(vito_swiss_bm_d, " for Switzerland for openeo run with download \n")
cat(vito_swiss_bm, " for Switzerland for openeo run without download \n\n")

cat(local_europe_bm_d, " for Europe for local run with download \n")
cat(local_europe_bm, " for Europe for local run without download \n")
cat(vito_europe_bm_d, " for Europefor openeo run with download \n")
cat(vito_europe_bm, " for Europe for openeo run without download \n")
