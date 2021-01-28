FROM azul/zulu-openjdk:11.0.10-11.45.27

MAINTAINER Andy Luis "MVP Java - mvpjava.com, triomni-it.com"

# This makes debconf use a frontend that expects no interactive input at all,
# preventing it from even trying to access stdin (this avoiding a big red error
# message in console output)
ENV  DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y apt-utils \
  && apt-get install -y libcanberra-gtk3-module \
  && apt-get install -y curl wget vim \
  && apt-cache policy git \
  && apt-get -y install git \
  && apt-get install -y sudo \
  && apt-get clean  \
  && rm -rf /var/lib/apt/lists/* \ 
  && rm -rf /tmp/*  \
  && rm -rf /var/cache/apk/*

##############################################
# Install Maven
##############################################

ARG MAVEN_TARBALL=apache-maven-3.6.3-bin.tar.gz
ARG MAVEN_VERSION=apache-maven-3.6.3
ARG MAVEN_INSTALL_DIR=/usr/local/src

COPY ${MAVEN_TARBALL} $MAVEN_INSTALL_DIR

RUN cd $MAVEN_INSTALL_DIR        \
  &&  tar -xf  "$MAVEN_TARBALL"  \
  && rm -f "$MAVEN_TARBALL"      

# Note (from base image) : JAVA_HOME=/usr/lib/jvm/zulu11-ca-amd64
# Setup MAVEN ENVironment variables
ENV M2_HOME=${MAVEN_INSTALL_DIR}/${MAVEN_VERSION}
ENV PATH=${M2_HOME}/bin:${PATH}

##############################################
# Install IntelliJ Community Edition IDEA
##############################################
ARG IJ_TARBALL=ideaIC-2020.3.1.tar.gz
ARG IJ_VERSION=IntelliJIdea2020.3
ARG IJ_INSTALL_DIR=/opt
ENV IJ_SETUP_SCRIPT_DIR_CNTR=${IJ_INSTALL_DIR}/idea-IC-203.6682.168/bin

COPY ${IJ_TARBALL} $IJ_INSTALL_DIR 

RUN  cd ${IJ_INSTALL_DIR}   \
  && tar -xf  ${IJ_TARBALL} \
  && rm -f ${IJ_TARBALL}

###############################################################
# Removes accessibility warning (known bug) in console log 
# which is annoying to see as a developer when started manually
###############################################################
ENV NO_AT_BRIDGE=1

CMD sh
