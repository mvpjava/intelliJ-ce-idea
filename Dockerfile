FROM azul/zulu-openjdk:11.0.10-11.45.27

MAINTAINER Andy Luis "MVP Java - mvpjava.com, triomni-it.com"

RUN apt-get update \
  && apt-get install -y apt-utils \
  && apt-get install -y libcanberra-gtk3-module \
  && apt-get install -y curl wget vim \
  && apt-cache policy git \
  && apt-get -y install git \
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

# This makes debconf use a frontend that expects no interactive input at all, 
# preventing it from even trying to access stdin (this avoiding a big red error
# message in console output)
ENV  DEBIAN_FRONTEND=noninteractive

# Switch to non-root user which gets created with sudo access
# # The host machine $USER is used, past in via --build-arg 
# in order to persist data across invocations of container.
# Default user is "mvpjava" if ever no --build-arg is provided
# however that won't persist the data on host machine after 
# container is terminated
ARG USER=mvpjava      
ENV HOME=/home/${USER}
ENV USER_ID=1000
ENV GROUP_ID=1000

RUN apt-get install sudo -y && \
    useradd ${USER} && \
    export uid=${USER_ID} gid=${GROUP_ID} && \
    mkdir -p /etc/sudoers.d && \
    echo "${USER}:x:${USER_ID}:${GROUP_ID}:${USER},,,:${HOME}:/bin/bash" >> /etc/passwd && \
    echo "${USER}:x:${USER_ID}:" >> /etc/group && \
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER} && \
    chmod 0440 /etc/sudoers.d/${USER} 

##########################################################################
# Need to create IJ directories here and then set persmissions for end
# user or else when bind mounting, they will always be owned by root
##########################################################################

RUN mkdir -p ${HOME}/.config/JetBrains/IdeaIC2020.3 &&     \
    mkdir -p ${HOME}/.local/share/JetBrains/IdeaIC2020.3 &&   \
    mkdir -p ${HOME}/.local/share/JetBrains/consentOptions &&   \
    mkdir -p ${HOME}/.java/.userPrefs && \
    chown -R ${USER}:${USER} ${HOME} &&  \
    chmod 2764 -R ${HOME}

###############################################################
# Removes accessibility warning (known bug) in console log 
# which is annoying to see as a developer when started manually
###############################################################
ENV NO_AT_BRIDGE=1

USER ${USER}
WORKDIR ${HOME}

ENTRYPOINT  ["sh", "-c", "${IJ_SETUP_SCRIPT_DIR_CNTR}/idea.sh"]
