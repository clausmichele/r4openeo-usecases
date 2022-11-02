print("global level udf script")

udf_setup = function(context) {
  print("udf_setup -----")
  # if (!require("bfast")) {
  #   install.packages("bfast", quiet = TRUE)
  # }
}

# suppressWarnings(suppressMessages(library("bfast", quietly = T)))

udf_chunked = function(data, context) {
  print("udf_chunked -----")
  print("udf_chunked: mean")
  mean(data)
  print("udf_chunked: done")
  return(res) 
}

