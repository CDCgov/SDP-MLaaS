#* Nausea classification
#* @param text The text to classify
#* @get /classify
function(text){
  sequences <- texts_to_sequences(tokenizer, text)
  data <- pad_sequences(sequences, maxlen = 100)

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
   list(text = text, prediction = temp$yhat_keras_class_vec, prob = yhat_keras_prob_vec)
}
