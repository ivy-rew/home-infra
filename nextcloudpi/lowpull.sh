#!/bin/bash

## throttle hungry processes
sudo cpulimit -e /usr/bin/unpigz -l 10 &
sudo cpulimit -e /usr/bin/dockerd -l 10 &

sudo cpulimit -e php -l 10 &
sudo cpulimit -e pigz -l 2 &
sudo cpulimit -e wget -l 20 &
sudo cpulimit -e mysqld -l 8 &

sudo ./cpulimit-all.sh --limit=5 \
    -e php -e pigz -e wget -e /usr/bin/dockerd -e wget -e mysqld -e tar \
    --watch-interval=10s

docker compose pull

