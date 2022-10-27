getModel = NULL



udf = function(data,context){
  url1      <- 'https://github.com/Open-EO/r4openeo-usecases/blob/main/uc1-ml-landcover/eco4alps/models/TestModelIntensive_RF.rds?raw=True'
  getModel  <- readRDS(gzcon(url(url1)))
  print(head(data))
  colnames(data)<-caret::predictors(getModel)
  print(head(data))
  
  
  prediction <-predict(getModel, data)
  print(head(prediction))
  prediction = as.numeric(prediction)
  print(head(prediction))
  print(class(prediction))
  print("prediction done")

  return(prediction)
  
}
