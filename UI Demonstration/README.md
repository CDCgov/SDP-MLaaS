# UI R Example

This is an example UI that displays chief complaint classifications as a time series.  
It includes R code utilizing Keras, Tidyr, Tensorflow, and Shiny. This code can be run with the 'server.R' script.  
This app expects a `.csv` of chief complaint text in the first column and dates in the second, a keras `model.h5` file, and `tokenizer` file which need to be loaded into the R working environment, but does  **not** provide these files.


## Running this app

To run this RShiny app, open the 'server.R' script in RStudio and press the 'Run App' button.
A dataset can be uploaded  with the Browse button and a model selected from the dropdown menu. Data is preprocessed for model use by the app.
Generate a visualization by pressing the Run Model button.  Once the model has been run, select generate plot to change plot type.  
Running this app on large datasets may take several minutes to generate a data visualization.

## Installation

This approach requires the following installed:

- [R](https://www.r-project.org/about.html)
- [Python 3.6+](https://www.python.org/downloads/release/python-366/)

To install the R dependencies locally, run:

```
install.packages(c('tidyr', 'keras', 'plumber', 'yardstick', 'purrr','shiny','shinyjs','lubridate','reshape2'), repos='http://cran.rstudio.com/')
```
To install keras in R, run:

```
library(keras)
install_keras()
```

To install the Python 3 dependencies, run in Python:

```
pip install tensorflow keras
```
## ss Package

This code also requires the 'ss' package contained in [cdc-mlaas-R](../R)

To install the ss Package, run:

```
library(devtools)
install("ss")
```
