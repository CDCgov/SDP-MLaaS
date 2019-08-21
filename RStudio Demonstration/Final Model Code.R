#Call libraries
library(readr)
library(tidyr)
library(dplyr)
library(purrr)
library(keras)
library(yardstick)
library(forcats)
library(ss)

#Load data, tokenizer, and model weights files
cdata <- read_csv("Sample.csv")
cdata <- as_vector(cdata)
tokenizer <-load_text_tokenizer("tokenizer2")
model <- load_model_hdf5("nausea_model.h5")

#process data with process function from 'ss' package
sample_data <- process(x = cdata)

#process nausea with predict_thresh function from 'ss' package
predict_thresh(data = sample_data, model = model)

#Expose functions as a webservice
library(plumber)
r <- plumb("functions.R")
r$run(port=8000)