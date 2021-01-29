# Docker for Your Java Developent Environment with IntelliJ

This is here to support the Blog Post http://mvpjava.com/docker-java-development-environment-intellij
and the You Tube Tutorial https://youtu.be/HUj1RbwYXVQ

+ Note: Only works if your running Docker on a Linux host/VM

This is meant for Java Developers who want to run their IntelliJ IDEA in a Docker Container.

This image will take the current $USER on the host machine into account so that you
may have access to all IntelliJ directories in the container (*not as root user). 

Also, the bind mount volumes
are binded on host to allow the state of IntelliJ to be preserved across re-runs.
So IntelliJ plugins and preferences are preserved as well as maven $HOME/.m2 directory
so you don't have to keep downloading the same artifacts.

You can share your source code with the IntelliJ. Just place you source code in (default location) ..
${HOME}/IdeaIC2020.3/IdeaProjects


# How to start Docker Container
You must execute the ./run.sh script which handles all of this ...

+ $ git clone https://github.com/mvpjava/intelliJ-ce-idea.git
+ $ cd intelliJ-ce-idea
+ $ chmod 754 ./run.sh
+ $ ./run.sh

# Base Directory
+ You do not have to venture off in the base directory uness you want to customize things
+ It is there as a reference. The build can be found on DockerHub (see below)

All Docker images can be found on my DockerHub account under 
+ https://hub.docker.com/repository/docker/mvpjava/intellij-ide
+ https://hub.docker.com/repository/docker/mvpjava/intellij-ce-2020.3-base-image

=====================================================

Subscribe to MVP Java ...

https://www.youtube.com/c/MVPJava?sub_confirmation=1

Follow me ...

Website  : http://www.mvpjava.com

Company: http://www.triomni-it.com

Facebook : https://www.facebook.com/mvpjava

Twitter  : https://twitter.com/mvpjava

DockerHub: https://hub.docker.com/?namespace=mvpjava
