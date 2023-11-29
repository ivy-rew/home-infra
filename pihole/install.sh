#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. "$DIR/../docker/install.sh"

instPiholeService(){
  instComposeService "compose.pihole" "Pihole DNS"
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

piholeAlias(){
  hasAlias=`alias | grep pihole`
  if [ - "${hasAlias}" ]; then
    piCmd="docker exec -it $(docker ps | grep pihole | awk '{ print $1 }') pihole"
    aliases="$HOME/.bash_aliases"
    echo "alias pihole=\"${piCmd}\"" >> "${aliases}"
    . "${aliases}"
  fi
}

piholePass(){
  piholeAlias #setup container hock
  echo "Please set the pihole webfrontend password:"
  pihole -a -p
}

if ! [ "$1" = "test" ]; then
  sudo apt update && sudo apt upgrade
  instDocker
  instCompose
  setupFiles
  instPiholeService
  localDns
  localDhcp
  piholeAlias
  piholePass
fi
