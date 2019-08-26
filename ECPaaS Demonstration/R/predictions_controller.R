# script name:
# predictions_controller.R
source("functions.R")

# set API title and description to show up in http://localhost:8000/__swagger__/
#' @apiTitle MLaaS
# @apiDescription 

# load model
model <- load_model_hdf5("./models/model.h5")

#' Log system time, request method and HTTP user agent of the incoming request
#' @filter logger
function(req){
  cat("System time:", as.character(Sys.time()), "\n",
      "Request method:", req$REQUEST_METHOD, req$PATH_INFO, "\n",
      "HTTP user agent:", req$HTTP_USER_AGENT, "@", req$REMOTE_ADDR, "\n")
  plumber::forward()
}

#' Nausea Predictions
#' @param description The description of symptoms
#' @post /predict
predict <- function(description="") {
    data <- text_process(description)
    res <- predict_model(data = data, model = model)
    list(prediction = res$prediction, probability = res$probability)
}
