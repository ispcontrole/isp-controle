#!/bin/sh
log="/var/log/ispcontrole_install.log"
touch $log
#################################################################
#
# $Author: jkrugel $
# $Revision: 228 $
# $LastChangedDate: 2014-03-13 20:35:53 +0100 (Do, 13 Mrz 2014) $
# $URL: https://svn.isp-controle.de/svn/trunk/isp-controle_scripts/installscripte/ispc-install.sh $
# $Date: 2014-03-13 20:35:53 +0100 (Do, 13 Mrz 2014) $
# $Id: ispc-install.sh 228 2014-03-13 19:35:53Z jkrugel $
# $Header: https://svn.isp-controle.de/svn/trunk/isp-controle_scripts/installscripte/ispc-install.sh 228 2014-03-13 19:35:53Z jkrugel $
#
##################################################################
timegetstart=`date`

echo "=> Installationsscript gestartet $timegetstart" >> $log  
	apt-get update 
	apt-get -y -qq install dos2unix  
	dos2unix /usr/ispc_inst/*.sh
	dos2unix /usr/ispc_inst/*.php
	dos2unix /usr/ispc_inst/*.cfg
	dos2unix /usr/ispc_inst/*.sql
	dos2unix /usr/ispc_inst/config
 #Vorbereitung Ende 

###################################################################
# ACHTUNG ACHTUNG ACHTUNG ACHTUNG ACHTUNG ACHTUNG ACHTUNG ACHTUNG #
# Diese Installations Script ist nur Lauffaehig unter Debian 7    #
# Wir uebernehmen keinerlei Haftung fuer eventuell auftretende    #
# Fehler, Schaeden und / oder Ausfaelle				  #
###################################################################
	#Read Config

	DPKG=`which dpkg-query`
	APT=`which apt-get`
	DPKGRE=`which dpkg-reconfigure`
	SED=`which sed`
	FQDN=`hostname -f`
	DOM=`hostname -d`
	chmod 755 /usr/ispc_inst/*.sh

. /usr/ispc_inst/ispc.cfg
 

# 21.08.2013 dash und hostname wird konfiguriert
if [ -e dash.lock ]; then
	echo "=> Dash wurde bereits geandert"
		else
		echo "Dash wird konfiguriert"
			export DEBIAN_FRONTEND=readline
			dpkg-reconfigure dash
		# hostname Erstellen
		echo $FQDN > /etc/hostname
		/etc/init.d/hostname.sh start
	touch dash.lock
 fi
# 21.08.2013 dash und hostname wird konfiguriert ENDE

#15.10.2013 Mailsystem vorbereiten und installieren 
if [ -e iredmail.lock ]; then
  echo "=> IredMail wurde bereits installiert"
   else
   cd /usr/ispc_inst/
   wget --no-check-certificate $IREDMAILURL$IREDMAIL
   tar xvf /usr/ispc_inst/$IREDMAIL
   cd /usr/ispc_inst/iRedMail*
   IREDDIR=`pwd`
   cd /usr/ispc_inst/
   cp /usr/ispc_inst/config $IREDDIR/config
   # Variablen ersetzen in der Konfiguration von IRedMail
   $SED -i 's/vmailsqlpw/'$ISPCSQLPW'/' $IREDDIR/config
   $SED -i 's/vmailsqladminpw/'$ISPCSQLPW'/' $IREDDIR/config
   $SED -i 's/ldapsqlpw/'$ISPCSQLPW'/' $IREDDIR/config
   $SED -i 's/ldapsqladminpw/'$ISPCSQLPW'/' $IREDDIR/config
   $SED -i 's/mysqlrootpw/'$MYSQLROOTPW'/' $IREDDIR/config
   $SED -i 's/installdomain/'$INSTALLDOMAIN'/' $IREDDIR/config
   $SED -i 's/installemail/'$INSTALLDOMAIN'/' $IREDDIR/config
   $SED -i 's/domainpwplain/'$ISPCSQLPW'/' $IREDDIR/config
   $SED -i 's/domainpw/'$ISPCSQLPW'/' $IREDDIR/config
   $SED -i 's/sitepw/'$ISPCSQLPW'/' $IREDDIR/config
   $SED -i 's/firstuserpw/'$ISPCSQLPW'/' $IREDDIR/config
   $SED -i 's/firstpwp/'$ISPCSQLPW'/' $IREDDIR/config
   $SED -i 's/iredadminpw/'$ISPCSQLPW'/' $IREDDIR/config
   $SED -i 's/roundcubepw/'$ISPCSQLPW'/' $IREDDIR/config
   $SED -i 's/WEBMAILYESNO/'$WEBMAIL'/' $IREDDIR/config

   
   #15.10.2013 Firewall ja / nein
   $SED -i 's/REPLACEYN/'$FIREWALL'/' /usr/ispc_inst/iredmail.sh
   $SED -i 's/RESTARTYN/'$FIREWALL'/' /usr/ispc_inst/iredmail.sh
   /usr/ispc_inst/iredmail.sh
   if [ $FIREWALL = 'y' ]; then
   #15.10.2013 Firewall anpassen
   #15.10.2013 FTP
   $SED -i 's/COMMIT/-A INPUT -p tcp --dport 20 -j ACCEPT/' /etc/default/iptables
   echo "-A INPUT -p tcp --dport 21 -j ACCEPT" >> /etc/default/iptables
   echo "" >> /etc/default/iptables
   #15.10.2013 DNS
   echo "# DNS " >> /etc/default/iptables
   echo "-A INPUT -p tcp --dport 53 -j ACCEPT" >> /etc/default/iptables
   echo "-A INPUT -p udp --dport 53 -j ACCEPT" >> /etc/default/iptables
   #15.10.2013 ispcontrole vhost
   echo "" >> /etc/default/iptables
   echo "# Ports fuer ISPCONTROLE Vhost" >> /etc/default/iptables
   echo "-A INPUT -p tcp --dport $SSLPORT -j ACCEPT" >> /etc/default/iptables
   echo "-A INPUT -p udp --dport $SSLPORT -j ACCEPT" >> /etc/default/iptables
   echo "" >> /etc/default/iptables
   echo "COMMIT" >> /etc/default/iptables
    fi
 echo "=> Mailsystem erfolgreich installiert"
  touch iredmail.lock
fi

#!/bin/bash
# 21.08.2013 Zeitsync wird installliert 
if [ -e ntpd.lock ]; then
	echo "=> NTPD bereits installiert"
		else
		#Time Synchronisation einstellen
		NTPD="ntp ntpdate"
		echo "NTPD wird installiert"
		for i in $NTPD
			do
				if $DPKG -s $i 2>/dev/null|grep -q installed; then
				echo "Paket $i ist bereits installiert" >> $log
			else
				$APT -y -qq install $i  
			fi
		done
	touch ntpd.lock
	echo "=> NTPD wurde installiert"
fi
# 21.08.2013 Zeitsync wird installliert ENDE

# 21.08.2013 Mysql Datenbanken fuer ispcontrole installieren
mysql -uroot -p$MYSQLROOTPW -e <<EOSQL "CREATE DATABASE ispcontrole;"
EOSQL
mysql -uroot -p$MYSQLROOTPW -e <<EOSQL "CREATE DATABASE phpmyadmin;"
EOSQL
mysql -uroot -p$MYSQLROOTPW -e <<EOSQL "GRANT SELECT, INSERT, DELETE, UPDATE ON `phpmyadmin`.* TO 'pma'@'%' IDENTIFIED BY '$ISPCSQLPW';"
EOSQL
mysql -uroot -p$MYSQLROOTPW -e <<EOSQL "GRANT SELECT, INSERT, DELETE, UPDATE ON `phpmyadmin`.* TO 'pma'@'localhost' IDENTIFIED BY '$ISPCSQLPW';"
EOSQL
mysql -uroot -p$MYSQLROOTPW -e <<EOSQL "GRANT SELECT, INSERT, DELETE, UPDATE ON `phpmyadmin`.* TO 'pma'@'127.0.0.1' IDENTIFIED BY '$ISPCSQLPW';"
EOSQL
mysql -uroot -p$MYSQLROOTPW -e <<EOSQL "GRANT ALL ON *.* TO 'ispcuser'@'%' IDENTIFIED BY '$ISPCSQLPW';"
EOSQL
mysql -uroot -p$MYSQLROOTPW -e <<EOSQL "GRANT ALL ON *.* TO 'ispcuser'@'localhost' IDENTIFIED BY '$ISPCSQLPW';"
EOSQL
mysql -uroot -p$MYSQLROOTPW -e <<EOSQL "GRANT ALL ON *.* TO 'ispcuser'@'127.0.0.1' IDENTIFIED BY '$ISPCSQLPW';"
EOSQL
mysql -uroot -p$MYSQLROOTPW ispcontrole < ispcontrole.sql
mysql -uroot -p$MYSQLROOTPW phpmyadmin < phpmyadmindb.sql
mysql -uroot -p$MYSQLROOTPW vmail < iredmail_table_updates_vmaildb.sql
mysql -uispcuser -p$ISPCSQLPW ispcontrole < trigger.sql


# 14.08.2013 Installation der  Mysql  Datenbanken beendet

# 21.08.2013 Apache Module und Tools werden installiert 
if [ -e apachemodules.lock ]; then
	echo "=> Apache wurde bereits angepasst"
		else
		echo "=> Apache Webserver wird installiert"
		$APACHEMODULES="libexpat1 ssl-cert php5-gd php5-mysql php5-imap php5-curl php5-dev php5-cli php5-cgi libapache2-mod-fcgid apache2-suexec php-pear php-auth php5-mcrypt mcrypt php5-imagick imagemagick libapache2-mod-suphp libruby libapache2-mod-ruby libapache2-mod-python php5-intl php5-memcache php5-memcached php5-ming php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl php5-common memcached"
		export DEBIAN_FRONTEND=noninteractive
		for i in $APACHEMODULES
			do
				if $DPKG -s $i 2>/dev/null|grep -q installed; then
				echo "Paket $i ist bereits installiert" >> $log
			else
				$APT -qq -y install $i  
			fi
		done
		APAMOD=`which a2enmod`
		$APAMOD rewrite suexec ssl actions include dav_fs dav auth_digest
	# SuPHP.conf bearbeiten 
		cp /etc/apache2/mods-available/suphp.conf /etc/apache2/mods-available/suphp.conf.original
		$SED -i 's/<FilesMatch \"\\.ph(p3?|tml)$\">/#<FilesMatch \"\\.ph(p3?|tml)$\">/' /etc/apache2/mods-available/suphp.conf
		$SED -i 's/SetHandler application\/x-httpd-suphp/ #SetHandler application\/x-httpd-suphp/' /etc/apache2/mods-available/suphp.conf
		$SED -i 's/<\/FilesMatch>/ #<\/FilesMatch>/' /etc/apache2/mods-available/suphp.conf
	mkdir -p /var/log/ispcontrole
	chmod 777 /var/log/ispcontrole

	/etc/init.d/apache2 restart  
	touch apachemodules.lock
	echo "=> Apachemodule wurden erfolgreich angepasst und gestartet"
fi 
# 14.08.2013 Installation von Apache beendet

#21.08.2013 Die Security Tools werden installiert 
if [ -e tools.lock ]; then
	echo "=> Securetools bereits installiert"
		else
		echo "Tools werden installiert"
		
 		SECURETOOLS="mc joe sudo zoo unzip arj nomarch cabextract apt-listchanges libnet-ldap-perl libauthen-sasl-perl daemon libio-string-perl libio-socket-ssl-perl libnet-ident-perl zip libnet-dns-perl vlogger webalizer lzop libnet-ldap-perl libauthen-sasl-perl libio-string-perl libio-socket-ssl-perl libnet-ident-perl libnet-dns-perl rkhunter binutils nmap libnet-ph-perl libnet-snpp-perl libnet-telnet-perl pax"
		export DEBIAN_FRONTEND=noninteractive
		for i in $SECURETOOLS
			do
				if $DPKG -s $i 2>/dev/null|grep -q installed; then
				echo "Paket $i ist bereits installiert" >> $log
			else
				$APT -qq -y install $i  
			fi
		done
		
		# Paket wurden installiert nun gehts an die Veränderung der Configdateien
	
	echo "=> Tools erfolgreich installiert"
	touch tools.lock
fi
	# 14.08.2013 Installation von Securetools beendet.

#21.08.2013 FTP Server wird installiert
if [ -e ftpserver.lock ]; then
	echo "=> FTP Server wurde bereits installiert"
		else

		# 14.08.2013 Installation des FTP Servers und Anpassung der Configdatei

			echo "=> FTP Server wird installiert"
			FTPD="pure-ftpd-common pure-ftpd-mysql"
			for i in $FTPD
				do
					if $DPKG -s $i 2>/dev/null|grep -q installed; then
					echo "Paket $i ist bereits installiert" >> $log
				else
					$APT -qq -y install $i  
				fi
			done
		/etc/init.d/pure-ftpd-mysql stop  

		sleep 5
		cp /etc/pure-ftpd/db/mysql.conf /etc/pure-ftpd/db/mysql.conf.old
		$SED -i 's/MYSQLUser       root/MYSQLUser       ispcuser/' /etc/pure-ftpd/db/mysql.conf
		$SED -i 's/MYSQLPassword   rootpw/MYSQLPassword   '$ISPCSQLPW'/' /etc/pure-ftpd/db/mysql.conf
		$SED -i 's/MYSQLDatabase   pureftpd/MYSQLDatabase   ispcontrole/' /etc/pure-ftpd/db/mysql.conf
		$SED -i 's/MYSQLCrypt      cleartext/MYSQLCrypt      md5/' /etc/pure-ftpd/db/mysql.conf
		$SED -i 's/MYSQLGetPW      SELECT Password FROM users WHERE User='\L'/MYSQLGetPW      SELECT ftppassword FROM ispc_ftpusers WHERE ftpuser='\L'/' /etc/pure-ftpd/db/mysql.conf
		$SED -i 's/MYSQLGetDir     SELECT Dir FROM users WHERE User='\L'/MYSQLGetDir		SELECT ftpdir FROM ispc_ftpusers WHERE ftpuser='\L'/' /etc/pure-ftpd/db/mysql.conf

			cp /etc/default/pure-ftpd-common /etc/default/pure-ftpd-common.original
				$SED -i 's/VIRTUALCHROOT=false/VIRTUALCHROOT=true/' /etc/default/pure-ftpd-common
			echo 1 > /etc/pure-ftpd/conf/TLS
			mkdir -p /etc/ssl/private/
				openssl req -x509 -nodes -days 7300 -newkey rsa:2048 -keyout /etc/ssl/private/pure-ftpd.pem -out /etc/ssl/private/pure-ftpd.pem -subj "/C=$SSLCOUNTRY/ST=$SSLSTATE/L=$SSLCITY/O=$FQDN/OU=ispcontrole/CN=$FQDN/emailAddress=$SSLEMAIL"
				chmod 600 /etc/ssl/private/pure-ftpd.pem
			/etc/init.d/pure-ftpd-mysql start  
	 touch ftpserver.lock
	echo "=> FTP Server erfolgreich installiert"
fi
# 14.08.2013 Installation FTP Server abgeschlossen und Cert erstellt

if [ -e quotatools.lock ]; then
	echo "=> Quota Tools bereits installiert"
		 else

		# 14.08.2013 Quota Tools installieren und einrichten

		echo "Einrichten der Quotas und erstellen der Quotafiles"
		QUOTATOOLS="quota quotatool"
			for i in $QUOTATOOLS
				do
					if $DPKG -s $i 2>/dev/null|grep -q installed; then
					echo "Paket $i ist bereits installiert" >> $log
				else
					$APT -qq -y install $i  
				fi
			done

			echo "Wir erstellen eine Sicherheitskopie der Datei /etc/fstab unter dem Namen /etc/fstab.original"
			cp /etc/fstab /etc/fstab.original

			$SED -i 's/\/               ext4    errors=remount-ro 0       1/\/               ext4    errors=remount-ro,usrjquota=quota.user,grpjquota=quota.group,jqfmt=vfsv0 0       1/' /etc/fstab
			$SED -i 's/\/home	ext4	defaults	0	2/\/home	ext4	errors=remount-ro,usrjquota=quota.user,grpjquota=quota.group,jqfmt=vfsv0	0	2/' /etc/fstab
			$SED -i 's/\/var            ext4    defaults        0       2/\/var		ext4	errors=remount-ro,usrjquota=quota.user,grpjquota=quota.group,jqfmt=vfsv0	0	2/' /etc/fstab
			mount -o remount /
			mount -o remount /home
			mount -o remount /var
		quotacheck -avugm
		quotaon -avug
	 touch quotatools.lock
	echo "=> Quota Tools installiert und Quota aktiviert"
	# 15.08.2013 Quota Erstellung abgeschlossen

fi

if [ -e jailkit.lock ]; then
	echo "Jailkit ist bereits installiert"
		else
			BUILDTOOLS="build-essential autoconf automake1.9 libtool flex bison dpkg-dev debhelper binutils-gold tcl expect"
			echo "Buildtools werden installiert in Vorbereitung auf JailKit"
		for i in $BUILDTOOLS
			do
				if $DPKG -s $i 2>/dev/null|grep -q installed; then
				echo "Paket $i ist bereits installiert" >> $log
			else
				$APT -qq -y install $i  
			fi
		done
	wget http://olivier.sessink.nl/jailkit/jailkit-2.16.tar.gz  
		tar xvfz jailkit-2.16.tar.gz  
		cd jailkit-2.16
		./debian/rules binary  
		cd ..
	dpkg -i jailkit_2.16-1_*.deb  
	rm -rf jailkit-2.16*
	touch jailkit.lock
	echo "=> Jailkit wurde installiert"
 fi

# 25.10.2013 BIND DNS wird isntalliert

	BIND9DNS="bind9 bind9utils"
		if [ -e bind9dns.lock ]; then
			echo "=> Bind9 DNS wurde bereits installiert\n"
		else
			echo "=> Bind9 DNS wird installiert"
		for i in $BIND9DNS
			do
				if $DPKG -s $i 2>/dev/null|grep -q installed; then
				echo "Paket $i ist bereits installiert" >> $log
			else
				$APT -qq -y install $i  
			fi
		done
	# 27.10.2013 Konfiguration des Namesservers fuer unsere Zonendateien :
	echo "include \"/etc/bind/named.conf.ispcontrole.zones\";" >> /etc/bind/named.conf
	touch /etc/bind/named.conf.ispcontrole.zones
	echo "// ##############################################################################################################" >> /etc/bind/named.conf.ispcontrole.zones
	echo "// # !!!!!!!!!!!!!!!!!!!!! Hier eingetragene ZoneFiles wurden durch ISP-CONTROLE generiert  !!!!!!!!!!!!!!!!!!! #" >> /etc/bind/named.conf.ispcontrole.zones
	echo "// # Bitte keine Aenderungen durchfuehren da diese automtisch geloescht werden bei der Aenderung durch ISPC-GUI #" >> /etc/bind/named.conf.ispcontrole.zones
	echo "// ##############################################################################################################" >> /etc/bind/named.conf.ispcontrole.zones
	mkdir -p /var/log/named
	chmod 0777 /var/log/named
	#27.10.2013 Logging fuer BIND aktvieren 
		echo "logging {" >> /etc/bind/named.conf
		echo "channel bind9log {" >> /etc/bind/named.conf
		echo " file \"/var/log/named/bind9.log\" versions 3 size 10m;" >> /etc/bind/named.conf
		echo " severity dynamic;" >> /etc/bind/named.conf
		echo " print-time yes;" >> /etc/bind/named.conf
		echo " print-severity yes;" >> /etc/bind/named.conf
		echo " print-category yes;" >> /etc/bind/named.conf
		echo "};" >> /etc/bind/named.conf
		echo "channel security {" >> /etc/bind/named.conf
		echo " file \"/var/log/named/security\" versions 2 size 5m;" >> /etc/bind/named.conf
		echo " severity dynamic;" >> /etc/bind/named.conf
		echo " print-time yes;" >> /etc/bind/named.conf
		echo " print-severity yes;" >> /etc/bind/named.conf
		echo " print-category yes;" >> /etc/bind/named.conf
		echo "};" >> /etc/bind/named.conf
		echo " category default {bind9log;};" >> /etc/bind/named.conf
		echo " category security {security;};" >> /etc/bind/named.conf
		echo " category lame-servers {null;};" >> /etc/bind/named.conf
		echo "};" >> /etc/bind/named.conf
		echo "" >> /etc/bind/named.conf

	touch bind9dns.lock 
	
   fi
	echo "=> Bind9 DNS wurde erfolgreich installiert"

	# 25.10.2013 Einige Systemuser erstellen
	# 16.08.2013 Erstellen des Users ispcuser
	useradd -d /var/opt/ispcontrole -m -s /bin/bash -G users ispcuser
	echo ispcuser:$ISPCUSERPW |chpasswd
	# 16.08.2013 Erstellen des Users ispcusers ende

	#10.09.2013 Erstellen des Users Admin	
	useradd -d /home/admin -m -s /bin/bash -G users admin
	echo admin:admin |chpasswd
	addgroup webusers

	# 10.09.2013 Estellen des Users Admin ende

	cp /usr/ispc_inst/ispcontrole.conf /etc/apache2/sites-available/ispcontrole.conf
	/usr/ispc_inst/ssl-install.sh
	/usr/ispc_inst/phpcopy.sh
	echo "=>  Die Installation von ISP-Controle ist abeschlossen. Wir wuenschen viel Spass"
	timegetend=`date`
	echo "=> Installationsscript wurde beendet $timegetend"  >> $log 
  exit 0
