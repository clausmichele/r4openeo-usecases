message("global level udf script")

udf_setup = function(context) {
  message("udf_setup -----")
  # if (!require("bfast")) {
  #   install.packages("bfast", quiet = TRUE)
  # }
}

# suppressWarnings(suppressMessages(library("bfast", quietly = T)))

udf_chunked = function(data, context) {
  message("udf_chunked -----")
  message("udf_chunked: mean")
  
  res = tryCatch(
    {
      mean(data)
    }, 
    error=function(cond) {
      message("udf_chunked: mean error. Returning 0.")
      message(cond)
      return(0)
    }
  )
  
  message("udf_chunked: done")
  return(res) 
}

