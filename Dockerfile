#
# Copyright 2019 JSquad AB
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

FROM debian:stretch-slim as module

RUN  apt-get update \
  && apt-get install -y wget unzip
RUN cd / && wget https://cdn.mysql.com//Downloads/Connector-J/mysql-connector-java-8.0.17.tar.gz && \
tar xvzf mysql-connector-java-8.0.17.tar.gz && rm mysql-connector-java-8.0.17.tar.gz && \
wget http://ftp.fau.de/eclipse/rt/eclipselink/releases/2.7.4/eclipselink-2.7.4.v20190115-ad5b7c6b2a.zip && \
unzip eclipselink-2.7.4.v20190115-ad5b7c6b2a.zip -d .

FROM jboss/wildfly:16.0.0.Final

ENV WILDFLY_HOME /opt/jboss/wildfly

COPY configuration/jboss/standalone.xml $WILDFLY_HOME/standalone/configuration/.
COPY configuration/jboss/module/mysql $WILDFLY_HOME/modules/system/layers/base/com/mysql
COPY configuration/jboss/module/eclipselink $WILDFLY_HOME/modules/system/layers/base/org/eclipse/persistence/
COPY --from=module /mysql-connector-java-8.0.17/mysql-connector-java-8.0.17.jar \
$WILDFLY_HOME/modules/system/layers/base/com/mysql/main/.
COPY --from=module /eclipselink/jlib/eclipselink.jar \
$WILDFLY_HOME/modules/system/layers/base/org/eclipse/persistence/main/.

RUN $WILDFLY_HOME/bin/add-user.sh --silent admin admin1234
RUN $WILDFLY_HOME/bin/add-user.sh -a -g admin --silent root root
RUN $WILDFLY_HOME/bin/add-user.sh -a -g customer --silent john doe

COPY ear/target/openbank-1.0-SNAPSHOT.ear $WILDFLY_HOME/standalone/deployments/openbank-1.0-SNAPSHOT.ear

EXPOSE 8080 9990

CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]