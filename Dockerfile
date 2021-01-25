FROM azul/zulu-openjdk:11.0.10-11.45.27

# note that JAVA_HOME=/usr/lib/jvm/zulu11-ca-amd64

# docker run -it --rm azul/zulu-openjdk:11 java -version

# Base Dockerfile ... https://github.com/zulu-openjdk/zulu-openjdk/blob/master/11.0.7-11.39.15/Dockerfile

# Install Maven

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

CMD mvn --version
