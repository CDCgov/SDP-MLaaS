# MLaas R-Keras Example

This is an example project that provides machine learning as a service.
It includes a R based web service utilizing Plumber, Keras, Tidyr, and Tensorflow.
This web service injests requests, processes the requests, and then responds with prediction values.
This example expects a keras `model.h5` file and `tokenizer` file be provided in the `models/` directory, but does  **not** provide these files.

## Running locally

This approach requires the following installed:

- [R](https://www.r-project.org/about.html)
- [Python 3.6+](https://www.python.org/downloads/release/python-366/)

To install the R dependencies locally, run:

```
R -e "install.packages(c('tidyr', 'keras', 'plumber', 'yardstick', 'purrr'), repos='http://cran.rstudio.com/')"
```

To install the Python 3 dependencies, run:

```
pip install tensorflow keras
```

To run this service locally, use the following:

```
Rscript server.R
```

Then the service should be available from [http://localhost:8080/\_\_swagger\_\_/](http://localhost:8080/__swagger__/).

## Running with Docker & Source-to-Image (S2i)

This approach requires the following installed:

- [Docker](https://www.docker.com/)
- [Source-to-Image (S2I)](https://github.com/openshift/source-to-image)

Using S2I users can take this repository code and inject it into a pre-built Docker image that utilizes this python application in an executable way.
The following command builds a Docker image:

```bash
s2i build --copy . mitre/r-python-s2i mitre/r-plumber-keras
```

If S2I cannot find `mitre/r-python-s2i`, this indicates that there hasn't been an image built with that name.
You must first follow the instructions provided in the [s2i-r-python3](../s2i-r-python3) directory. 

Once built, you can run this locally to confirm it works as intended:

```bash
docker run -it --rm -p 8080:8080 mitre/r-plumber-keras
```

Then you can navigate to to [http://localhost:8080/\_\_swagger\_\_/](http://localhost:8080/__swagger__/) to view the swagger UI there.
