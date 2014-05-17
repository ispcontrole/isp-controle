<?
/*
################################################################
#
# $Author: ostoffel $
# $Revision: 193 $
# $LastChangedDate: 2013-10-18 18:40:59 +0200 (Fr, 18 Okt 2013) $
# $URL: https://svn.isp-controle.de/svn/trunk/isp-controle_scripts/cronscripte/maildomain.php $
# $Date: 2013-10-18 18:40:59 +0200 (Fr, 18 Okt 2013) $
# $Id: maildomain.php 193 2013-10-18 16:40:59Z ostoffel $
# $Header: https://svn.isp-controle.de/svn/trunk/isp-controle_scripts/cronscripte/maildomain.php 193 2013-10-18 16:40:59Z ostoffel $
#
#################################################################
*/

/*
Legende : 
		changed
		0 | 1 | 2
			   0 => Nichtstun
			   1 => Anlegen
			   2 => Entfernen
*/
$maildomainsql = "select 
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
				  m.changed,
				  m.aktiv
				  from ispcontrole.ispc_crontab as c 
				  LEFT JOIN ispcontrole.ispc_mail_domain as m
				  on c.guiid = m.guiid	
				  where c.guiid = '". mysql_real_escape_string($crontabguiid) ."' 
				  and c.done = '0'
				  and c.maildomain = '1'
				  and m.changed != '0'
		          order by c.guiid ASC";

$maildomainquery = mysql_query($maildomainsql);

	while ($maildomain = mysql_fetch_array($maildomainquery)) {
		if ($maildomain['changed'] == 1) {
		 /* maildomain eintragen */
		$maildomainsql = "insert into vmail.domain 
						 (domain,
						  description ,	
						  disclaimer ,
						  aliases ,
						  mailboxes ,
						  maxquota ,
						  quota ,
						  transport ,
						  backupmx ,
						  defaultlanguage ,
						  defaultuserquota ,
						  defaultuseraliases ,
						  disableddomainprofiles ,
						  disableduserprofiles ,
						  defaultpasswordscheme ,
						  minpasswordlength ,
						  maxpasswordlength ,
						  created ,
						  modified ,
						  expired ,
						  active,
						  guiid)
						  VALUES ('". mysql_real_escape_string($maildomain['maildomainname']) ."',
								  '". mysql_real_escape_string($maildomain['maildomainname']) ."', 
								  '', 
								  '0', 
								  '0', 
								  '0', 
								  '0', 
								  'dovecot', 
								  '0', 
								  'en_US', 
								  '1024', 
								  '', 
								  '', 
								  '', 
								  '', 
								  '0', 
								  '0',
								  NOW( ) , 
								  '0000-00-00 00:00:00', 
								  '9999-12-31 00:00:00', 
								  '1', 
								  '". mysql_real_escape_string($crontabguiid) ."')";

		mysql_query($maildomainsql);
		var_dump($maildomainsql);
		$mailchangedsql = "update ispcontrole.ispc_mail_domain set changed='0', aktiv='1' where id='". $maildomain['id'] ."'";
		mysql_query($mailchangedsql);
		logme('maildomain.php',"Maildomain ". $maildomain['maildomainname'] ." erfolgreich angelegt");
				
		} /* END Changed = 1*/
	if ($maildomain['changed'] == 2) {

		} /* END Changed = 2 */
	

	} /* END While */


?>