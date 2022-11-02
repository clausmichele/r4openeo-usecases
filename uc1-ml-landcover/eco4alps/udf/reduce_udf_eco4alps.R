getModel = NULL



udf = function(data,context){
  url1      <- 'https://github.com/Open-EO/r4openeo-usecases/blob/main/uc1-ml-landcover/eco4alps/models/TestModelIntensive_RF.rds?raw=True'
  getModel  <- readRDS(gzcon(url(url1)))
  colnames(data)<-caret::predictors(getModel)
  
  
  prediction <-predict(getModel, data)
  prediction = as.numeric(prediction)

  return(prediction)
  
}
