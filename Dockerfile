FROM ubuntu:18.04
USER root
ENV JENKINS_VERSION=2.346.2 \
    JENKINS_HOME=/app/jenkins 
RUN yum install -y java-11-openjdk* procps ncurses zip wget sudo git gettext iputils \
    && mkdir -p $JENKINS_HOME $JENKINS_HOME/logs \
    && groupadd -g 1001 jenkins && useradd -M -u 1001 -g 1001 -G wheel jenkins \
    && sed -i '/wheel/s/^#*/#/g' /etc/sudoers && sed -i '/NOPASSWD/s/^#*//g' /etc/sudoers
RUN wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo \
    && wget -O $JENKINS_EXEC_DIR/jenkins.war https://get.jenkins.io/war-stable/$JENKINS_VERSION/jenkins.war \
    && chown -R jenkins:jenkins /app \
    && chmod 755 /app \
	&& dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo && dnf install docker-ce --nobest -y \
	dnf module -y install nodejs:16 \
    && curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash \
    && source $NVM_DIR/nvm.sh && npm install 
USER jenkins
WORKDIR $JENKINS_HOME
EXPOSE 8080 50000
