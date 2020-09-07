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

FROM epamedp/edp-jenkins-base-agent:1.0.0

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV GRADLE_VERSION=6.2.2 \
    PATH=$PATH:/opt/gradle/bin

USER root

# Install Gradle
RUN curl -skL -o /tmp/gradle-bin.zip https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip && \
    curl https://raw.githubusercontent.com/cloudrouter/centos-repo/master/CentOS-Base.repo -o /etc/yum.repos.d/CentOS-Base.repo && \
    mkdir -p /opt/gradle && \
    unzip -q /tmp/gradle-bin.zip -d /opt/gradle && \
    ln -sf /opt/gradle/gradle-$GRADLE_VERSION/bin/gradle /usr/local/bin/gradle

RUN yum install java-11-openjdk-devel.x86_64 -y && \
    rpm -V java-11-openjdk-devel.x86_64 && \
    yum clean all -y

WORKDIR $HOME/.gradle

RUN chown -R "1001:0" "$HOME" && \
    chmod -R "g+rw" "$HOME"

USER 1001
