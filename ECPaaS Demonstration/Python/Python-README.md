# MLaaS Python Keras Example

This is an example project that provides machine learning as a service.
It includes a Python based web service utilizing Flask, Keras, Pandas, and Tensorflow.
This web service ingests requests, processes the request data, and then responds with prediction values.
This example expects a keras `model.h5` file and `tokenizer` file be provided in the `models/` directory, but does  **not** provide these files.

## Running locally

This approach requires the following installed:

- [Python 3.6+](https://www.python.org/downloads/release/python-366/)

To install the python 3 requirements locally, run:

```
pip install -r requirements
```

To run this service locally, use the following:

```
python app.py
```

Then the service should be available from http://localhost:8080/.

## Running with Docker & Source-to-Image (S2i)

This approach requires the following installed:

- [Docker](https://www.docker.com/)
- [Source-to-Image (S2I)](https://github.com/openshift/source-to-image)

Using S2I users can take this repository code and inject it into a pre-built Docker image that utilizes this python application in an executable way.
The following command builds a Docker image:

```bash
s2i build --copy . registry.access.redhat.com/rhscl/python-36-rhel7 mitre/rhscl-cdc-mlaas:v1
```

Once built, you can run this locally to confirm it works as intended:

```bash
docker run -it --rm -p 8080:8080 mitre/rhscl-cdc-mlaas:v1
```

Then you can navigate to http://localhost:8080/ to view the swagger UI there.
