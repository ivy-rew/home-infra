#!/bin/bash
# generate a self-signed cert: lasting for 10 years
openssl req -new -x509 -nodes -out server.crt -keyout server.key -days 3650
