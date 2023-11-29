#!/bin/bash

nDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. "${nDir}/../docker/install.sh"

instNextCloudService(){
  instComposeService "compose.nextcloud" "NextCloud"
}

nextConfigAlias(){
  hasAlias=`alias | grep ncp-config`
  if [ -z "${hasAlias}" ]; then
    aliases="$HOME/.bash_aliases"
    echo 'alias ncp="docker exec -it nextcloudpi"' >> "${aliases}"
    echo 'alias ncp-config="ncp ncp-config"' >> "${aliases}"
    . "${aliases}" # re-load
  fi
  echo "ALIAS ncp... ready"
}

instNextCloudService
nextConfigAlias
