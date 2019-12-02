#! /bin/bash
set -e

# Set password and host based on environment variables
sed -i "s/user:CHANGEME@127.0.0.1:7179/user:${REDIS_PASSWORD}@${REDIS_HOST}:7179/" ${ONETIME_HOME}/etc/config

# Replace host
sed -i "s/  :host: localhost:7143/  :host: ${EXTERNAL_HOST}/" ${ONETIME_HOME}/etc/config

# Replace domain
sed -i "s/  :domain: localhost/  :domain: ${VIRTUAL_HOST}/" ${ONETIME_HOME}/etc/config

# Set whether site is SSL
sed -i "s/  :ssl: false/  :ssl: ${SSL}/" ${ONETIME_HOME}/etc/config

# Generate secret and store it, then replace into config
test -f  /var/opt/onetime/secret || echo $(openssl rand -base64 32) >>  /var/opt/onetime/secret
sed -i "s/  :secret: CHANGEME/  :secret: $(cat  /var/opt/onetime/secret)/" ${ONETIME_HOME}/etc/config

# Disable example colonels
sed -i "s/- CHANGEME@EXAMPLE.com/#- CHANGEME@EXAMPLE.com/" ${ONETIME_HOME}/etc/config


#cat ${ONETIME_HOME}/etc/config

cd ${ONETIME_HOME}
bundle exec thin -R ${ONETIME_HOME}/config.ru -p 7143 start
