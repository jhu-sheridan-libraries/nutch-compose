FROM centos:7
MAINTAINER Mark Cyzyk <mcyzyk@jhu.edu>

ENV PACKAGES java-1.8.0-openjdk-devel wget gettext dos2unix
RUN yum -y install $PACKAGES

# copy conf, build, install files to container
COPY ./conf /opt/conf

# make sure permissions are set
RUN chmod -R 744 /opt/conf

# make sure line endings are correct for UNIX
RUN dos2unix -k /opt/conf/*
RUN dos2unix -k /opt/conf/profile.d/*

# install components (ant, hbase, nutch)
RUN /bin/bash -c "/opt/conf/install.sh"

# build nutch
RUN /bin/bash -c "/opt/conf/build.sh"

