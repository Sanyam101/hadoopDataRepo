#!/bin/sh

export JENKINS_HOME=/ddsw/jenkins/home
echo "JENKINS_HOME Set to : " $JENKINS_HOME

/usr/bin/java -Djava.awt.headless=true -Dhttps.proxyHost=proxy.cat.com -Dhttps.proxyPort=80 -Dfile.encoding=UTF-8 -XX:PermSize=256m -XX:MaxPermSize=512m -Xms512m -Xmx2048m  -Djava.io.tmpdir=/ddsw/jenkins/tmp -jar /usr/lib/jenkins/jenkins.war --logfile=/ddsw/jenkins/logs/jenkins.log --webroot=/ddsw/jenkins/cache/war --httpPort=8080 --ajp13Port=8089 &
