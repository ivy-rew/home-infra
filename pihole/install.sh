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
  logDir="$(pwd)/var-log"
  dnsLog="${logDIR}/pihole.log"
  if ! [ -f "${dnsLog}" ]; then
    mkdir -p "${logDir}"
    touch "${dnsLog}"
  fi
}

localDns(){
  resolve="/etc/resolv.conf"
  cp -v "${resolve}" ./resolve.conf.bkp
  echo "nameserver 127.0.0.1" > "resolve.conf"
  sudo mv -v "resolve.conf" "$resolve"
  echo "updated $resolve"
}

localDhcp(){
  dhcp="/etc/dhcpcd.conf"
  cp -v "$dhcp" ./dhcpcd.conf
  printf "\n#pihole\ninterface eth0\nstatic domain_name_servers=127.0.0.1\n" >> "dhcpcd.conf"
  sudo mv -v "dhcpcd.conf" "$dhcp"
  echo "updated $dhcp"
}

if ! [ "$1" = "test" ]; then
  sudo apt update && sudo apt upgrade
  instDocker
  instCompose
  setupFiles
  instPiholeService
  localDns
  localDhcp
fi
