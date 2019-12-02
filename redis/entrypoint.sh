#! /bin/bash
set -e

# Set password based on Envrionment variable definition
sed -i "s/# requirepass CHANGEME/requirepass '${REDIS_PASSWORD}'/" /redis.conf

# Don't deamonise (we need to run in the foreground)
sed -i "s/daemonize yes/daemonize no/" /redis.conf

# Disable logging to file (log to stdout)
sed -i "s/logfile/#logfile/" /redis.conf

# As we're running in docker, we can't restrict to a specific IP, so allow any IP
# Docker locks down the network anyway
sed -i "s/bind 127.0.0.1/#bind 127.0.0.1/" /redis.conf

# cat /redis.conf
redis-server /redis.conf