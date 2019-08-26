library(plumber)

r <- plumb("predictions_controller.R")
r$run(host="0.0.0.0", port = 8080, swagger=TRUE)
