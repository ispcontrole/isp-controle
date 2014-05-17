<?PHP
/*
################################################################
#
# $Author: ostoffel $
# $Revision: 202 $
# $LastChangedDate: 2013-10-26 00:46:48 +0200 (Sa, 26 Okt 2013) $
# $URL: https://svn.isp-controle.de/svn/trunk/isp-controle_scripts/cronscripte/cronscript.php $
# $Date: 2013-10-26 00:46:48 +0200 (Sa, 26 Okt 2013) $
# $Id: cronscript.php 202 2013-10-25 22:46:48Z ostoffel $
# $Header: https://svn.isp-controle.de/svn/trunk/isp-controle_scripts/cronscripte/cronscript.php 202 2013-10-25 22:46:48Z ostoffel $
#
#################################################################
*/

/*
Datenbank einbinden 
*/
include "/var/opt/ispcontrole/cronscripte/db.inc.php";

database_open ();


$cronsql="select * from ispcontrole.ispc_crontab where done = '0'";
$cronquery = mysql_query($cronsql);
while($crontab = mysql_fetch_array($cronquery))	{
	if ($crontab['systemuser'] == 1) {
		$crontabid = $crontab['id'];
		$crontabguiid = $crontab['guiid'];
		include "/var/opt/ispcontrole/cronscripte/shelluser.php";
	}
		if ($crontab['mailuser'] == 1) {
		$crontabid = $crontab['id'];
		$crontabguiid = $crontab['guiid'];
		include "/var/opt/ispcontrole/cronscripte/mailuser.php";
	}
		if ($crontab['maildomain'] == 1) {
		$crontabid = $crontab['id'];
		$crontabguiid = $crontab['guiid'];
		include "/var/opt/ispcontrole/cronscripte/maildomain.php";
	}
		if ($crontab['vhost'] == 1) {
		$crontabid = $crontab['id'];
		$crontabguiid = $crontab['guiid'];
		include "/var/opt/ispcontrole/cronscripte/vhost.php";
	}
		if ($crontab['webdomain'] == 1) {
		$crontabid = $crontab['id'];
		$crontabguiid = $crontab['guiid'];
		include "/var/opt/ispcontrole/cronscripte/webdomain.php";
	}
		if ($crontab['subdomain'] == 1) {
		$crontabguiid = $crontab['guiid'];
		include "/var/opt/ispcontrole/cronscripte/subdomain.php";
	}
		if ($crontab['dns'] == 1) {
		$crontabguiid = $crontab['guiid'];
		include "/var/opt/ispcontrole/cronscripte/dnsupdate.php";
	}

	$sql_crondone="update ispcontrole.ispc_crontab set time='".time()."', done='1' where id='". mysql_real_escape_string($crontab['id']) ."'";
	mysql_query($sql_crondone);
}
?>
