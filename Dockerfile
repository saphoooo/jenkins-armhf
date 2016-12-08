FROM ctarwater/armhf-alpine-rpi-java8
MAINTAINER saphoooo <stephane.beuret@gmail.com>

# docker run -d -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock -v /home/jenkins:/var/jenkins_home saphoooo/armhf-alpine-rpi-jenkins

# ENV VARS
ENV JENKINS_VERSION latest

RUN echo "http://dl-6.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk upgrade --update && \
    apk add --update \
    gnupg \
    tar \
    ruby \
    git \
    zip \
    curl \
    wget \
    sudo \
    docker \
    && rm -rf /var/cache/apk/*

# Setup
RUN mkdir -p /usr/share/jenkins && \
    mkdir -p /var/jenkins_home && \
    chmod -R 775 /usr/share/jenkins

# Start docker at boot
RUN rc-update add docker boot
    
# Live dangerously - use unstable Jenkins
RUN curl -fL http://mirrors.jenkins-ci.org/war/$JENKINS_VERSION/jenkins.war -o /usr/share/jenkins/jenkins.war

WORKDIR /var/jenkins_home

# Volumes
ENV JENKINS_HOME /var/jenkins_home

# for main web interface:
EXPOSE 8080


CMD ["java",  "-jar",  "/usr/share/jenkins/jenkins.war"]
