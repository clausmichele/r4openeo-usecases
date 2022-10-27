library("tibble")
library("dplyr")
library("stars")
library("tidyr")
library("caret")
library("randomForest")
library("tictoc")

training_samples <-readRDS("/home/btufail@eurac.edu/Documents/Scripts/training_samples_Ruth.Rda")
training_samples_set <- subset(training_samples, select=-c(BLU.152.273.RNG,GRN.152.273.RNG, RED.152.273.RNG, RE1.152.273.RNG, RE2.152.273.RNG, RE3.152.273.RNG, NIR.152.273.RNG, BNR.152.273.RNG, SW1.152.273.RNG, SW2.152.273.RNG, NDV.152.273.MIN, NDV.152.273.Q10, NDV.152.273.Q25, NDV.152.273.Q50, NDV.152.273.Q75, NDV.152.273.Q90, NDV.152.273.AVG, NDV.152.273.STD, NDS.152.273.MIN, NDS.152.273.Q10, NDS.152.273.Q25, NDS.152.273.Q50, NDS.152.273.Q75, NDS.152.273.Q90, DEM))
colnames(training_samples_set) <- c('class', 
                                'B02_MIN', 'B02_Q10', 'B02_Q25', 'B02_Q50', 'B02_Q75', 'B02_Q90', 'B02_AVG', 'B02_STD', 'B02_IQR', 
                                'B03_MIN', 'B03_Q10', 'B03_Q25', 'B03_Q50', 'B03_Q75', 'B03_Q90', 'B03_AVG', 'B03_STD', 'B03_IQR', 
                                'B04_MIN', 'B04_Q10', 'B04_Q25', 'B04_Q50', 'B04_Q75', 'B04_Q90', 'B04_AVG', 'B04_STD', 'B04_IQR',
                                'B05_MIN', 'B05_Q10', 'B05_Q25', 'B05_Q50', 'B05_Q75', 'B05_Q90', 'B05_AVG', 'B05_STD', 'B05_IQR', 
                                'B06_MIN', 'B06_Q10', 'B06_Q25', 'B06_Q50', 'B06_Q75', 'B06_Q90', 'B06_AVG', 'B06_STD', 'B06_IQR', 
                                'B07_MIN', 'B07_Q10', 'B07_Q25', 'B07_Q50', 'B07_Q75', 'B07_Q90', 'B07_AVG', 'B07_STD', 'B07_IQR',
                                'B08_MIN', 'B08_Q10', 'B08_Q25', 'B08_Q50', 'B08_Q75', 'B08_Q90', 'B08_AVG', 'B08_STD', 'B08_IQR', 
                                'B8A_MIN', 'B8A_Q10', 'B8A_Q25', 'B8A_Q50', 'B8A_Q75', 'B8A_Q90', 'B8A_AVG', 'B8A_STD', 'B8A_IQR',
                                'B11_MIN', 'B11_Q10', 'B11_Q25', 'B11_Q50', 'B11_Q75', 'B11_Q90', 'B11_AVG', 'B11_STD', 'B11_IQR',
                                'B12_MIN', 'B12_Q10', 'B12_Q25', 'B12_Q50', 'B12_Q75', 'B12_Q90', 'B12_AVG', 'B12_STD', 'B12_IQR', 
                                'B02_MED', 'B03_MED', 'B04_MED', 'B05_MED', 'B06_MED', 'B07_MED', 'B08_MED', 'B8A_MED', 'B11_MED', 'B12_MED')

rf1<-train(class~.,
           data=training_samples_set,
           method="rf",
           ntree=100)
data <-"/home/btufail@eurac.edu/git_projects/r4openeo-usecases/uc1-ml-landcover/eco4alps/data/result (14).nc"
st<-raster::brick(data)
names(st)=caret::predictors(rf1)
prediction.raster<-predict(st,rf1)
writeRaster(prediction.raster,"/home/btufail@eurac.edu/git_projects/r4openeo-usecases/uc1-ml-landcover/eco4alps/local_r/prediction.nc")
