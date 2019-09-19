FROM centos:7
MAINTAINER Farooq Sadiq <fsadiq1@jhu.edu>

ENV PACKAGES java-1.8.0-openjdk-devel wget gettext
RUN yum -y install $PACKAGES

# copy conf, build, install files to container
COPY ./conf /opt/conf

# make sure permissions are set
RUN chmod -R 744 /opt/conf/*.sh

# install components (ant, hbase, nutch)
RUN /bin/bash -c "/opt/conf/install.sh" && \
    /bin/bash -c "/opt/conf/build.sh"

