<?
/*
################################################################
#
# $Author: ostoffel $
# $Revision: 187 $
# $LastChangedDate: 2013-10-18 14:11:54 +0200 (Fr, 18 Okt 2013) $
# $URL: https://svn.isp-controle.de/svn/trunk/isp-controle_scripts/cronscripte/vhost.php $
# $Date: 2013-10-18 14:11:54 +0200 (Fr, 18 Okt 2013) $
# $Id: vhost.php 187 2013-10-18 12:11:54Z ostoffel $
# $Header: https://svn.isp-controle.de/svn/trunk/isp-controle_scripts/cronscripte/vhost.php 187 2013-10-18 12:11:54Z ostoffel $
#
#################################################################
*/
/*
Legende : 
		changed 0 | 1 | 2
			   0 => Nichtstun
			   1 => Anlegen
			   2 => entfernen
			   3 => Aenderung
*/

$vhostssql = "SELECT v.* , u.username FROM ispcontrole.ispc_vhosts AS v
			  LEFT JOIN ispcontrole.ispc_user AS u 
			  ON v.guiid = u.guiid
			  WHERE v.guiid = '". mysql_real_escape_string($crontabguiid) ."'
			  AND v.aktiv = '0'
			  ORDER BY v.guiid ASC";

$vhostsquery = mysql_query($vhostssql);
	while ($vhost = mysql_fetch_array($vhostsquery)) {
		if ($vhost['changed'] == 1) {
		/* 
		Verzeichnisse anlegen 
		*/

		$docroot = "/var/www/". $vhost['guiid'] ."/". $vhost['vhost_name']. "/htdocs";
		$docrootssl = "/var/www/". $vhost['guiid'] ."/". $vhost['vhost_name']. "/sslhtdocs";
		$ssl	 = "/var/www/". $vhost['guiid'] ."/". $vhost['vhost_name']. "/ssl";
		$log	 = "/var/www/". $vhost['guiid'] ."/". $vhost['vhost_name']. "/logs";	
		$cgibin	 = "/var/www/". $vhost['guiid'] ."/". $vhost['vhost_name']. "/cgi-bin";
		$webdav  = "/var/www/". $vhost['guiid'] ."/". $vhost['vhost_name']. "/webdav";
		$temp	 = "/var/www/". $vhost['guiid'] ."/". $vhost['vhost_name']. "/tmp";

		$vhfile = "/etc/apache2/sites-available/". $vhost['guiid'] . "-". $vhost['vhost_name'].".vhost";
		$siteon = $vhost['guiid'] . "-". $vhost['vhost_name'].".vhost";
		$vhcontent  = "<Directory /var/www/". $vhost['guiid'] ."/". $vhost['vhost_name']. ">\n";
		$vhcontent .= "		AllowOverride None\n";
		$vhcontent .= "		Order Deny,Allow\n";
		$vhcontent .= "		Deny from all\n";
		$vhcontent .= "</Directory>\n";
		$vhcontent .= "<VirtualHost ". $vhost['vhostip']. ":80>\n";
		$vhcontent .= "		DocumentRoot ". $docroot ."\n";
		$vhcontent .= "		\n";
		$vhcontent .= "		ServerName ". $vhost['vhost_name']. "\n";
		$vhcontent .= "		ServerAlias www.". $vhost['vhost_name'] ."\n";
		$vhcontent .= "		ServerAdmin webmaster@". $vhost['vhost_name'] ."\n";
		$vhcontent .= "		\n";
		$vhcontent .= "	ErrorLog ". $log ."/". $vhost['vhost_name'] ."_error.log\n";
		$vhcontent .= "	\n";
		$vhcontent .= "<IfModule mod_ssl.c>\n";
		$vhcontent .= "	\n";
		$vhcontent .= "</IfModule>\n";
		$vhcontent .= "	\n";
		$vhcontent .= "<Directory ". $docroot .">\n";
		$vhcontent .= "		Options FollowSymLinks\n";
		$vhcontent .= "		AllowOverride All\n";
		$vhcontent .= "		Order allow,deny\n";
		$vhcontent .= "		Allow from all\n";
		$vhcontent .= "	\n";
		$vhcontent .= "		# ssi enabled\n";
		$vhcontent .= "		AddType text/html .shtml\n";
		$vhcontent .= "		AddOutputFilter INCLUDES .shtml\n";
		$vhcontent .= "		Options +Includes\n";
		$vhcontent .= "</Directory>\n";
		$vhcontent .= "<Directory ". $docroot .">\n";
		$vhcontent .= "		Options FollowSymLinks\n";
		$vhcontent .= "		AllowOverride All\n";
		$vhcontent .= "		Order allow,deny\n";
		$vhcontent .= "		Allow from all\n";
		$vhcontent .= "	\n";
		$vhcontent .= "		# ssi enabled\n";
		$vhcontent .= "		AddType text/html .shtml\n";
		$vhcontent .= "		AddOutputFilter INCLUDES .shtml\n";
		$vhcontent .= "		Options +Includes\n";
		$vhcontent .= "</Directory>\n";
		$vhcontent .= "<IfModule mod_ruby.c>\n";
		$vhcontent .= "	<Directory ". $docroot .">\n";
		$vhcontent .= "		Options +ExecCGI\n";
		$vhcontent .= "	</Directory>\n";
		$vhcontent .= "		RubyRequire apache/ruby-run\n";
		$vhcontent .= "		#RubySafeLevel 0\n";
		$vhcontent .= "		AddType text/html .rb\n";
		$vhcontent .= "		AddType text/html .rbx\n";
		$vhcontent .= "	<Files *.rb>\n";
		$vhcontent .= "		SetHandler ruby-object\n";
		$vhcontent .= "		RubyHandler Apache::RubyRun.instance\n";
		$vhcontent .= "	</Files>\n";
		$vhcontent .= "	<Files *.rbx>\n";
		$vhcontent .= "		SetHandler ruby-object\n";
		$vhcontent .= "		RubyHandler Apache::RubyRun.instance\n";
		$vhcontent .= "	</Files>\n";
		$vhcontent .= "</IfModule>\n";
		$vhcontent .= "\n";
		$vhcontent .= "<IfModule mod_perl.c>\n";
		$vhcontent .= "		PerlModule ModPerl::Registry\n";
		$vhcontent .= "		PerlModule Apache2::Reload\n";
		$vhcontent .= "<Directory ". $docroot .">\n";
		$vhcontent .= "		PerlResponseHandler ModPerl::Registry\n";
		$vhcontent .= "		PerlOptions +ParseHeaders\n";
		$vhcontent .= "		Options +ExecCGI\n";
		$vhcontent .= "	</Directory>\n";
        $vhcontent .= "    <Files *.pl>\n";
		$vhcontent .= "		SetHandler perl-script\n";
        $vhcontent .= "    </Files>\n";
		$vhcontent .= "</IfModule>\n";
		$vhcontent .= "\n";
		$vhcontent .= "<IfModule mod_python.c>\n";
		$vhcontent .= "	<Directory ". $docroot .">\n";
		$vhcontent .= "		AddHandler mod_python .py\n";
		$vhcontent .= "		PythonHandler mod_python.publisher\n";
		$vhcontent .= "		PythonDebug On\n";
		$vhcontent .= "</Directory>\n";
		$vhcontent .= "</IfModule>\n";
		$vhcontent .= "# cgi enabled\n";
		$vhcontent .= "		<Directory ". $cgibin .">\n";
		$vhcontent .= "	Order allow,deny\n";
		$vhcontent .= "	Allow from all\n";
		$vhcontent .= "</Directory>\n";
		$vhcontent .= "\n";
		$vhcontent .= "ScriptAlias  /cgi-bin/ ". $cgibin ."/\n";
		$vhcontent .= "AddHandler cgi-script .cgi\n";
		$vhcontent .= "AddHandler cgi-script .pl\n";
		$vhcontent .= "# Clear PHP settings of this website\n";
		$vhcontent .= "<FilesMatch \"\.ph(p3?|tml)$\">\n";
		$vhcontent .= "		SetHandler None\n";
		$vhcontent .= "</FilesMatch>\n";
		$vhcontent .= "# mod_php enabled\n";
		$vhcontent .= "AddType application/x-httpd-php .php .php3 .php4 .php5\n";
		$vhcontent .= "php_admin_value sendmail_path \"/usr/sbin/sendmail -t -i -fwebmaster@". $vhost['vhost_name'] ."\n";
		$vhcontent .= "php_admin_value upload_tmp_dir ". $temp ."\n";
		$vhcontent .= "php_admin_value session.save_path ". $temp ."\n";
		$vhcontent .= "\n";
		$vhcontent .= "\n";
		$vhcontent .= "# add support for apache mpm_itk\n";
		$vhcontent .= "<IfModule mpm_itk_module>\n";
		$vhcontent .= "	AssignUserId ". $vhost['username'] ." webusers\n";
		$vhcontent .= "</IfModule>\n";
		$vhcontent .= "\n";
		$vhcontent .= "<IfModule mod_dav_fs.c>\n";
		$vhcontent .= "# Do not execute PHP files in webdav directory\n";
		$vhcontent .= "	<Directory ". $webdav .">\n";
		$vhcontent .= "		<ifModule mod_security2.c>\n";
		$vhcontent .= "			SecRuleRemoveById 960015\n";
		$vhcontent .= "			SecRuleRemoveById 960032\n";
		$vhcontent .= "		</ifModule>\n";
		$vhcontent .= "		<FilesMatch \"\.ph(p3?|tml)$\">\n";
		$vhcontent .= "			SetHandler None\n";
		$vhcontent .= "		</FilesMatch>\n";
		$vhcontent .= "	</Directory>\n";
		$vhcontent .= "	DavLockDB ". $temp ."/DavLock\n";
		$vhcontent .= "	# DO NOT REMOVE THE COMMENTS!\n";
		$vhcontent .= "	# IF YOU REMOVE THEM, WEBDAV WILL NOT WORK ANYMORE!\n";
		$vhcontent .= " # WEBDAV BEGIN\n";
		$vhcontent .= "	# WEBDAV END\n";
		$vhcontent .= "</IfModule>\n";
		$vhcontent .= "</VirtualHost>\n";

		$handle = fopen($vhfile, "w+");
		fwrite ($handle, $vhcontent);
		fclose ($handle);
	/* 
		Vhost erstellt und nun Verzeichnisse anlegen 
	*/
		exec("mkdir -p ".$docroot);
		exec("mkdir -p ".$docrootssl);
		exec("mkdir -p ".$ssl);
		exec("mkdir -p ".$log);
		exec("mkdir -p ".$cgibin);
		exec("mkdir -p ".$webdav);
		exec("mkdir -p ".$temp);

		exec("chown -R ".$vhost['username'].".webusers /var/www/".$vhost['guiid']."/");
		
		$a2ensite = "/usr/sbin/a2ensite";
	/* 
	Site aktiviren 
	*/
		exec($a2ensite. " ". $siteon);
		$reload_apache = "/etc/init.d/apache2 restart";
		exec($reload_apache);
		logme('vhost.php',$a2ensite. " ".$siteon);
	/*
	Site in der DB auf aktiv setzen 
	*/
		$updatesql = "update ispcontrole.ispc_vhosts set changed='0' , aktiv='1'
		where id='". mysql_real_escape_string($vhost['id']) ."' 
		and guiid='". mysql_real_escape_string($vhost['guiid']) ."'";
		mysql_query($updatesql);
	/*
	Site in der DB auf Aktiv setzen ENDE 
	*/
	/*
	Site in Webdomain eintragen und auf aktiv setzen
	*/
		$sqlwebdomain = "insert into ispcontrole.ispc_webdomain 
		(id, guiid,	domainname, changed, aktiv) 
		VALUES ('', '". mysql_real_escape_string($vhost['guiid']) ."', '". mysql_real_escape_string($vhost['vhost_name']) ."', '0', '1')";
		mysql_query($sqlwebdomain);
		logme('vhost.php',"Vhost ". $vhost['vhost_name'] ." wurde erfolgreich angelegt und aktiviert");
	/*
	Site in Webdomain eintragen und auf aktiv setzen ENDE
	*/
		} 
		/* Ende changed = 1 */

		if ($vhost['changed'] == 2) {
		/*
		Hier wird der VHOST entfernt 
		*/
		$a2dissite = "/usr/sbin/a2dissite";
		} /* Ende changed = 2 */

		if ($vhost['changed'] == 3) {
		/*
		Hier wird der VHOST geaendert
		*/
		$a2dissite = "/usr/sbin/a2dissite";
		$a2ensite = "/usr/sbin/a2ensite";

		} /* Ende changed = 3 */

		
	}
	
?>