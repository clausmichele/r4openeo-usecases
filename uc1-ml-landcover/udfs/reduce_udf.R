getModel = NULL

udf_setup = function(context) {
  url1      <- 'https://github.com/Open-EO/openeo-udf-python-to-r/blob/UC1_ML/models/TestModel1.rds?raw=True'
  getModel  <<- readRDS(gzcon(url(url1)))
}



udf = function(data,context){
  url1      <- 'https://github.com/Open-EO/openeo-udf-python-to-r/blob/UC1_ML/models/TestModel1.rds?raw=True'
  getModel  <<- readRDS(gzcon(url(url1)))
  data = data.frame(t(data))
  names(data)<-caret::predictors(getModel)
  B02 <- unlist(data$B02)
  B03 <- unlist(data$B03)
  B04 <- unlist(data$B04)
  B08 <- unlist(data$B08)
  df<-data.frame(B02, B03, B04, B08)
  
  

  prediction <-predict(getModel, df)
  prediction = as.numeric(prediction)
  print(class(prediction))
  print("prediction done")
  
  return(prediction)
  
}
