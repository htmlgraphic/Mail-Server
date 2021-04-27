#!/bin/bash


StartPostfix ()
{
    echo "=> Adding the following credentials $SASL_USER:$SASL_PASS"
    echo "=> Log Key: $LOG_TOKEN"
    #$allow_networks = "";
}


# output logs to logentries.com
cat <<EOF > /etc/rsyslog.d/logentries.conf
\$template Logentries,"$LOG_TOKEN %HOSTNAME% %syslogtag%%msg%\n"

*.* @@api.logentries.com:10000;Logentries
EOF


# configure things
/configure.sh

# for the server sending email without authentication use port 25 relayhost,
# this will disable the authentication attempt = [server.htmlgraphic.com]:25
postconf -e "mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128 172.17.0.0/18 $SMTP_ALLOW_IP"
postconf -e "smtpd_relay_restrictions = permit_mynetworks defer_unauth_destination permit"

# start necessary services for operation (dovecot -F starts dovecot in the foreground to prevent container exit)
chown -R vmail:vmail /srv/vmail

# Display Postfix credentials for build testing
#
StartPostfix


# Spin everything up
#
/usr/bin/supervisord -n -c /etc/supervisor/conf.d/supervisord.conf
