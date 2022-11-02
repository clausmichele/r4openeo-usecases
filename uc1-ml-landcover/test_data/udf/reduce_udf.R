getModel = NULL



udf = function(data,context){
  url1      <- 'https://github.com/Open-EO/r4openeo-usecases/blob/main/uc1-ml-landcover/test_data/models/TestModel1.rds?raw=True'
  getModel  <<- readRDS(gzcon(url(url1)))
  colnames(data)<-caret::predictors(getModel)
<<<<<<< HEAD
=======
<<<<<<< HEAD
=======

>>>>>>> 6729a5afc4a89724aeba30fe107ae9390be5e4b6
>>>>>>> a6d6fd2cf5c6fca139deaf13571b894cb58739dc
  

  prediction <-predict(getModel, data)
  prediction = as.numeric(prediction)
  
  return(prediction)
  
}
