# execute the same function as the udf in plain R
# benchmark time


# libs -------------------------------------------------------------------------
library("stars")
library("bfast")
library("dplyr")
library("units")
library("lubridate")

# output path ------------------------------------------------------------------
pth_out = "~/git_projects/r4openeo-usecases/uc2-ts-breakdetection/local_r/results/local_r_test.tif"
pth_out = "~/git_projects/r4openeo-usecases/uc2-ts-breakdetection/local_r/results/local_r_vaja.tif"

# load input ndvi --------------------------------------------------------------
pth_ndvi = "~/git_projects/r4openeo-usecases/uc2-ts-breakdetection/00_data_local/test.nc/openEO.nc"
pth_ndvi = "~/git_projects/r4openeo-usecases/uc2-ts-breakdetection/00_data_local/vaja.nc/openEO.nc"
ndvi = stars::read_stars(pth_ndvi, proxy = FALSE)

# prepare ndvi object
# add crs (with read_stars, and from VITO already there)
# st_crs(ndvi) = st_crs(32632)

# convert time to proper dates
ndvi = st_set_dimensions(.x = ndvi, which = "t", 
                         values = lubridate::as_date(st_get_dimension_values(.x = ndvi, which = "t")))

# get bfast udf ----------------------------------------------------------------
pth_udf = "~/git_projects/r4openeo-usecases/uc2-ts-breakdetection/00_udfs/local_r_bfast_udf.R"
source(pth_udf)

# parameters udf ---------------------------------------------------------------
level = c(0.001, 0.001)
start_monitor = 2018
dates = st_get_dimension_values(ndvi, "t")

# apply udf --------------------------------------------------------------------
a = Sys.time()
bfast_brks = st_apply(X = ndvi, MARGIN = c("x", "y"), function(x){
  bfast_udf(pixels = x, 
            dates = dates, 
            start_monitor = start_monitor, 
            level = level, 
            val = "breakpoint")
})
b = Sys.time()
duration = b-a
duration 
# r4openeo_uc2_ndvi_mskd_small.nc 6 secs
# test.nc 34 s
# vaja.nc 4.8 h

# save result ------------------------------------------------------------------
write_stars(obj = bfast_brks, dsn = pth_out)

# quickcheck -------------------------------------------------------------------
bfast_brks[[1]][bfast_brks[[1]] < 2018] = NA
plot(bfast_brks)
mapview::mapview(bfast_brks)

# for vaja plotting only possible as proxy object
tst = read_stars(pth_out, proxy = TRUE)
mapview::mapview(tst)
