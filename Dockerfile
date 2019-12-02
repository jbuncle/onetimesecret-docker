FROM ruby:2.4

# Install dependencies
RUN apt-get update \
    && apt-get install -y build-essential \
    && apt-get install -y ntp libyaml-dev libevent-dev zlib1g zlib1g-dev openssl libssl-dev libxml2 libreadline-gplv2-dev curl

WORKDIR /root/sources
ENV ONETIME_HOME=/root/sources/onetimesecret

# Install One-Time Secret
RUN curl -L -O https://github.com/onetimesecret/onetimesecret/archive/master.tar.gz \
    && tar xzf master.tar.gz \
    && mv onetimesecret-master ${ONETIME_HOME} \
    && cd ${ONETIME_HOME} \
    && bundle install --frozen --deployment --without=dev \
    && bin/ots init \
    && useradd -ms /bin/bash ots \
    && cd ${ONETIME_HOME} \
    && mkdir /var/log/onetime /var/run/onetime /var/lib/onetime \
    && chown -R ots:ots /var/log/onetime /var/run/onetime /var/lib/onetime

VOLUME /var/opt/onetime
WORKDIR /root/sources/onetimesecret-master
ADD entrypoint.sh /entrypoint.sh 
CMD /entrypoint.sh

EXPOSE 7143

