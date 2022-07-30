FROM redhat/ubi8:8.5
USER root
ENV JENKINS_VERSION=2.346.2 \
    JENKINS_EXEC_DIR=/app/jenkins_exec \
    JENKINS_HOME=/app/jenkins \
    TZ="America/New_York" \
	JENKINS_USER=admin \
	JENKINS_PASS=admin123 \
	JAVA_OPTS=-Djenkins.install.runSetupWizard=false
RUN yum install -y java-11-openjdk* procps ncurses zip openssh-server wget sudo git iputils jq \
    && mkdir -p $JENKINS_HOME $JENKINS_EXEC_DIR/logs \
	&& mkdir -p -m 0600 /root/.ssh/ \
	&& ssh-keyscan -H github.com >> ~/.ssh/known_hosts \
    && groupadd -g 1001 jenkins && useradd -m -d $JENKINS_HOME -u 1001 -g 1001 -G wheel jenkins \
    && sed -i '/wheel/s/^#*/#/g' /etc/sudoers && sed -i '/NOPASSWD/s/^#*//g' /etc/sudoers
COPY ./start_jenkins.sh $JENKINS_EXEC_DIR/
RUN wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo \
    && wget -O $JENKINS_EXEC_DIR/jenkins.war https://get.jenkins.io/war-stable/$JENKINS_VERSION/jenkins.war \
    && curl -fsSL https://rpm.nodesource.com/setup_16.x | sudo bash - && yum install -y nodejs && yum -y install gcc-c++ make \
	&& curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo && yum -y install yarn \
	&& npm i -g @nestjs/cli && npm install -g ts-node \
    && chown -R jenkins:jenkins /app \
    && chmod 775 /app && chmod +x $JENKINS_EXEC_DIR/start_jenkins.sh
COPY ./package.json $JENKINS_HOME/
WORKDIR $JENKINS_HOME
EXPOSE 8080 50000
CMD $JENKINS_EXEC_DIR/start_jenkins.sh
