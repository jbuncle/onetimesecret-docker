FROM redis:5.0
ADD https://raw.githubusercontent.com/onetimesecret/onetimesecret/master/etc/redis.conf /redis.conf

ADD entrypoint.sh /entrypoint.sh 
CMD /entrypoint.sh

RUN mkdir -p /var/run/onetime /var/log/onetime /var/lib/onetime/
EXPOSE 7179