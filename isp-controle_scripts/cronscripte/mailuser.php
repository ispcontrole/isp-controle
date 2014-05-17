<?
/*
################################################################
#
# $Author: ostoffel $
# $Revision: 199 $
# $LastChangedDate: 2013-10-25 19:26:44 +0200 (Fr, 25 Okt 2013) $
# $URL: https://svn.isp-controle.de/svn/trunk/isp-controle_scripts/cronscripte/mailuser.php $
# $Date: 2013-10-25 19:26:44 +0200 (Fr, 25 Okt 2013) $
# $Id: mailuser.php 199 2013-10-25 17:26:44Z ostoffel $
# $Header: https://svn.isp-controle.de/svn/trunk/isp-controle_scripts/cronscripte/mailuser.php 199 2013-10-25 17:26:44Z ostoffel $
#
#################################################################
*/

$mailusersql = "select 
				  c.systemuser,
				  c.ftpuser,
				  c.mailuser,
				  c.maildomain,
				  c.vhost,
				  c.webdomain,
				  c.subdomain,
				  c.done,
				  m.id,
				  m.guiid,
				  m.maildomainname,
				  m.mailadresse,
				  m.mailpassword,
				  m.changed,
				  m.aktiv
				  from ispcontrole.ispc_crontab as c 
				  LEFT JOIN ispcontrole.ispc_mailaccounts as m
				  on c.guiid = m.guiid	
				  where c.guiid='". mysql_real_escape_string($crontabguiid) ."'
                  and c.mailuser='1'
				  and c.done = '0' 
				  and m.changed != '0'				  
		          order by c.guiid ASC";
$mailuserquery = mysql_query($mailusersql);

while ($mailuser = mysql_fetch_array($mailuserquery)) {
	if ($mailuser['changed'] == 1) {
	 /* Vorebereitung der SQL Inserts */
	 $pw = $mailuser['mailpassword'];
	 $genpw = "/usr/bin/openssl passwd -1 ".$pw;
	 $pwout = exec($genpw);
	 $maildir = maildirhash($mailuser['mailadresse']);
	 $maildomain = $mailuser['maildomainname'];
	 $mailboxsql = "INSERT INTO vmail.mailbox (username, 
												password, 
												name, 
												storagebasedirectory,
												storagenode, 
												maildir, 
												quota, 
												domain, 
												active, 
												local_part, 
												created,
												guiid)  
												VALUES ('".mysql_real_escape_string($mailuser['mailadresse'])."',
												'".$pwout."',
												'".mysql_real_escape_string($mailuser['mailadresse'])."',
												'/var/vmail',
												'vmail1', 
												'".$maildir."', 
												'100',
												'".mysql_real_escape_string($mailuser['maildomainname'])."',
												'1',
												'".mysql_real_escape_string($mailuser['mailadresse'])."',
												NOW( ),
												'". mysql_real_escape_string($crontabguiid) ."')";
	 $mailaliassql = "INSERT INTO vmail.alias (address,
												goto, 
												domain, 
												created, 
												active,
												guiid) 
												VALUES ('".mysql_real_escape_string($mailuser['mailadresse'])."',
												'".mysql_real_escape_string($mailuser['mailadresse'])."',
												'".mysql_real_escape_string($mailuser['maildomainname'])."',
												NOW(),
												'1',
												'". mysql_real_escape_string($crontabguiid) ."')";
		mysql_query($mailboxsql);
		mysql_query($mailaliassql);
		$mailuserchangedsql = "update ispcontrole.ispc_mailaccounts set mailpassword = MD5('".$mailuser['mailpassword']."')changed='0', aktiv='1' where id='". $mailuser['id'] ."'";
		mysql_query($mailuserchangedsql);
		logme('mailuser.php',"Mailbox ". $mailuser['mailadresse'] ." erfolgreich angelegt");


	} /* End Changed = 1 */
	
	if ($mailuser['changed'] == 2) {
	} /* End Changed = 2 */
	
	if ($mailuser['changed'] == 3) {
	} /* End Changed = 3 */

} /* End While */

?>