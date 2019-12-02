#! /bin/bash
set -e

# Set password and host based on environment variables
sed -i "s/user:CHANGEME@127.0.0.1:7179/user:${REDIS_PASSWORD}@${REDIS_HOST}:7179/" /etc/onetime/config

# Replace host
sed -i "s/  :host: localhost:7143/  :host: ${EXTERNAL_HOST}/" /etc/onetime/config

# Replace domain
sed -i "s/  :domain: localhost/  :domain: ${VIRTUAL_HOST}/" /etc/onetime/config

# Set whether site is SSL
sed -i "s/  :ssl: false/  :ssl: ${SSL}/" /etc/onetime/config

# Generate secret and store it, then replace into config
test -f  /var/opt/onetime/secret || echo $(openssl rand -hex 32) >>  /var/opt/onetime/secret
sed -i "s/  :secret: CHANGEME/  :secret: $(cat  /var/opt/onetime/secret)/" /etc/onetime/config

# Disable example colonels
sed -i "s/- CHANGEME@EXAMPLE.com/#- CHANGEME@EXAMPLE.com/" /etc/onetime/config

echo 'map("/img/") { run Rack::File.new("#{PUBLIC_DIR}/img") }' >> config.ru
echo 'map("/js/") { run Rack::File.new("#{PUBLIC_DIR}/js") }' >> config.ru
echo 'map("/css/") { run Rack::File.new("#{PUBLIC_DIR}/css") }' >> config.ru

# cat config.ru
bundle exec thin -R config.ru -p 7143 start
