# Copyright 2020 EPAM Systems.



# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0



# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.



# See the License for the specific language governing permissions and
# limitations under the License.

FROM openshift/jenkins-slave-base-centos7:v3.11

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV GRADLE_VERSION=6.2.2 \
    OPENJDK_VERSION=11.0.2 \
    PATH=$PATH:/opt/gradle/bin

# Install Java 11
RUN curl -L --output /tmp/jdk11.tar.gz https://download.java.net/java/GA/jdk11/9/GPL/openjdk-${OPENJDK_VERSION}_linux-x64_bin.tar.gz && \
	tar zxf /tmp/jdk11.tar.gz -C /usr/lib/jvm && \
	rm /tmp/jdk11.tar.gz && \
	update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-${OPENJDK_VERSION}/bin/java 20000 --family java-1.11-openjdk.x86_64 && \
	update-alternatives --set java /usr/lib/jvm/jdk-${OPENJDK_VERSION}/bin/java

RUN yum remove java-1.8.0-openjdk-headless -y

# Install Gradle
RUN curl -LOk https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip && \
    unzip gradle-${GRADLE_VERSION}-bin.zip -d /opt && \
    rm -f gradle-${GRADLE_VERSION}-bin.zip && \
    ln -s /opt/gradle-${GRADLE_VERSION} /opt/gradle

WORKDIR $HOME/.gradle

RUN chown -R "1001:0" "$HOME" && \
    chmod -R "g+rw" "$HOME"

COPY contrib/bin/run-jnlp-client /usr/local/bin/

USER 1001