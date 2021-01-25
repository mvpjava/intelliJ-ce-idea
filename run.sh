#!/bin/bash

# Create IntelliJ directories used as Docker bind mount volumes on host.
# if they don't exist, then create them with current $USER permissions on host 
# in order to have write permissions in container (or else root is used)
# Resource reference: https://www.jetbrains.com/help/idea/tuning-the-ide.html

IJ_ROOT_DIRNAME=IntelliJIdea2020.3
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
IJ_PLUGINS_DIR_HOST=${IJ_ROOT_DIR_HOST}/.local/share/JetBrains/
[ ! -d $IJ_PLUGINS_DIR_HOST ] && mkdir -p $IJ_PLUGINS_DIR_HOST

# IJ log directory
IJ_LOG_DIR_HOST=${IJ_ROOT_DIR_HOST}/.cache/JetBrains/${IJ_ROOT_DIR_HOST}/log
[ ! -d $IJ_LOG_DIR_HOST ] && mkdir -p $IJ_LOG_DIR_HOST

############################################
# Create IJ directory paths within container
###########################################

IJ_ROOT_DIR_CNTR=~

IJ_SYNTAX_DIR_CNTR=${IJ_ROOT_DIR_CNTR}/.config/JetBrains/$IJ_ROOT_DIRNAME

IJ_CACHE_DIR_CNTR=${IJ_ROOT_DIR_CNTR}/.cache/JetBrains/$IJ_ROOT_DIRNAME

IJ_PLUGINS_DIR_CNTR=${IJ_ROOT_DIR_CNTR}/.local/share/JetBrains/$IJ_ROOT_DIRNAME

IJ_LOG_DIR_CNTR=${IJ_ROOT_DIR_CNTR}/.cache/JetBrains/${IJ_ROOT_DIRNAME}/log

