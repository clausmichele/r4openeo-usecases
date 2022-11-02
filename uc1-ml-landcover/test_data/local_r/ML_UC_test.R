library("tibble")
library("dplyr")
library("stars")
library("tidyr")
library("caret")
library("randomForest")
library("tictoc")


url1      <- 'https://github.com/Open-EO/r4openeo-usecases/blob/main/uc1-ml-landcover/test_data/models/TestModel1.rds?raw=True'
getModel  <<- readRDS(gzcon(url(url1)))

data <-"/home/btufail@eurac.edu/git_projects/r4openeo-usecases/uc1-ml-landcover/test_data/data/test_site.nc"
st<-raster::brick(data)
names(st)=caret::predictors(getModel)

tic()
prediction.raster<-predict(st,getModel)
toc()

writeRaster(prediction.raster,"/home/btufail@eurac.edu/git_projects/r4openeo-usecases/uc1-ml-landcover/test_data/local_r/prediction.nc")
