udf_chunked = function(data,context, dimension='var'){
  print(class(data))
  # read a machine learning model done with caret
  url1      <- 'https://github.com/Open-EO/openeo-udf-python-to-r/blob/UC1_ML/models/TestModel1.rds?raw=True'
  getModel  <- readRDS(gzcon(url(url1)))
  
  #print(paste(getModel$modelInfo$label,"- Model Loaded successfully"))
  #data = st_as_stars(data)
  #saveRDS(data,"models/testdata_reduce_chunked.rds")
  #print(data)

  # convert the data xarray to raster
  #data <-readRDS("models/testdata_apply.rds")
  #data.split <-readRDS("models/testdata_reduce_stars.rds")
  #print(class(data))
  
  #if(class(data)=="stars") print("Data converted to Stars object") else print('nothing')
  
  
  # predicht on array - reduce_dimension, udf_chunked
  names(data)<-caret::predictors(getModel)
  data = data.frame(t(data))
  prediction <-predict(getModel, data)
  
  
  # STARS Package prediction - this should only work in apply since stars data model is kept there!
  #data.split<-split(data,"var")
  # names(data.split)<-caret::predictors(getModel)
  # print(data.split)
  # prediction.stars <-predict(data.split,getModel)
  
  # RASTER package prediction
  #s<-data[[1]]
  #st<-raster::brick(s)
  #names(st)=caret::predictors(getModel)
  #prediction.raster<-predict(st,getModel)
  #print("Prediction Done")
  #print(prediction)
  #write_stars(prediction.stars,"models/starsprediction_reduce_check.nc")
  print("File saved")
  # Return the raster
  return(prediction)
}
