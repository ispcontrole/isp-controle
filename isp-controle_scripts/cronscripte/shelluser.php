<?
/*
################################################################
#
# $Author: ostoffel $
# $Revision: 187 $
# $LastChangedDate: 2013-10-18 14:11:54 +0200 (Fr, 18 Okt 2013) $
# $URL: https://svn.isp-controle.de/svn/trunk/isp-controle_scripts/cronscripte/shelluser.php $
# $Date: 2013-10-18 14:11:54 +0200 (Fr, 18 Okt 2013) $
# $Id: shelluser.php 187 2013-10-18 12:11:54Z ostoffel $
# $Header: https://svn.isp-controle.de/svn/trunk/isp-controle_scripts/cronscripte/shelluser.php 187 2013-10-18 12:11:54Z ostoffel $
#
#################################################################
*/

$shellsql = "select * from ispc_user where guiid = '". mysql_real_escape_string($crontabguiid) ."'";
$shellquery = mysql_query($shellsql);
 /*
Legende : 
		changed 0 | 1 | 2 
			   0 => Nichtstun
			   1 => Anlegen
			   2 => entfernen

*/

	while ($shelluser = mysql_fetch_array($shellquery)) {
		if ($shelluser['changed'] == 1) {
			$useranlegen = "useradd -d /home/".$shelluser['username']." -m -s /bin/false -g webusers ".$shelluser['username']."";
			logme('shelluser.php',$useranlegen);
			exec($useranlegen);
			$userpw = "echo ".$shelluser['username'].":".$shelluser['password']." |chpasswd";
			logme('shelluser.php',$userpw);
			exec($userpw);
			$userpwmd5 = md5($shelluser['password']);
			$usersql="update ispc_user set password='". mysql_real_escape_string($userpwmd5) ."', changed='0', aktiv='1' where guiid='". mysql_real_escape_string($crontabguiid) ."'";
			logme('shelluser.php',"Benutzer : " . $shelluser['username'] . " wurde erfolgreich angelegt. ");
			mysql_query($usersql);
		}
		if ($shelluser['changed'] == 2) {
			$userentfernen="userdel -f -r ". $shelluser['username'];
			exec($userentfernen);
			logme('shelluser.php',$userentfernen);
			/* Benutzer aus allen Tabellen entfernen und entsprechend vorhandene Verzeichnisse im System ebenfalls loeschen */

			$userdelsql="delete from ispc_user where guiid='". mysql_real_escape_string($crontabguiid) ."' LIMIT 1";
			$userdelsql1="delete from ispc_ftpuser where guiid='". mysql_real_escape_string($crontabguiid) ."'";
			$userdelsql2="delete from ispc_accounting where guiid='". mysql_real_escape_string($crontabguiid) ."'";
			$userdelsql3="delete from ispc_keys where guiid='". mysql_real_escape_string($crontabguiid) ."'";
			$userdelsql4="delete from ispc_mailaccounts where guiid='". mysql_real_escape_string($crontabguiid) ."'";
			$userdelsql5="delete from ispc_mail_domain where guiid='". mysql_real_escape_string($crontabguiid) ."'";
			$userdelsql6="delete from ispc_subdomain where guiid='". mysql_real_escape_string($crontabguiid) ."'";
			$userdelsql7="delete from ispc_vhosts where guiid='". mysql_real_escape_string($crontabguiid) ."'";
			$userdelsql8="delete from ispc_webdomain where guiid='". mysql_real_escape_string($crontabguiid) ."'";
			$userdelsql9="delete from vmail.domain where guiid='". mysql_real_escape_string($crontabguiid) ."'";
			$userdelsql10="delete from vmail.alias where guiid='". mysql_real_escape_string($crontabguiid) ."'";
			$userdelsql11="delete from vmail.mailbox where guiid='". mysql_real_escape_string($crontabguiid) ."'";

			logme('shelluser.php',"Der Benutzer mit der Guiid : ". $crontabguiid . "wurde erfolgreich geloescht !");
			
			@mysql_query($userdelsql);
			@mysql_query($userdelsq2);
			@mysql_query($userdelsq3);
			@mysql_query($userdelsq4);
			@mysql_query($userdelsq5);
			@mysql_query($userdelsq6);
			@mysql_query($userdelsq7);
			@mysql_query($userdelsq8);
			@mysql_query($userdelsq9);
			@mysql_query($userdelsql0);
			@mysql_query($userdelsql1);
		}
		
	}

?>