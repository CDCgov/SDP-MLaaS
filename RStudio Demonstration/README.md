# MLaaS R  Example

This is an example project that provides machine learning as a service.
It includes R code utilizing Plumber, Keras, Tidyr, and Tensorflow.
This code can be deployed as a web service using Plumber and the `Model Code.R and `functions.R` scripts
This example expects a csv of chief complaint text, a keras `model.h5` file, and `tokenizer` file which need to be loaded into the R working environment, but does  **not** provide these files.

## Installation

This approach requires the following installed:

- [R](https://www.r-project.org/about.html)
- [Python 3.6+](https://www.python.org/downloads/release/python-366/)

To install the R dependencies locally, run:

```
install.packages(c('tidyr', 'keras', 'plumber', 'yardstick', 'purrr'), repos='http://cran.rstudio.com/')
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

The ss package contains 2 functions used in the `Model Code.R` file. Example code of these functions are in the 
`Data Processing Function.R` and `Prediction Function.R` files.

To install the ss Package, run:

```
library(devtools)
install("ss")
```
