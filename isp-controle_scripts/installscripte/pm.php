<?
/*
#################################################################
#
# $Author: ostoffel $
# $Revision: 153 $
# $LastChangedDate: 2013-10-08 16:32:11 +0200 (Di, 08 Okt 2013) $
# $URL: https://svn.isp-controle.de/svn/trunk/isp-controle_scripts/installscripte/ispc-install.sh $
# $Date: 2013-10-08 16:32:11 +0200 (Di, 08 Okt 2013) $
# $Id: ispc-install.sh 153 2013-10-08 14:32:11Z ostoffel $
# $Header: https://svn.isp-controle.de/svn/trunk/isp-controle_scripts/installscripte/ispc-install.sh 153 2013-10-08 14:32:11Z ostoffel $
#
##################################################################
*/

include "/var/opt/ispcontrole/cronscripte/db.inc.php";
include "pm.inc.php";
$sql = "INSERT INTO mail_domains (domain, guiid) VALUES ('".$maildomain."','1')";
$sql1 = "INSERT INTO `mail_transport` (`domain`, `transport`, `guiid`) VALUES ('".$maildomain."', ':', '1')";
$sql2 = "INSERT INTO `mail_users` (`email`, `password`, `quota`, `guiid`) VALUES ('postmaster@".$maildomain."', ENCRYPT( '".$ispcuserpw."' ) , '52428800', '1')";
mysql_query($sql);
mysql_query($sql1);
mysql_query($sql2);
?>