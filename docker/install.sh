#!/bin/bash

dockerDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

instDocker(){
  if ! [ -x "$(command -v docker )" ]; then
    echo "INSTALLING docker"
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
  fi
  echo "DOCKER ready"
}

instCompose(){
  if ! [ -x "$(command -v docker-compose )" ]; then
    echo "INSTALLING docker-compose"
    sudo apt install -y libffi-dev libssl-dev
    sudo apt install -y python3-dev
    sudo apt install -y python3 python3-pip
    sudo pip3 install docker-compose
  fi
  echo "DOCKER-COMPOSE ready"
}

instComposeService(){
  instDocker
  instCompose

  service="$1" #technical name
  serviceName="$2" # human readable
  qualified="/etc/systemd/system/${service}.service"
  if ! [ -f "${qualified}" ]; then
    echo "INSTALLING ${service} service"
    srvFile="${dockerDir}/${service}.service"
    cat "${dockerDir}/compose.service.template" | 
      sed -e "s|__WORKDIR__|${PWD}|g" |
      sed -e "s|__SERVICE__|${serviceName}|g" |
      tee "${srvFile}"
    sudo mv "${dockerDir}/${service}.service" "${qualified}"
    sudo systemctl enable ${service}
    sudo systemctl start ${service}
    sleep 3 # mini time to start img resolving
  fi
  echo "SERVICE ${service} ready"
}

