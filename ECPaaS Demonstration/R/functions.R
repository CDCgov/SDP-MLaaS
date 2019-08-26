library(tidyr)
library(dplyr)
library(purrr)
library(keras)
library(yardstick)

# This function preprocesses the data and return the sequences to feed into the learner
text_process <- function(x) {
  
  x <- gsub("0", "ZERO", x)
  x <- gsub("1", "ONE", x)
  x <- gsub("2", "TWO", x)
  x <- gsub("3", "THREE", x)
  x <- gsub("4", "FOUR", x)
  x <- gsub("5", "FIVE", x)
  x <- gsub("6", "SIX", x)
  x <- gsub("7", "SEVEN", x)
  x <- gsub("8", "EIGHT", x)
  x <- gsub("9", "NINE", x)
  x <- gsub('[[:punct:]]', '', x)
  
  tokenizer <- load_text_tokenizer("./models/tokenizer")
  sequences <- texts_to_sequences(tokenizer, x)
  
  data <- pad_sequences(sequences, maxlen = 100)
  return(data)
}

predict_model <- function(data, model) {
  # Predicted Class
  yhat_keras_class_vec <- predict_classes(object = model, x = as.matrix(data)) %>%
    as.vector()
  
  # Predicted Class Probability
  yhat_keras_prob_vec  <- predict_proba(object = model, x = as.matrix(data)) %>%
    as.vector()
  
  #Final Prediction
  predictions <- yhat_keras_class_vec
  return(list(prediction = predictions, probability = yhat_keras_prob_vec))
  
}
