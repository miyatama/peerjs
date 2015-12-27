#!/bin/bash

function run(){
  docker-compose stop
  docker-compose rm -f
  docker-compose up -d
}

function getContainerName(){
  containerName=""
  case "${1}" in
  peerjs)
    containerName="peerjs"
    ;;
  frontend)
    containerName="peerjsfrontend"
    ;;
  esac
  echo "${containerName}"
}

function console(){
  containerName=getContainerName "${1}"
  if [ "${containerName}" == "" ] ; then
    echo "Uses ./run.sh console <container>"
    echo "  container : [ peerjs | frontend ]"
  else
    result=`docker ps | grep "${containerName}"`
    containerid=`echo "${result}" | sed -e "s/\([0-9a-zA-Z]\+\).*/\1/g"`
    docker exec -it "${containerid}" /bin/bash
  fi
}

function configure(){
  rm -f -r -d ./sslkey
  mkdir sslkey
  #ca key generate
  openssl genrsa -out "./sslkey/ca.key" 2048
  openssl req -new -key "./sslkey/ca.key" -out "./sslkey/ca.csr"
  openssl x509 -req -days 365 \
    -in "./sslkey/ca.csr" \
    -signkey "./sslkey/ca.key" \
    -out "./sslkey/ca.crt"

  #server key generate
  openssl genrsa -out "./sslkey/server.key" 2048
  openssl req -new -key "./sslkey/server.key" -out "./sslkey/server.csr"
  openssl x509 -req -days 365 \
    -in "./sslkey/server.csr" \
    -signkey "./sslkey/server.key" \
    -out "./sslkey/server.crt"

  openssl rsa -in "./sslkey/server.key" -pubout -out "./sslkey/public.pem"

  rm -f -r -d ./conf
  mkdir ./conf
  cd conf
  ln -s ../src/peerjsfrontend/peerjsfrontend-config 
  ln -s ../src/peerjs/peerjs-config 
  cd ..
}

function getBuildTargetDirectory(){
  target=""
  case "${1}" in
  frontend)
    target="./src/peerjsfrontend"
    ;;
  peerjs)
    target="./src/peerjs"
    ;;
  esac
  echo "${target}"
}

function build(){
  case "${1}" in
  full)
    currentDir=`pwd`
    targetDirectory=`getBuildTargetDirectory "frontend"`
    cd "${targetDirectory}/"
    ./build.sh
    cd "${currentDir}"
    targetDirectory=`getBuildTargetDirectory "peerjs"`
    cd "${targetDirectory}/"
    ./build.sh
    cd "${currentDir}"
    ;;
  *)
    targetDirectory=`getBuildTargetDirectory "${1}"`
    if [ "${targetDirectory}" != "" ]; then
      currentDir=`pwd`
      cd "${targetDirectory}/"
      ./build.sh
      cd "${currentDir}"
    else
      echo "Uses ./run.sh build [option]"
      echo "  option : [ full | frontend | peerjs ]"
    fi
    ;;
  esac
}

function getBuildStatus(){
  targetDirectory=`getBuildTargetDirectory "${1}"`
  result=`tail -n 1 "${targetDirectory}/build.log" | grep "Successfully"`
  buildResult="false"
  if [ "${result}" != "" ] ; then
    buildResult="true"
  fi
  echo "${buildResult}"
}

function showStatus(){
  case "${1}" in
  build)
    buildResult=`getBuildStatus frontend`
    echo "frontend : ${buildResult}"
    buildResult=`getBuildStatus peerjs`
    echo "peerjs : ${buildResult}"
    ;;
  *)
    echo "Uses ./run.sh status <option>"
    echo "  option : [ build ]"
    ;;
  esac
}

subcmd="run"
if [ "${1}" != "" ] ;then
  subcmd="${1}"
fi

case "${subcmd}" in
build)
  build "${2}"
  ;;
run) 
  run
  ;;
console) 
  console "${2}"
  ;;
configure)
  configure
  ;;
status)
  showStatus "${2}"
  ;;
special)
  echo "miyatama need money"
*)
  echo "Usage ./run.sh <command> <option>"
  echo "Command : [ build | run | console | configure | status | special ]"
  ;;
esac
