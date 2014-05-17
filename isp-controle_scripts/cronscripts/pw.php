<?
/*
################################################################
#
# $Author: ostoffel $
# $Revision: 70 $
# $LastChangedDate: 2013-09-09 18:20:00 +0200 (Mo, 09 Sep 2013) $
# $URL: https://svn.isp-controle.de/svn/trunk/isp-controle_scripts/arbeitsscripte/pw.php $
# $Date: 2013-09-09 18:20:00 +0200 (Mo, 09 Sep 2013) $
# $Id: pw.php 70 2013-09-09 16:20:00Z ostoffel $
# $Header: https://svn.isp-controle.de/svn/trunk/isp-controle_scripts/arbeitsscripte/pw.php 70 2013-09-09 16:20:00Z ostoffel $
#
#################################################################
*/

$shellscript = "sudo /var/opt/ispcontrole/pwandern.sh";
$i = "";
$m = "";
$p = "";
include "zd.php";
$m = $_POST['mail'];
$i = $_POST['id'];
$pw = $_POST['pw'];
if (isset($i) && $m)
    	{ 
		$uid = mcheck ($m, $i, $ispc, $ip, $iuser, $pw);
		if (isset($uid))
			{
				$cmd="$shellscript " . $uid . " " . $p;
				exec($cmd);
				$pin=$p."-".$ispc;
				$pout=base64_encode($pin);
				echo $pout;
				exit;
			}
	else 
		{
		echo "Da will uns einer wohl vereiern....";
		exit;
		}
	}
header("location: http://www.google.de?q=Wohl verlaufen");
exit;
	 
function mcheck ($mail1, $id1, $ispc1, $ip1, $iuser1, $pw1)
	{
		$verbindung = mysql_connect ($ip1,$iuser1,$ispc1);
		mysql_select_db("ispcontrole");
		$abfrage = "SELECT username FROM ispc_user WHERE email_extern='".mysql_real_escape_string($mail1)."' AND guiid='".mysql_real_escape_string($id1)."' AND password='".mysql_real_escape_string($pw1)."' AND aktiv='1'";
		$ergebniss = mysql_query($abfrage);
		while($row = mysql_fetch_array($ergebniss))
			{
				return $row['username'];
			}
	}
?>