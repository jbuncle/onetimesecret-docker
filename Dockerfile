FROM ruby:2.4

# Install dependencies
RUN apt-get update \
    && apt-get install -y build-essential \
    && apt-get install -y ntp libyaml-dev libevent-dev zlib1g zlib1g-dev openssl libssl-dev libxml2 libreadline-gplv2-dev curl

RUN useradd -ms /bin/bash ots \
    && mkdir /var/opt/onetime /etc/onetime  /var/lib/onetime \
    && chown ots /var/opt/onetime /etc/onetime /var/lib/onetime

USER ots
WORKDIR /home/ots
RUN curl -L -O https://github.com/onetimesecret/onetimesecret/archive/master.tar.gz \
    && tar xzf master.tar.gz \
    && mv onetimesecret-master onetimesecret
WORKDIR onetimesecret
RUN bundle install --frozen --deployment --without=dev \
    && bin/ots init \
    && cp -R etc/* /etc/onetime/

USER root
VOLUME /var/opt/onetime
ADD entrypoint.sh /entrypoint.sh 
CMD /entrypoint.sh

EXPOSE 7143