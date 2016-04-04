#!/bin/bash


StartPostfix ()
{
    echo "=> Adding the following credentials $SASLUSER:$SASLPASS"
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

# start necessary services for operation (dovecot -F starts dovecot in the foreground to prevent container exit)
chown -R vmail:vmail /srv/vmail

# Display Postfix credentials for build testing
#
StartPostfix


# Spin everything up
#
/usr/bin/supervisord -n -c /etc/supervisor/conf.d/supervisord.conf