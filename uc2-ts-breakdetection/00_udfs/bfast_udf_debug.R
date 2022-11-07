message("global level udf script")

udf_setup = function(context) {
  message("udf_setup -----")
  if (!require("bfast")) {
    install.packages("bfast", quiet = TRUE)
  }
}

# suppressWarnings(suppressMessages(library("bfast", quietly = T)))

udf_chunked = function(data, context) {
  message("udf_chunked -----")
  message("udf_chunked: unlisting")
  pixels = unlist(data) # this are 150000 pixels right now. why? Should be 500
  dates = names(data)
  
  message("udf_chunked: error handling")
  val = if(is.null(context) || is.null(context$val)) "breakpoint" else context$val
  level = if(is.null(context) || is.null(context$level) || length(context$val) == 0) c(0.001, 0.001) else context$level

  # error handling
  stopifnot(length(pixels) == length(dates)) 
  stopifnot(val %in% c("breakpoint", "magnitude"))

  # create ts object for bfast
  message("udf_chunked: bfastts")
  lsts = bfastts(pixels, dates, type = c("irregular"))
  
  # make sure there are enough observations
  message(paste0("udf_chunked: number of valid pixels = ", sum(!is.na(lsts))))
  if (sum(!is.na(lsts)) < 100){
    message("udf_chunked: number of valid pixels < 100, setting to NA")
    return(NA)
  }
    
  
  # run bfast
  message("udf_chunked: run bfastmonitor")
  res = tryCatch(
    {
      res = bfastmonitor(lsts, 
                         context$start_monitor, 
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

