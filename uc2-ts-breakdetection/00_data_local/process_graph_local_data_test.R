# process graph for getting s2 ndvi for vaja region 
# same extent as eco4alps
# 2016 to 2020

# libs -------------------------------------------------------------------------
library(openeo)
library(dplyr)
library(sf)

# connect to backend -----------------------------------------------------------
host = "https://openeo-dev.vito.be" # "https://openeo.cloud" # "https://openeo-dev.vito.be"
con = openeo::connect(host)
login()

# con$isConnected()
# con$isLoggedIn()
# describe_account()

# definitions ------------------------------------------------------------------
# outpath
pth_out = "~/git_projects/r4openeo-usecases/uc2-ts-breakdetection/00_data_local/test.nc"

# path to spatial extent
pth_ext = "~/git_projects/r4openeo-usecases/uc2-ts-breakdetection/00_extent/test.json"

# define parameters ------------------------------------------------------------
collection = "SENTINEL2_L2A_SENTINELHUB"
spatial_extent = jsonlite::read_json(pth_ext)
time_range = list("2016-01-01", 
                  "2021-01-01")
bands = c("B04", "B08")
bands_cloud = "CLM" # 0 = no cloud, 1 = cloud, 255 = no data -> the mask process can handle this

# define process graph ---------------------------------------------------------
p = openeo::processes()
data = p$load_collection(id = collection, 
                         spatial_extent = list(west = spatial_extent$spatial_extent$west, 
                                               east = spatial_extent$spatial_extent$east, 
                                               south = spatial_extent$spatial_extent$south, 
                                               north = spatial_extent$spatial_extent$north),
                         temporal_extent = time_range, 
                         bands = bands) 

data_clouds = p$load_collection(id = collection, 
                                spatial_extent = list(west = spatial_extent$spatial_extent$west, 
                                                      east = spatial_extent$spatial_extent$east, 
                                                      south = spatial_extent$spatial_extent$south, 
                                                      north = spatial_extent$spatial_extent$north),
                                temporal_extent = time_range, 
                                bands = bands_cloud) 

mask_clouds = p$mask(data = data, mask = data_clouds)

calc_ndvi = p$reduce_dimension(data = mask_clouds, 
                               dimension = "bands", 
                               reducer = function(data, context) {
                                 red = data[1]
                                 nir = data[2]
                                 (nir-red)/(nir+red)})

result = p$save_result(data = calc_ndvi, format="netCDF") # "GTiff"
#pg_json = as(result, "Process")


# create job -------------------------------------------------------------------
name_out =  basename(pth_out)
job = create_job(graph = result,
                 title = name_out,
                 description = name_out,
                 format = "netCDF")
start_job(job = job$id)

# status job -------------------------------------------------------------------
stat = status(job)
# while (stat %in% c("queued", "running")) {
#   Sys.sleep(30)
#   stat = status(job)
#   message(paste0(Sys.time(), " | Job: ", job$id, " is ", stat))
# }

result_obj = list_results(job = job$id)
dwnld = download_results(job = job$id, folder = dirname(pth_out))

# > dwnld = download_results(job = job$id, folder = dirname(pth_out))
# Error in `resp_abort()`:
#   ! HTTP 404 Not Found.
# Run `rlang::last_error()` to see where the error occurred.


