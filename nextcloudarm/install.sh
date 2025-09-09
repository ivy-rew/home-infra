#!/bin/bash

nDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. "${nDir}/../docker/install.sh"

instNextCloudService(){
  instComposeService "compose.nextcloud" "NextCloud"
}

nextConfigAlias(){
  hasAlias=`alias | grep nca`
  if [ -z "${hasAlias}" ]; then
    aliases="$HOME/.bash_aliases"
    echo 'alias nca="env --chdir ~/home-infra/nextcloudarm -S docker compose"' >> "${aliases}"
    echo 'alias occ="nca exec --user www-data app php occ"' >> "${aliases}"
    . "${aliases}" # re-load
  fi
  echo "ALIAS ncp... ready"
}

instNextCloudService
nextConfigAlias
