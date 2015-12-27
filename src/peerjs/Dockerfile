FROM ubuntu:14.04

MAINTAINER miyatama

RUN apt-get -y update && \
  apt-get -y upgrade && \
  apt-get -y install wget git gcc build-essential python curl && \
  apt-get remove --purge node && \
  wget https://nodejs.org/dist/v4.2.3/node-v4.2.3.tar.gz && \
  tar -zxvf node-v4.2.3.tar.gz && \
  cd node-v4.2.3 && \
  ./configure && \
  make && \
  make install && \
  cd .. && \
  rm -r -f -d node-v4.2.3 && \
  rm -f node-v4.2.3.tar.gz && \
  mkdir peerjs && \
  cd peerjs && \
  npm install express && \
  npm install peer && \
  npm install corser && \
  npm install fs && \
  npm install https && \
  mkdir /myapp


COPY ./peerjs-config/run.sh /run.sh
EXPOSE 9000

ENTRYPOINT ["/run.sh"]
CMD ["peerjs"]


