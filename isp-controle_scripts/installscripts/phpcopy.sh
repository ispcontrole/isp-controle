#!/bin/bash
if [ -e phpcopy.lock ]; then
 echo "PHPCopy wurde bereits durchgefuehrt"
 else
##############################################################
#
# $Author: ostoffel $
# $Revision: 222 $
# $LastChangedDate: 2014-03-01 16:20:58 +0100 (Sa, 01 Mrz 2014) $
# $URL: https://svn.isp-controle.de/svn/trunk/isp-controle_scripts/installscripte/phpcopy.sh $
# $Date: 2014-03-01 16:20:58 +0100 (Sa, 01 Mrz 2014) $
# $Id: phpcopy.sh 222 2014-03-01 15:20:58Z ostoffel $
# $Header: https://svn.isp-controle.de/svn/trunk/isp-controle_scripts/installscripte/phpcopy.sh 222 2014-03-01 15:20:58Z ostoffel $
#
##############################################################

. /usr/ispc_inst/ispc.cfg

# Kontstrukt zum ändern und erstellen des PWs, und diese an die richtige Stelle verschieben
OLDPW="/usr/ispc_inst/pw.php"
NEWPW="/var/opt/ispcontrole/www/$PHPDATEI.php"
OLDKEY="/usr/ispc_inst/ma.php"
NEWKEY="/var/opt/ispcontrole/www/$PHPDATEI.key.php"
OLDDBINC="/usr/ispc_inst/zd.php"
NEWDBINC="/var/opt/ispcontrole/www/$PHPDATEI.inc.php"
OLDPWSH="/usr/ispc_inst/pwandern.sh"
NEWPWSH="/var/opt/ispcontrole/$PHPDATEI.sh"

sed -i 's/include "zd.php";/include "'$PHPDATEI'.inc.php";/' /usr/ispc_inst/pw.php
sed -i 's/$ispc = "";/$ispc = "'$ISPCSQLPW'";/' /usr/ispc_inst/zd.php
sed -i 's/\$shellscript = "sudo \/var\/opt\/ispcontrole\/pwandern.sh"\;/\$shellscript = "sudo \/var\/opt\/ispcontrole\/'$PHPDATEI'.sh"\;/' /usr/ispc_inst/pw.php 
cp /etc/sudoers /etc/sudoers.original
sed -i 's/# User privilege specification/# User privilege specification\nwww-data ALL=NOPASSWD: \/var\/opt\/ispcontrole\/'$PHPDATEI'.sh/' /etc/sudoers
cp $OLDPW $NEWPW
cp $OLDDBINC $NEWDBINC
cp $OLDPWSH $NEWPWSH
cp $OLDKEY $NEWKEY
chmod 755 $NEWPWSH
chown ispcuser.ispcuser $NEWPWSH

# kopieren der Cronscripte
mkdir /var/opt/ispcontrole/cronscripte
chown ispcuser.ispcuser /var/opt/ispcontrole/cronscripte
chmod 777 /var/opt/ispcontrole/cronscripte

cp /usr/isp_inst/PHPMailerAutoload.php /var/opt/ispcontrole/www/PHPMailerAutoload.php
cp /usr/isp_inst/class.pop3.php /var/opt/ispcontrole/www/class.pop3.php
cp /usr/isp_inst/class.smtp.php /var/opt/ispcontrole/www/class.smtp.php
cp /usr/ispc_inst/cronscript.php /var/opt/ispcontrole/cronscripte/cronscript.php
cp /usr/ispc_inst/db.inc.php /var/opt/ispcontrole/cronscripte/db.inc.php
cp /usr/ispc_inst/dnsupdate.php /var/opt/ispcontrole/cronscripte/dnsupdate.php
cp /usr/ispc_inst/maildomain.php /var/opt/ispcontrole/cronscripte/maildomain.php
cp /usr/ispc_inst/mailuser.php /var/opt/ispcontrole/cronscripte/mailuser.php
cp /usr/ispc_inst/shelluser.php /var/opt/ispcontrole/cronscripte/shelluser.php
cp /usr/ispc_inst/vhost.php /var/opt/ispcontrole/cronscripte/vhost.php

chmod 755 /var/opt/ispcontrole/cronscripte/*.php

# 17.10.2013 Datenbankpws eintragen
sed -i 's/\$ispcontroledbpass="";/\$ispcontroledbpass="'$ISPCSQLPW'";/' /var/opt/ispcontrole/cronscripte/db.inc.php
sed -i 's/\$mailboxdbpass="";/\$mailboxdbpass="'$ISPCSQLPW'";/' /var/opt/ispcontrole/cronscripte/db.inc.php

# 09.09.2013 phpmyadmin downloaden und als / sqladmin ins ssl Verzeichnis kopieren
cd /tmp
wget http://downloads.sourceforge.net/project/phpmyadmin/phpMyAdmin/4.0.8/phpMyAdmin-4.0.8-all-languages.tar.gz
tar -xvzf phpMyAdmin-4.0.8-all-languages.tar.gz
rm -rf phpMyAdmin-4.0.8-all-languages.tar.gz
mv phpMyAdmin-4.0.8-all-languages /var/opt/ispcontrole/www/sqladmin
cp /usr/ispc_inst/config.inc.php /var/opt/ispcontrole/www/sqladmin/config.inc.php
sed -i 's/pmapassword/'$ISPCSQLPW''/ /var/opt/ispcontrole/www/sqladmin/config.inc.php
chown -R ispcuser.ispcuser /var/opt/ispcontrole/www/sqladmin
chmod -R 755 /var/opt/ispcontrole/www/sqladmin
touch /usr/ispc_inst/phpcopy.lock
echo "=> PHPCopy erfolgreich abgeschlossen"
sed -i 's/# configuration for php MING module/\/*# configuration for php MING module*\//' /etc/php5/conf.d/ming.ini
fi