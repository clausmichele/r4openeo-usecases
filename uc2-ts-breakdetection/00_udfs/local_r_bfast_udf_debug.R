bfast_udf = function(pixels, dates, start_monitor = 2018, level = c(0.001, 0.001),
                     val = "breakpoint") {
  message("udf_chunked ----------------")
  
  # error handling
  stopifnot(length(pixels) == length(dates))
  stopifnot(val %in% c("breakpoint", "magnitude"))
  
  # create ts object for bfast
  lsts = bfastts(pixels, dates, type = c("irregular"))
  
  # make sure there are enough observations
  message(paste0("udf_chunked: number of valid pixels = ", sum(!is.na(lsts))))
  if (sum(!is.na(lsts)) < 100){
    message("udf_chunked: number of valid pixels < 100, setting to NA")
    return(NA)
  }
  
  # run bfast and return the selected value into the raster
  message("udf_chunked: run bfastmonitor")
  res = tryCatch(
    {
      res = bfastmonitor(lsts, 
                         start_monitor, 
                         formula = response~harmon, 
                         order = 1, 
                         history = "all", 
                         level = level,
                         verbose = F)[[val]]
    }, 
    error = function(cond) {
      message("udf_chunked: bfastmonitor error. Returning 0.")
      message(cond)
      return(0)
    }
  )
  
  
  
  if(is.na(res)){
    message("udf_chunked: bfast result is NA. Returning 0.")
    return(0)
  }
  message("udf_chunked: done")
  return(res)
}
