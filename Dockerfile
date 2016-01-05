# -----Add instalation wildfly 8.1.0.Final com java 8
# MAINTAINER Cesar Augusto <cesar.augusto@squadra.com.br>

FROM jboss/base-jdk:8

# Set the WILDFLY_VERSION env variable
ENV WILDFLY_VERSION 8.1.0.Final

# Add the WildFly distribution to /opt, and make wildfly the owner of the extracted tar content
# Make sure the distribution is available from a well-known place
RUN cd $HOME && curl http://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz | tar zx && mv $HOME/wildfly-$WILDFLY_VERSION $HOME/wildfly

# Set the JBOSS_HOME env variable
ENV JBOSS_HOME /opt/jboss/wildfly

# Expose the ports we're interested in
EXPOSE 8080 9990

# Set the default command to run on boot
# This will boot WildFly in the standalone mode and bind to all interface
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]


# ------Add instalation switchyard


ENV JBOSS_SY_VERSION 2.0.0.Final
ENV JBOSS_SY_VERSION_MAIN v2.0.Final

#
# Install switchyard
RUN cd $JBOSS_HOME && curl http://downloads.jboss.org/switchyard/releases/$JBOSS_SY_VERSION_MAIN/switchyard-$JBOSS_SY_VERSION-WildFly.zip | bsdtar -xvf-


# ------Add user for wildfly user:admin password:r547achzqX96XQUJ
# YOU MUST ALTER ON THE FIRST TIME LOGIN

RUN /opt/jboss/wildfly/bin/add-user.sh admin r547achzqX96XQUJ --silent
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]

# Installs Ant
ENV ANT_VERSION 1.9.6

RUN cd $HOME && curl -O http://www.us.apache.org/dist//ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz && \
    tar -xzf apache-ant-${ANT_VERSION}-bin.tar.gz

ENV ANT_HOME $HOME/apache-ant-${ANT_VERSION}
ENV PATH ${PATH}: $HOME/apache-ant-${ANT_VERSION}/bin

# Install Picketlink

#- name: Download picketlink-installer-2.7.0.Final.zip
RUN cd $HOME && curl -O http://downloads.jboss.org/picketlink/2/2.7.1.Final/picketlink-installer-2.7.1.Final.zip

#- name: Unarchive picketlink-installer-2.7.0.Final.zip
RUN jar xvf $HOME/picketlink-installer-2.7.1.Final.zip

#- name: Start picketlink for wildfly

RUN cd $HOME/picketlink-installer-2.7.1.Final/ && \
    $HOME/apache-ant-${ANT_VERSION}/bin/ant -Dtarget.container=wildfly -Djboss.as.dist.dir=$HOME/wildfly/ -f $HOME/picketlink-installer-2.7.1.Final/

#- Add aplication rabbitMQ

RUN cd $HOME && curl -O  http://nexus.service.consul:8081/nexus/service/local/repositories/releases/content/org/wildfly/connector/rabbitmq-rar/0.0.1/rabbitmq-rar-0.0.1.rar && mv $HOME/rabbitmq-rar-0.0.1.rar $HOME/wildfly/standalone/deployments



