#!/bin/bash

# postfix configuration
echo $HOSTNAME > /etc/mailname
cat /etc/postfix/master-additional.cf >> /etc/postfix/master.cf

# configure mail delivery to dovecot
cp /mailbase/aliases /etc/postfix/virtual
cp /mailbase/domains /etc/postfix/virtual-mailbox-domains

# copy services file & DNS lookup for jailed postfix service
cp /etc/services /var/spool/postfix/etc/services
cp /etc/resolv.conf /var/spool/postfix/etc/resolv.conf

# todo: this could probably be done in one line
mkdir /etc/postfix/tmp; awk < /etc/postfix/virtual '{ print $2 }' > /etc/postfix/tmp/virtual-receivers
sed -r 's,(.+)@(.+),\2/\1/,' /etc/postfix/tmp/virtual-receivers > /etc/postfix/tmp/virtual-receiver-folders
paste /etc/postfix/tmp/virtual-receivers /etc/postfix/tmp/virtual-receiver-folders > /etc/postfix/virtual-mailbox-maps

# map virtual aliases and user/filesystem mappings
postmap /etc/postfix/virtual
postmap /etc/postfix/virtual-mailbox-maps

# add user vmail who own all mail folders
groupadd -g 5000 vmail
mkdir -p /srv/vmail
useradd -g vmail -u 5000 vmail -d /srv/vmail -M
chown -R vmail:vmail /srv/vmail
chmod u+w /srv/vmail

# Add password file
cp /mailbase/passwords /etc/dovecot/passwd

# ssl configuration
sed -i 's/ssl-cert-snakeoil.pem/'${CERTIFICATE}'/g' /etc/postfix/main.cf
sed -i 's/ssl-cert-snakeoil.key/'${KEYFILE}'/g' /etc/postfix/main.cf
sed -i 's/dovecot\/dovecot.pem/ssl\/certs\/'${CERTIFICATE}'/g' /etc/dovecot/conf.d/10-ssl.conf
sed -i 's/dovecot\/private\/dovecot.pem/ssl\/private\/'${KEYFILE}'/g' /etc/dovecot/conf.d/10-ssl.conf
