#!/bin/bash
################################################################
#
# $Author: ostoffel $
# $Revision: 222 $
# $LastChangedDate: 2014-03-01 16:20:58 +0100 (Sa, 01 Mrz 2014) $
# $URL: https://svn.isp-controle.de/svn/trunk/isp-controle_scripts/installscripte/ssl-install.sh $
# $Date: 2014-03-01 16:20:58 +0100 (Sa, 01 Mrz 2014) $
# $Id: ssl-install.sh 222 2014-03-01 15:20:58Z ostoffel $
# $Header: https://svn.isp-controle.de/svn/trunk/isp-controle_scripts/installscripte/ssl-install.sh 222 2014-03-01 15:20:58Z ostoffel $
#
#################################################################
if [ -e sslcert.lock ]; then
 echo "SSL Cert wurde bereits installiert"
 else

# 22.08.2013 SSL fuer ispcontrole  Host einrichten und entsprechendes DOCRoot und WWRoot Verzeichnis anlegen !
. /usr/ispc_inst/ispc.cfg
#Anfuegen des Ports fuer SSL
echo "=> Host wird angelegt und weitere Dateien werden verarbeitet"

echo "<IfModule mod_ssl.c>" >> /etc/apache2/ports.conf
echo "    Listen $SSLPORT" >> /etc/apache2/ports.conf
echo "</IfModule>" >> /etc/apache2/ports.conf
echo " " >> /etc/apache2/ports.conf
echo "<IfModule mod_gnutls.c>" >> /etc/apache2/ports.conf
echo "    Listen $SSLPORT" >> /etc/apache2/ports.conf
echo "</IfModule>" >> /etc/apache2/ports.conf

#22.08.2013 Eintraege erledigt

#Anlegen des Virtuellen Hosts fuer ispcontrole ueber SSL
 touch /etc/apache2/sites-available/ispcontrole.vhost
echo "<IfModule mod_ssl.c>" >> /etc/apache2/sites-available/ispcontrole.vhost
echo "<VirtualHost *:$SSLPORT>" >> /etc/apache2/sites-available/ispcontrole.vhost
echo "	ServerAdmin webmaster@localhost" >> /etc/apache2/sites-available/ispcontrole.vhost
echo "	DocumentRoot /var/opt/ispcontrole/www" >> /etc/apache2/sites-available/ispcontrole.vhost
echo "	<Directory />" >> /etc/apache2/sites-available/ispcontrole.vhost
echo "		Options FollowSymLinks" >> /etc/apache2/sites-available/ispcontrole.vhost
echo "		AllowOverride None" >> /etc/apache2/sites-available/ispcontrole.vhost
echo "	</Directory>" >> /etc/apache2/sites-available/ispcontrole.vhost
echo "	<Directory /var/opt/ispcontrole/www/>" >> /etc/apache2/sites-available/ispcontrole.vhost
echo "		Options Indexes FollowSymLinks MultiViews" >> /etc/apache2/sites-available/ispcontrole.vhost
echo "		AllowOverride None" >> /etc/apache2/sites-available/ispcontrole.vhost
echo "		Order allow,deny" >> /etc/apache2/sites-available/ispcontrole.vhost
echo "		allow from all" >> /etc/apache2/sites-available/ispcontrole.vhost
echo "	</Directory>" >> /etc/apache2/sites-available/ispcontrole.vhost
echo " " >> /etc/apache2/sites-available/ispcontrole.vhost
echo "	ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/" >> /etc/apache2/sites-available/ispcontrole.vhost
echo "	<Directory \"/usr/lib/cgi-bin\">" >> /etc/apache2/sites-available/ispcontrole.vhost
echo "		AllowOverride None" >> /etc/apache2/sites-available/ispcontrole.vhost
echo "		Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch" >> /etc/apache2/sites-available/ispcontrole.vhost
echo "		Order allow,deny" >> /etc/apache2/sites-available/ispcontrole.vhost
echo "		Allow from all" >> /etc/apache2/sites-available/ispcontrole.vhost
echo "	</Directory>" >> /etc/apache2/sites-available/ispcontrole.vhost
echo "	ErrorLog /var/log/apache2/ssl_ispcontrole_error.log" >> /etc/apache2/sites-available/ispcontrole.vhost
echo "	LogLevel warn" >> /etc/apache2/sites-available/ispcontrole.vhost
echo " " >> /etc/apache2/sites-available/ispcontrole.vhost
echo "	CustomLog /var/log/apache2/ssl_ispcontrole_access.log combined" >> /etc/apache2/sites-available/ispcontrole.vhost
echo " " >> /etc/apache2/sites-available/ispcontrole.vhost
echo "	SSLEngine on" >> /etc/apache2/sites-available/ispcontrole.vhost
echo " " >> /etc/apache2/sites-available/ispcontrole.vhost
echo "	SSLCertificateFile    /var/opt/ispcontrole/ssl/ispcontrole.crt" >> /etc/apache2/sites-available/ispcontrole.vhost
echo "	SSLCertificateKeyFile /var/opt/ispcontrole/ssl/ispcontrole.key" >> /etc/apache2/sites-available/ispcontrole.vhost
echo " " >> /etc/apache2/sites-available/ispcontrole.vhost
echo "	<FilesMatch \"\\.(cgi|shtml|phtml|php)\$\">" >> /etc/apache2/sites-available/ispcontrole.vhost
echo "		SSLOptions +StdEnvVars" >> /etc/apache2/sites-available/ispcontrole.vhost
echo "	</FilesMatch>" >> /etc/apache2/sites-available/ispcontrole.vhost
echo "	<Directory /usr/lib/cgi-bin>" >> /etc/apache2/sites-available/ispcontrole.vhost
echo "		SSLOptions +StdEnvVars" >> /etc/apache2/sites-available/ispcontrole.vhost
echo "	</Directory>" >> /etc/apache2/sites-available/ispcontrole.vhost
echo " " >> /etc/apache2/sites-available/ispcontrole.vhost
echo "	BrowserMatch \"MSIE [2-6]\" \\" >> /etc/apache2/sites-available/ispcontrole.vhost
echo "		nokeepalive ssl-unclean-shutdown \\" >> /etc/apache2/sites-available/ispcontrole.vhost
echo "		downgrade-1.0 force-response-1.0" >> /etc/apache2/sites-available/ispcontrole.vhost
echo "	BrowserMatch \"MSIE [17-9]\" ssl-unclean-shutdown" >> /etc/apache2/sites-available/ispcontrole.vhost
echo " " >> /etc/apache2/sites-available/ispcontrole.vhost
echo "</VirtualHost>" >> /etc/apache2/sites-available/ispcontrole.vhost
echo "</IfModule>" >> /etc/apache2/sites-available/ispcontrole.vhost
# 23.08.2013 Verzeichnisse erstellen für WWW und SSL
mkdir /var/opt/ispcontrole/www
chown www-data:www-data /var/opt/ispcontrole/www
chmod 777 /var/opt/ispcontrole/www
mkdir /var/opt/ispcontrole/ssl
chmod 755 /var/opt/ispcontrole/ssl

# 23.08.2013 Erstellung des Zertifikats für ISPCONTROLE

FQDN=`hostname -f`
openssl genrsa -out /var/opt/ispcontrole/ssl/ispcontrole.key 2048
openssl req  -new -key /var/opt/ispcontrole/ssl/ispcontrole.key -out /var/opt/ispcontrole/ssl/ispcontrole.csr -subj "/C=$SSLCOUNTRY/ST=$SSLSTATE/L=$SSLCITY/O=$FQDN/OU=ispcontrole/CN=$FQDN/emailAddress=$SSLEMAIL"
openssl req -noout -text -in /var/opt/ispcontrole/ssl/ispcontrole.csr
openssl x509 -days 7200  -req -in /var/opt/ispcontrole/ssl/ispcontrole.csr -signkey /var/opt/ispcontrole/ssl/ispcontrole.key -out /var/opt/ispcontrole/ssl/ispcontrole.crt
chmod -R 755 /var/opt/ispcontrole/ssl
# 23.08.2013 SSL Zertifikat wurde erstellt.

# 23.08.2013 Anlegenen Einer HTML Standardseite fuer den ISPCONTROLE Host.
touch /var/opt/ispcontrole/www/index.html
echo "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">" >> /var/opt/ispcontrole/www/index.html
echo "<html>" >> /var/opt/ispcontrole/www/index.html
echo " <head>" >> /var/opt/ispcontrole/www/index.html
echo "  <title>ISP-CONTROLE</title>" >> /var/opt/ispcontrole/www/index.html
echo "  <meta name=\"Generator\" content=\"isp-controle\">" >> /var/opt/ispcontrole/www/index.html
echo "  <meta name=\"Author\" content=\"ispcontrole\">" >> /var/opt/ispcontrole/www/index.html
echo "  <meta name=\"Keywords\" content=\"ispcontrole , webadmin, serveradmin\">" >> /var/opt/ispcontrole/www/index.html
echo "  <meta name=\"Description\" content=\"Administration\">" >> /var/opt/ispcontrole/www/index.html
echo " </head>" >> /var/opt/ispcontrole/www/index.html
echo " " >> /var/opt/ispcontrole/www/index.html
echo " <body>" >> /var/opt/ispcontrole/www/index.html
echo "  <h1> Na haben wir uns verlaufen ? </h1>" >> /var/opt/ispcontrole/www/index.html
echo " </body>" >> /var/opt/ispcontrole/www/index.html
echo "</html>" >> /var/opt/ispcontrole/www/index.html



echo "NameVirtualHost *:80" >> /etc/apache2/sites-available/ispcontrole.conf
echo "NameVirtualHost *:443" >> /etc/apache2/sites-available/ispcontrole.conf
echo "NameVirtualHost $EXTERNALIP:$SSLPORT" >> /etc/apache2/sites-available/ispcontrole.conf
echo "NameVirtualHost $EXTERNALIP:80" >> /etc/apache2/sites-available/ispcontrole.conf
echo "NameVirtualHost $EXTERNALIP:443" >> /etc/apache2/sites-available/ispcontrole.conf


a2ensite ispcontrole.vhost
a2ensite ispcontrole.conf

/etc/init.d/apache2 restart

touch /usr/ispc_inst/sslcert.lock
echo "=> SSLCert wurde erfolgreich erstellt und Vhost entsprechend konfiguriert"
fi