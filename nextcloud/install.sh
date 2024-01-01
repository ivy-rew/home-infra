#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. "$DIR/../docker/install.sh"

instNextService(){
  instComposeService "compose.nextcloud" "NextCloud"
}

if ! [ "$1" = "test" ]; then
  sudo apt update && sudo apt upgrade
  instNextService
fi
