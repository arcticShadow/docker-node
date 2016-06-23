FROM       ubuntu:15.04
MAINTAINER Cole

# curl & python
RUN apt-get update && apt-get install -y curl

# NVM Variables
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 5.11.1

# setup an init system
RUN curl -o- https://github.com/Yelp/dumb-init/releases/download/v1.0.3/dumb-init_1.0.3_amd64 > /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init

# Run NVM install script and install version
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.1/install.sh | bash \
  && . $NVM_DIR/nvm.sh \
  && nvm install $NODE_VERSION \
  && nvm alias default $NODE_VERSION \
  && nvm use default

# Setup New ENV Vars
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/v$NODE_VERSION/bin:$PATH

# Python for node-gyp
RUN apt-get update && apt-get install -y python2.7
RUN echo python=/usr/bin/python2.7 >> ~/.npmrc

#Make, for node-gyp
RUN apt-get update && apt-get install -y build-essential

# Create the node app directory
RUN mkdir -p /data/app

ENTRYPOINT ["/bin/bash", "-i", "-c"]
# CMD ["npm", "install"]
# ENTRYPOINT ["/usr/local/bin/dumb-init", "-c", "--"]
