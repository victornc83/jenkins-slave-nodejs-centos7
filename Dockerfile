FROM victornc83/jenkins-slave-base-centos7

MAINTAINER Victor Nieto <victornc83@gmail.com>

ENV NODEJS_VERSION=6.11 \
    NPM_CONFIG_PREFIX=$HOME/.npm-global \
    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH \
    BASH_ENV=/usr/local/bin/scl_enable \
    ENV=/usr/local/bin/scl_enable \
    PROMPT_COMMAND=". /usr/local/bin/scl_enable" \
    CHROME_BIN=/opt/google/chrome/chrome

COPY contrib/bin/scl_enable /usr/local/bin/scl_enable

# Install NodeJS
RUN yum install -y centos-release-scl-rh && \
    INSTALL_PKGS="rh-nodejs6 rh-nodejs6-npm rh-nodejs6-nodejs-nodemon libffi-devel ruby-devel rubygems" && \
    ln -s /opt/rh/rh-nodejs6/root/usr/lib/node_modules/nodemon/bin/nodemon.js /usr/bin/nodemon && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y
# Install Google Chrome    
RUN curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm && \
    yum -y install ./google-chrome-stable_current_x86_64.rpm && \
    rm -f ./google-chrome-stable_current_x86_64.rpm
# Install ruby SASS gem dependency
RUN gem install sass
# Install AWS-CLI tool
RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" && \
    unzip awscli-bundle.zip && \
    ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws && \
    rm -rf awscli-bundle*

RUN chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME

USER 1001
