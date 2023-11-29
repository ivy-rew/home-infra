#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cat $DIR/fastBoot.config.txt | sudo tee -a /boot/config.txt
