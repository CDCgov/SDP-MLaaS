# R / Python 3.6 S2I

A [Source-to-Image (S2I)](https://github.com/openshift/source-to-image) implementation for a CentOS image that executes an [R](https://www.r-project.org/about.html) based application includes [Python 3.6](https://www.python.org/downloads/release/python-366/).

## Dependencies Included

A list of languages and their libraries already included in this builder image:

- Python 3.6
    - keras
    - tensorflow
- R
    - keras
    - plumber
    - purrr
    - tidyr
    - yardstick

## Requirements

This requires the following installed:

- [Docker](https://www.docker.com/)
- [Source-to-Image (S2I)](https://github.com/openshift/source-to-image)

When using this builder image it is expected to find a `server.R` file that starts a plumber service.

This can be as simple as:

```R
library(plumber)

r <- plumb("predictions_controller.R")
r$run(host="0.0.0.0", port = 8080, swagger=TRUE)
```

Where the `plumb("predictions_controller.R")` indicates a predictions_controller location.
An example project is found in the [../cdc-mlaas-r](cdc-mlaas-r) directory.

## Usage

First clone this repository.
Then utilize the following Docker command to build the image:

```bash
cd r-python3-s2i/
docker build . -t mitre/r-python-s2i
```

Once the image is built, navigate to your R code directory.
Then inject the R web service into this newly built image, creating another image `mitre/r-plumber-mlaas`:

```bash
s2i build --copy . mitre/r-python-s2i mitre/r-plumber-mlaas
```

Then to confirm it works when runing the following:

```bash
docker run -it --rm -p 8080:8080 mitre/r-plumber-mlaas
```

Navigate to http://localhost:8080/ to confirm it works.
