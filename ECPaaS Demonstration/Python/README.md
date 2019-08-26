# CDC MLaas Python Keras

This is an example project that utilizes a machine learning model as a service.
It includes a Python based webservice utilizing Flask, Keras, Pandas, and Tensorflow.
This webservice injests requests, processes the requests, and then responds with prediction values.

## Developer Requirements

This project utilizes the following technologies:

- [Docker](https://www.docker.com/)
- [Source-to-Image (s21)](https://github.com/openshift/source-to-image)
- [Python 3.6+](https://www.python.org/downloads/release/python-366/)

The key difference between this Python based repository and the other R based repository is that the R repository requires both R and Python.
The R based service results in a larger Docker image size when it is built.

This applications expects a keras `model.h5` file and `tokenizer` file be provided in the `models/` directory.

## OpenShift (ECPaaS)

ECPaaS comes with pre-built python images where you can provide the Git repository URL to download your source code and then it will automatically create your application, that also works for this repository.

If you need a custom image then your utilize the S2I image tool as described below.
You can also push this image to an image repository which can then be used in an  OpenShift (ECPaaS) environment.
Instructions on how to do this is found here: https://publichealthsurveillance.atlassian.net/wiki/spaces/ECPaaS/pages/353697805/Push+docker+image+to+nexus+repository.

## Using Source-to-Image (S2i)

Using S2I users can take this repository code and inject it into a pre-built Docker image that utilizes this python application in an executable way.
The following command build a Docker image:

```bash
s2i build --copy . registry.access.redhat.com/rhscl/python-36-rhel7 mitre/rhscl-cdc-mlaas:v1
```

A breakdown of what this command does:

- `s2i build` initiates the s2i build command.
- `--copy .` tells the s2i build to copy from the current local directory into designated builder image regardless of if it is a Git repository.
- `registry.access.redhat.com/rhscl/python-36-rhel7` is the location/name of the builder image we want to inject our code into. 
In this case it is RedHat's Python 3.6 builder image.
- `mitre/rhscl-cdc-mlaas:v1` the resulting image name that we created which is version tagged by `:v1` indicating version 1.

Once built, you can run this locally to confirm it works as intended:

```bash
docker run -it --rm -p 8080:8080 mitre/rhscl-cdc-mlaas:v1
```

Then you can navigate to http://localhost:8080/ to view the swagger UI there.
