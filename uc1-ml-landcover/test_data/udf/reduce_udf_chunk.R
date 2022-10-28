getModel = NULL

udf_setup = function(context) {
  url1      <- 'https://github.com/Open-EO/r4openeo-usecases/blob/main/uc1-ml-landcover/test_data/models/TestModel1.rds?raw=True'
  getModel  <<- readRDS(gzcon(url(url1)))
}



udf_chunked = function(data,context){
  names(data)<-caret::predictors(getModel)
  data = data.frame(t(data))
  prediction <-predict(getModel, data)
  prediction = as.numeric(prediction)
  return(prediction)
}




