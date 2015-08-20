FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive
RUN locale-gen en_US en_US.UTF-8 && dpkg-reconfigure locales
RUN apt-get update && apt-get -y install \
    openssl && apt-get clean && rm -rf /var/lib/apt/lists/*

ADD ./domains /mailbase/domains
ADD ./aliases /mailbase/aliases
ADD ./passwords /mailbase/passwords

ADD ./certs /etc/ssl/certs
ADD ./private /etc/ssl/private

ADD ./dovecot-openssl.cnf /dovecot-openssl.cnf
ADD ./mkcert.sh	/mkcert.sh
RUN chmod 755 /mkcert.sh
RUN sh /mkcert.sh

VOLUME ["/mailbase", "/etc/ssl"]
