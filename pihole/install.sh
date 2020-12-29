#!/bin/bash

instDocker(){
  if ! [ -x "$(command -v docker )" ]; then
   echo "INSTALLING docker"
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
  fi
}

instCompose(){
  if ! [ -x "$(command -v docker-compose )" ]; then
    echo "INSTALLING docker-compose"
    sudo apt install -y libffi-dev libssl-dev
    sudo apt install -y python3-dev
    sudo apt install -y python3 python3-pip
    sudo pip3 install docker-compose
  fi
}

instPiholeService(){
  dns="/etc/systemd/system/compose.pihole.service"
  if ! [ -f "${dns}" ]; then
    echo "INSTALLING pihole SystemD service"
    sed -e "s|__WORKDIR__|${PWD}|g" pihole.service.template > compose.pihole.service
    sudo mv compose.pihole.service "${dns}"
    sudo systemctl enable compose.pihole
  fi
}

setupFiles(){
  dnsLog="$(pwd)/var-log/pihole.log"
  if ! [ -f "${dnsLog}" ]; then
    touch "${dnsLog}"
  fi
}

sudo apt update && sudo apt upgrade

instDocker
instCompose
setupFiles
instPiholeService
