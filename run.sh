#!/bin/bash

# First build a docker container that will create the host
# machines's current $USER in the container in order for data
# to be persistent when container is terminated
docker  build --build-arg USER=$USER  -t mvpjava/intellij-ide:latest .

# Create IntelliJ directories used as Docker bind mount volumes on host.
# if they don't exist, then create them with current $USER permissions on host 
# in order to have write permissions in container (or else root is used)
# Resource reference: https://www.jetbrains.com/help/idea/tuning-the-ide.html

IJ_ROOT_DIRNAME=IdeaIC2020.3 
IJ_ROOT_DIR_HOST=${HOME}/${IJ_ROOT_DIRNAME}
[ ! -d $IJ_ROOT_DIR_HOST ] && mkdir -p $IJ_ROOT_DIR_HOST

echo "IntelliJ directory located under ... $IJ_ROOT_DIR_HOST"

# IJ Syntax directory
IJ_SYNTAX_DIR_HOST=${IJ_ROOT_DIR_HOST}/.config/JetBrains/
[ ! -d $IJ_SYNTAX_DIR_HOST ] && mkdir -p $IJ_SYNTAX_DIR_HOST

# IJ cache directory
IJ_CACHE_DIR_HOST=${IJ_ROOT_DIR_HOST}/.cache/JetBrains/
[ ! -d $IJ_CACHE_DIR_HOST ] && mkdir -p $IJ_CACHE_DIR_HOST

# IJ plugins directory
IJ_PLUGINS_DIR_HOST=${IJ_ROOT_DIR_HOST}/.local/share/JetBrains/consentOptions
[ ! -d $IJ_PLUGINS_DIR_HOST ] && mkdir -p $IJ_PLUGINS_DIR_HOST

# IJ User Preferences
IJ_USER_PREFS_HOST=${IJ_ROOT_DIR_HOST}/.java/.userPrefs
[ ! -d $IJ_USER_PREFS_HOST ] && mkdir -p $IJ_USER_PREFS_HOST


############################################
# Create IJ directory paths within container
###########################################

IJ_ROOT_DIR_CNTR=~

IJ_SYNTAX_DIR_CNTR=${IJ_ROOT_DIR_CNTR}/.config/JetBrains/$IJ_ROOT_DIRNAME

IJ_CACHE_DIR_CNTR=${IJ_ROOT_DIR_CNTR}/.cache/JetBrains/$IJ_ROOT_DIRNAME

IJ_PLUGINS_DIR_CNTR=${IJ_ROOT_DIR_CNTR}/.local/share/JetBrains/$IJ_ROOT_DIRNAME

IJ_USER_PREFS_CNTR=${IJ_ROOT_DIR_CNTR}/.java/.userPrefs

#############################################################
# If you want to share code with the container,
# place your project directories under $IJ_PROJECTS_DIR_HOST
#############################################################
IJ_PROJECTS_DIR_HOST=${IJ_ROOT_DIR_HOST}/IdeaProjects
[ ! -d $IJ_PROJECTS_DIR_HOST ] && mkdir -p $IJ_PROJECTS_DIR_HOST

IJ_PROJECTS_DIR_CNTR=${IJ_ROOT_DIR_CNTR}/IdeaProjects

###########################################################
# Share you maven artiacts on hosts machine with container
# to avoid re-downloading everything
###########################################################
MAVEN_M2_DIR_HOST=~/.m2
[ ! -d $$MAVEN_M2_DIR_HOST ] && mkdir -p $MAVEN_M2_DIR_HOST

MAVEN_M2_DIR_CNTR=~/.m2

# Ensure host user has all persmissions correty set for access
chmod 764 -R $IJ_ROOT_DIR_HOST

#########################################################
# Ensure Docker can connect to X11 Server on host.
# Very permissive.
#########################################################
xhost +

docker container run -d --rm -it                   \
-e DISPLAY                                         \
-v $HOME/.Xauthority:/home/$USER/.Xauthority       \
-v /tmp/.X11-unix:/tmp/.X11-unix                   \
-v /var/run/docker.sock:/var/run/docker.sock       \
-v ${IJ_ROOT_DIR_HOST}:${IJ_SYNTAX_DIR_CNTR}       \
-v ${IJ_CACHE_DIR_HOST}:${IJ_CACHE_DIR_CNTR}       \
-v ${IJ_PLUGINS_DIR_HOST}:${IJ_PLUGINS_DIR_CNTR}   \
-v ${IJ_PROJECTS_DIR_HOST}:${IJ_PROJECTS_DIR_CNTR} \
-v ${MAVEN_M2_DIR_HOST}:${MAVEN_M2_DIR_CNTR}       \
-v ${IJ_USER_PREFS_HOST}:${IJ_USER_PREFS_CNTR}     \
-h jetbrains                                       \
--name  ij-ce-ide-jdk11                      \
mvpjava/intellij-ide:latest
