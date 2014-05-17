<?
/*
################################################################
#
# $Author: ostoffel $
# $Revision: 211 $
# $LastChangedDate: 2013-11-10 08:58:15 +0100 (So, 10 Nov 2013) $
# $URL: https://svn.isp-controle.de/svn/trunk/isp-controle_scripts/cronscripte/serverstatus.php $
# $Date: 2013-11-10 08:58:15 +0100 (So, 10 Nov 2013) $
# $Id: serverstatus.php 211 2013-11-10 07:58:15Z ostoffel $
# $Header: https://svn.isp-controle.de/svn/trunk/isp-controle_scripts/cronscripte/serverstatus.php 211 2013-11-10 07:58:15Z ostoffel $
#
#################################################################
*/

/* 
 Da die Ports von innen her erreichbar sein muessen , fragen wir die IP 127.0.0.1 ab
*/
$ip = "127.0.0.1";

/* 
	Ports definiert die Portrange die wir abfragen muessen 
*/
$port = array (80,110,22,25,443,10443,53);
	foreach ($port as $value)
	{
	$connection = fsockopen("tcp://$ip", $value, $errno, $errstr,1);
		if (!$connection){
		$status = "Verbindung zu $ip:$value fehlgeschlagen\nError: $errno \n";
			} /* End if */ 
				else{
					$status = "Port ist erreichbar : ".$value. " / ". $errno . "\n";
		fclose ($connection);
		} /* End else */
	echo $status;
	} /* End foreach */
?>