getModel = NULL

udf_setup = function(context) {
  url1      <- 'https://github.com/Open-EO/openeo-udf-python-to-r/blob/UC1_ML/models/TestModel1.rds?raw=True'
  getModel  <<- readRDS(gzcon(url(url1)))
}



udf_chunked = function(data,context){
  names(data)<-caret::predictors(getModel)
  data = data.frame(t(data))
  print(data)
  prediction <-predict(getModel, data)
  prediction = as.numeric(prediction)
  return(prediction)
}




