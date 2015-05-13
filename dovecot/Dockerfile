FROM ubuntu:14.04 

# Install self-signed ssl certs
# Install postfix as MTA
# Install dovecot as IMAP server
RUN apt-get update && apt-get -yq install --force-yes ssl-cert \
	postfix \
	dovecot-imapd \
	supervisor \ 
    rsyslog && apt-get clean && rm -rf /var/lib/apt/lists/*


# SUPERVISOR
RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/

# postfix configuration
ADD ./postfix.main.cf /etc/postfix/main.cf
ADD ./postfix.master.cf.append /etc/postfix/master-additional.cf
ADD ./postfix.sh /opt/postfix.sh
RUN chmod 755 /opt/postfix.sh && cp /etc/hostname /etc/mailname

# dovecot configuration
ADD ./dovecot.mail /etc/dovecot/conf.d/10-mail.conf
ADD ./dovecot.ssl /etc/dovecot/conf.d/10-ssl.conf
ADD ./dovecot.auth /etc/dovecot/conf.d/10-auth.conf
ADD ./dovecot.master /etc/dovecot/conf.d/10-master.conf
ADD ./dovecot.lda /etc/dovecot/conf.d/15-lda.conf
ADD ./dovecot.imap /etc/dovecot/conf.d/20-imap.conf
# add verbose logging
#ADD ./internal/dovecot.logging /etc/dovecot/conf.d/10-logging.conf

# Note that EXPOSE only works for inter-container links. It doesn't make ports accessible from the host. To expose port(s) to the host, at runtime, use the -p flag.

# SMTP Port for incoming mail
EXPOSE 25 
# IMAP Port
EXPOSE 143
# SMTP Port for outgoing mail
EXPOSE 587

# todo: enable port 587 for outgoing mail, separate ports 25 and 587
# http://www.synology-wiki.de/index.php/Zusaetzliche_Ports_fuer_Postfix

# add script to configure container
ADD ./configure.sh /configure.sh
RUN chmod 755 /configure.sh

# add script to run at container start
ADD ./run.sh /run.sh
RUN chmod 755 /run.sh

ENV MAILNAME imap-test.htmlgraphic.com
ENV CERTIFICATE dovecot.pem
ENV KEYFILE dovecot.pem

# start necessary services for operation
CMD ["/run.sh"]
