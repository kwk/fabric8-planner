FROM centos:7
ENV LANG=en_US.utf8

# gpg keys listed at https://github.com/nodejs/node
RUN set -ex \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
    gpg --keyserver keyserver.pgp.com --recv-keys "$key" ; \
  done

#ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 6.9.2

RUN yum install -y bzip2 fontconfig java-1.8.0-openjdk nmap-ncat psmisc git \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
  && yum install google-chrome-stable xorg-x11-server-Xvfb xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic -y

RUN yum install python-setuptools -y
RUN easy_install supervisor
RUN yum install xorg-x11-xauth -y
RUN yum install which -y

COPY google-chrome.repo /etc/yum/repos.d/google-chrome.repo
RUN yum install google-chrome-stable -y

#RUN yum install wget
#RUN wget http://chrome.richardlloyd.org.uk/install_chrome.sh
#RUN chmod +x ./install_chrome.sh && ./install_chrome.sh --stable --force
RUN yum clean all

ENV FABRIC8_USER_NAME=fabric8

RUN useradd --user-group --create-home --shell /bin/false ${FABRIC8_USER_NAME}

ENV HOME=/home/${FABRIC8_USER_NAME}

ENV WORKSPACE=$HOME/fabric8-planner
RUN mkdir $WORKSPACE

COPY . $WORKSPACE
RUN chown -R ${FABRIC8_USER_NAME}:${FABRIC8_USER_NAME} $HOME/*

USER ${FABRIC8_USER_NAME}
WORKDIR $WORKSPACE/
#RUN /usr/bin/Xvfb :99 -ac -screen 0 1024x768x24 &
ENV DISPLAY=:99

VOLUME /dist

#ENTRYPOINT ["/bin/bash"]
ENTRYPOINT ["/usr/bin/supervisord"]

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf