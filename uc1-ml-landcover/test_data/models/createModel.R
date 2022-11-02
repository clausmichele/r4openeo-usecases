
# Load the Libraries
library("tibble")
library("dplyr")
library("stars")
library("tidyr")
library("caret")
library("randomForest")
library("tictoc")


# Predictors --------------------------------------------------------------
s2data.all<- readRDS("/mnt/CEPH_PROJECTS/SAO/SENTINEL-2/s2_processing/Output/S2_Archive_complete.rds")
s2data.tps<- s2data.all %>% 
  dplyr::filter(Tile=="T32TPS") %>% 
  na.omit

data<-s2data.tps[128,]$ESA_L2A
data.read<-read_stars(data)


# Target ------------------------------------------------------------------
target<-read_stars("/mnt/CEPH_PROJECTS/SAO/ForestCanopy/01_Data/CORINE_2018_250m_Raster/DATA/U2018_CLC2018_V2020_20u1.tif")
extent<-st_bbox(data.read) %>% st_as_sfc %>% st_transform(.,st_crs(target))
target.crp<-st_crop(target,extent) %>% st_as_stars()


# Samples -----------------------------------------------------------------
set.seed(1)
rpts<- st_sample(extent,100) %>% st_as_sf() %>% mutate(ID=1:nrow(.))
rptsP<-st_transform(rpts,st_crs(data.read))


# Extraction --------------------------------------------------------------
tvals<-st_extract(target,st_coordinates(rpts))
pvals<-st_extract(data.read,st_coordinates(rptsP))
dataset<-cbind(tvals,pvals) %>% as_tibble() %>% setNames(c("Target","B02","B03","B04","B08")) %>% 
  mutate(Target=as.character(Target))


# Model -------------------------------------------------------------------
tic()
rf2<-train(Target~.,
           data=dataset,
           method="nnet", 
           tuneLength = 2,
           trace = FALSE,
           maxit = 100)
           
rf1<-train(class~.,
           data=new_ruth_samples,
           method="rf",
           ntree=100)
toc()

saveRDS(rf1,"models/TestModelIntensive_RF.rds")

# Target dataset ----------------------------------------------------------

s2data.tpt<- s2data.all %>% 
  dplyr::filter(Tile=="T32TPS") %>% 
  na.omit

data.tpt<-s2data.tpt[128,]$ESA_L2A
data.tpt.read<-read_stars(data.tpt)

data.tpt.read.sub<-data.tpt.read[0:1000,0:1000] %>% st_as_stars()

write_stars(data.tpt.read.sub,"models/testing2.nc")


# testing 
new_ruth_samples <- subset(samples_ruth, select=-c(BLU.152.273.RNG,GRN.152.273.RNG, RED.152.273.RNG, RE1.152.273.RNG, RE2.152.273.RNG, RE3.152.273.RNG, NIR.152.273.RNG, BNR.152.273.RNG, SW1.152.273.RNG, SW2.152.273.RNG, NDV.152.273.MIN, NDV.152.273.Q10, NDV.152.273.Q25, NDV.152.273.Q50, NDV.152.273.Q75, NDV.152.273.Q90, NDV.152.273.AVG, NDV.152.273.STD, NDS.152.273.MIN, NDS.152.273.Q10, NDS.152.273.Q25, NDS.152.273.Q50, NDS.152.273.Q75, NDS.152.273.Q90, DEM))
colnames(new_ruth_samples) <- c('class', 
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
