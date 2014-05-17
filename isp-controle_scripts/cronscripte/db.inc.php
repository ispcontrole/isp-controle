<?
/*
################################################################
#
# $Author: ostoffel $
# $Revision: 225 $
# $LastChangedDate: 2014-03-04 17:33:35 +0100 (Di, 04 Mrz 2014) $
# $URL: https://svn.isp-controle.de/svn/trunk/isp-controle_scripts/cronscripte/db.inc.php $
# $Date: 2014-03-04 17:33:35 +0100 (Di, 04 Mrz 2014) $
# $Id: db.inc.php 225 2014-03-04 16:33:35Z ostoffel $
# $Header: https://svn.isp-controle.de/svn/trunk/isp-controle_scripts/cronscripte/db.inc.php 225 2014-03-04 16:33:35Z ostoffel $
#
#################################################################
*/

/*
	Deklaration der Datenbankverbindung
*/
function database_open () {
	$ispcontroledb="ispcontrole";
	$ispcontroledbuser="ispcuser";
	$ispcontroledbhost="localhost";
	
/*

	$ispcontroledbpass wird durch Installscript befuellt

*/
$ispcontroledbpass="";

/* 
11.09.2013
Datenbankverbindung aufbauen
*/

			$ispcontrole = mysql_connect($ispcontroledbhost,$ispcontroledbuser,$ispcontroledbpass);
			mysql_select_db($ispcontroledb,$ispcontrole);
}

function get_puredomain($haystack, $needle, $case_insensitive = false) {
    $strpos = ($case_insensitive) ? 'stripos' : 'strpos';
    $pos = $strpos($haystack, $needle);
    if (is_int($pos)) {
        return substr($haystack, $pos + strlen($needle));
    }
    // Most likely false or null
    return $pos;
}

function maildirhash($string) {

 /* 
  $string => komplette Mailadresse zum erstellen des Maildirhashes
  */

 $user = strstr($string, '@', true);
 $domain = get_puredomain($string, '@');
 $date = date("Y.m.d.H.i.s");
 $hash1 = substr($user, 0, 1); 
 $hash2 = substr($user, 1, 1); 	
 $hash3 = substr($user, 2, 1);
 $maildir = $domain . "/" . $hash1 . "/" . $hash2 . "/" . $hash3 . "/" . $user . "-" . $date . "/";
 return $maildir;
 
}

/* 
20.09.2013
Funktion zum loggen der einzelnen Schritte der Cronjobs 
$script		=	string
$was		=	string
*/

function logme ($script, $was) {
	$time = time();
	$logmequery = "insert into ispc_systemlog 
	(id, script, was, time) 
	VALUES ('', '". mysql_real_escape_string($script) ."', '". mysql_real_escape_string($was) ."', '". $time ."')";
	mysql_query($logmequery);
}
?>