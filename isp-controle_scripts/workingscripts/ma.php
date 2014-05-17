<?php
###############################################################
#
# $Author: ostoffel $
# $Revision: 190 $
# $LastChangedDate: 2013-10-18 14:22:12 +0200 (Fr, 18 Okt 2013) $
# $URL: https://svn.isp-controle.de/svn/trunk/isp-controle_scripts/arbeitsscripte/ma.php $
# $Date: 2013-10-18 14:22:12 +0200 (Fr, 18 Okt 2013) $
# $Id: ma.php 190 2013-10-18 12:22:12Z ostoffel $
# $Header: https://svn.isp-controle.de/svn/trunk/isp-controle_scripts/arbeitsscripte/ma.php 190 2013-10-18 12:22:12Z ostoffel $
#
###############################################################

/* DB Verbindung herstellen */
include "/var/opt/ispcontrole/cronscripte/db.inc.php";
include "/var/opt/ispcontrole/www/mailer.class.php";
database_open ();
$ispc_guiid = $_POST['guiid'];
$ispc_username = $_POST['username'];
$ispc_email = $_POST['email'];


$keysql	=	"select skeys.guiid,
					skeys.skoldpw,
					skeys.skold,
					user.username,
					user.email_extern 
					from ispcontrole.ispc_keys as skeys 
					left join ispcontrole.ispc_user as user 
					on skeys.guiid = user.guiid 
					where skeys.guiid = '".mysql_real_escape_string($ispc_guiid) ."' 
					and user.username = '".mysql_real_escape_string($ispc_username)."' 
					and user.email_extern = '".mysql_real_escape_string($ispc_email)."'";

$keyquery = mysql_query($keysql);
	while ($keydata = mysql_fetch_array($keyquery)) {
		$file = $ispc_guiid".zsk";

		$tmp = "/tmp/".$file;
		$fp = fopen($tmp, "w");
			if ($fp)	{
			     $data = ($keydata['skold']);
			     fwrite($fp, $data);
				}
				fclose($fp);
				$attachfile = $tmp;
		$receipientmail = $keydata['email_extern'];
		$receipientname = $keydata['username'];
		$skoldpw = base64_decode($keydata['skoldpw']);

$myMessage = "Schlüsselanforderung\n";
$myMessage .= "Sie haben kürzlich ihren ISPC Schlüssel angefordert.\n";
$myMessage .= "Der Schlüssel befindet sich als Anhang in dieser Mail.\n\nDas dazugehörige Passwort lautet : ".$skoldpw."\n\n";
$myMessage .= "\n\nMit freundlichen Grüßen\nIhr ISPC-System";

$myHTMLMessage = "Schlüsselanforderung<br>";
$myHTMLMessage .= "Sie haben kürzlich ihren ISPC Schlüssel angefordert.<br><br>";
$myHTMLMessage .= "Der Schlüssel befindet sich als Anhang in dieser Mail.<br><br>Das dazugehörige Passwort lautet : ".$skoldpw."<br><br>";
$myHTMLMessage .= "<br><br>Mit freundlichen Grüßen\nIhr ISPC-System";


$mail = new PHPMailer;
$mail->isMAIL();                                      // Set mailer to use SMTP
$mail->Host = 'localhost';  // Specify main and backup server
$mail->SMTPAuth = false;                               // Enable SMTP authentication
$mail->Username = '';                            // SMTP username
$mail->Password = '';                           // SMTP password
$mail->SMTPSecure = 'tls';                            // Enable encryption, 'ssl' also accepted

$mail->From = 'noreply@localhost.local';
$mail->FromName = 'ISPC Key Service';
$mail->addAddress($receipientmail, $receipientname);  // Add a recipient
$mail->WordWrap = 50;                                 // Set word wrap to 50 characters
$mail->addAttachment($attachfile, $ispc_guiid.'.zsk');    // Optional name
$mail->isHTML(true);                                  // Set email format to HTML

$mail->Subject = 'Schlüsselanforderung';
$mail->Body    = $myHTMLMessage;
$mail->AltBody = $myMessage;

if(!$mail->send()) {
   echo 'Message could not be sent.';
   echo 'Mailer Error: ' . $mail->ErrorInfo;
   exit;
}
echo 'Message has been sent';
	}
	?>