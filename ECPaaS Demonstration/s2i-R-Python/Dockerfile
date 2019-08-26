FROM openshift/base-centos7

LABEL maintainer="Grant Atkins <gatkins@mitre.org>"

# Set labels used in OpenShift to describe the builder images
LABEL io.k8s.description="Plumber is a R package (with Python 3.6 Keras) that makes it easy to build web apps straight from R." \
      io.k8s.display-name="R with Python 3.6" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,R,python3.6"

# Install R, Python, and Tensorflow utils
RUN yum -y update && yum -y install epel-release wget && \
    yum -y install R && \
    yum -y install python36 python36-devel python36-pip python-virtualenv && \
    yum clean all

# Install R and Python 3 packages
RUN su - -c "R -e \"install.packages(c('tidyr', 'keras', 'plumber', 'yardstick', 'purrr'), repos='http://cran.rstudio.com/')\"" && \
    pip3 install tensorflow keras

# Defines the location of the S2I
# Although this is defined in openshift/base-centos7 image it's repeated here
# to make it clear why the following COPY operation is happening
LABEL io.openshift.s2i.scripts-url=image:///usr/local/s2i
# Copy the S2I scripts from ./.s2i/bin/ to /usr/local/s2i when making the builder image
COPY ./.s2i/bin/ /usr/local/s2i

# Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:1001 /opt/app-root

# openshift best practice is to use a number not a name for user
USER 1001

# Specify the ports the final image will expose
EXPOSE 8080

CMD run
