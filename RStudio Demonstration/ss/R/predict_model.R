#' A prediction Function
#'
#' This function makes class predictions based on the prepocessed data and an uploaded model
#' @param data a matrix of processed integer sequences corresponding to cheif complaints
#' @param model A keras Model (hdf5)
#' @keywords predict_model
#' @export
#' @examples
#' predict_model()

predict_model <- function(data, model) {

  #load_model_hdf5(model)


  # Predicted Class
  yhat_keras_class_vec <- predict_classes(object = model, x = as.matrix(data)) %>%
    as.vector()

  # Predicted Class Probability
  yhat_keras_prob_vec  <- predict_proba(object = model, x = as.matrix(data)) %>%
    as.vector()

  #estimates_keras_tbl <- tibble(
  #truth      = as.factor(labels) %>% fct_recode(yes = "1", no = "0"),
  #estimate   = as.factor(yhat_keras_class_vec) %>% fct_recode(yes = "1", no = "0"),
  #class_prob = yhat_keras_prob_vec
  #)
  #recoding based on threshold
  #levels(estimates_keras_tbl$estimate) <- c(levels(estimates_keras_tbl$estimate), 'yes')
  #estimates_keras_tbl <- within(estimates_keras_tbl, estimate[class_prob >= threshold] <- 'yes')
  #estimates_keras_tbl <- within(estimates_keras_tbl, estimate[class_prob <= threshold] <- 'no')

  #Final Prediction
  predictions <- yhat_keras_class_vec
  scores <- yhat_keras_prob_vec

  results <- cbind(predictions, scores)
  return(results)

}
