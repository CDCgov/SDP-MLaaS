#' A prediction Function based on a threshold
#'
#' This function makes class predictions based on the prepocessed data and an uploaded model
#' with a predetermined threshold
#' @param data a matrix of processed integer sequences corresponding to cheif complaints
#' @param model A keras Model (hdf5)
#' @keywords threshold
#' @export
#' @examples
#' predict_thresh()

predict_thresh <- function(data, model) {
  
  #load_model_hdf5(model)
  
  
  # Predicted Class
  yhat_keras_class_vec <- predict_classes(object = model, x = as.matrix(data)) %>%
    as.vector()
  
  # Predicted Class Probability
  yhat_keras_prob_vec  <- predict_proba(object = model, x = as.matrix(data)) %>%
    as.vector()
  
  threshold <- .1363132

  temp <- data.frame(cbind(yhat_keras_class_vec, yhat_keras_prob_vec))
  
  temp$yhat_keras_class_vec[temp$yhat_keras_prob_vec > threshold] <- 1
  #Final Prediction
  
  return(temp)
  
}
  
