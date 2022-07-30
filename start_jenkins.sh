#!/bin/sh
########################
# Note: This script is executed as root with
#       the command "service jenkins start"
# Author: Sarah Stone
#######################

JENKINS_HOME=/app/jenkins
LOGFILE=/app/jenkins_exec/logs/jenkins.log
JENKINS_WAR=/app/jenkins_exec
HTTP_PORT=8080
HTTPS_KEYSTORE=$JENKINS_WAR/Cert/Jenkins.jks
#PIDFILE=/app/jenkins_exec/jenkins.pid
#JAVA_ARGS="$JAVA_ARGS -Djavax.net.ssl.trustStore=/app/jenkins/keystore/cacerts"

echo "Jenkins process starting..."
cmd="java $JAVA_OPTS -Djava.awt.headless=true -Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8 -DJENKINS_HOME=$JENKINS_HOME -Xms512m -Xmx1024m -XX:PermSize=512m -XX:MaxPermSize=512m -jar $JENKINS_WAR/jenkins.war --httpPort=$HTTP_PORT 2>&1 | tee $LOGFILE"
echo $cmd
java $JAVA_OPTS -Djava.awt.headless=true -Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8 -DJENKINS_HOME=$JENKINS_HOME -Xrs -Xms512m -Xmx6144m -XX:PermSize=512m -XX:MaxPermSize=512m -jar $JENKINS_WAR/jenkins.war -Dhudson.spool-svn=true --httpPort=$HTTP_PORT 2>&1 | tee $LOGFILE
    
