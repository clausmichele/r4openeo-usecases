bfast_udf = function(pixels, dates, start_monitor = 2018, level = c(0.001, 0.001),
                     val = "breakpoint") {
  # error handling
  stopifnot(length(pixels) == length(dates))
  stopifnot(val %in% c("breakpoint", "magnitude"))
  
  # create ts object for bfast
  lsts = bfastts(pixels, dates, type = c("irregular"))
  
  # make sure there are enough observations
  if (sum(!is.na(lsts)) < 100){
    return(NA)
  }
  
  # run bfast and return the selected value into the raster
  res = bfastmonitor(lsts,
                     start_monitor,
                     formula = response~harmon,
                     order = 1,
                     history = "all",
                     level = level,
                     verbose = F)[[val]]
  if(is.na(res)){
    return(0)
  }
  return(res)
}
