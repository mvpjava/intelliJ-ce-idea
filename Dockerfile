FROM mvpjava/intellij-ce-2020.3-base-image:ubuntu-openjdk11

MAINTAINER Andy Luis "MVP Java - mvpjava.com, triomni-it.com"

# Switch to non-root user 
# The host machine $USER is used, past in via --build-arg 
# in order to persist data across invocations of container.
# Default user is "mvpjava" if ever no --build-arg is provided.
# However that won't persist the data on host machine after 
# container is terminated so for best experience use the run.sh
# script that does this for you.
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

USER ${USER}
WORKDIR ${HOME}

ENTRYPOINT  ["sh", "-c", "${IJ_SETUP_SCRIPT_DIR_CNTR}/idea.sh"]
