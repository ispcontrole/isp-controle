<?
/*
################################################################
#
# $Author: ostoffel $
# $Revision: 207 $
# $LastChangedDate: 2013-11-03 10:23:57 +0100 (So, 03 Nov 2013) $
# $URL: https://svn.isp-controle.de/svn/trunk/isp-controle_scripts/cronscripte/dnsupdate.php $
# $Date: 2013-11-03 10:23:57 +0100 (So, 03 Nov 2013) $
# $Id: dnsupdate.php 207 2013-11-03 09:23:57Z ostoffel $
# $Header: https://svn.isp-controle.de/svn/trunk/isp-controle_scripts/cronscripte/dnsupdate.php 207 2013-11-03 09:23:57Z ostoffel $
#
#################################################################
*/

/*
changed 1 | 2 | 0
1 -> Anlegen
2 -> Loeschen
3 -> Aendern
0 -> nix tun
*/

$dnssql = "SELECT c.systemuser, 
					c.ftpuser, 
					c.mailuser, 
					c.maildomain, 
					c.vhost, 
					c.webdomain, 
					c.subdomain, 
					c.dns, 
					c.done, 
					d.id, 
					d.guiid, 
					d.domain,
					d.masterslave,
					d.masterip,
					d.ns1,
					d.ns2,
					d.mx1,
					d.mx2,
					d.ip,
					d.serial, 
					d.changed, 
					d.aktiv
					FROM ispcontrole.ispc_crontab AS c
					LEFT JOIN ispcontrole.ispc_dns AS d 
					ON c.guiid = d.guiid
					WHERE c.guiid = '". mysql_real_escape_string($crontabguiid) ."'
					AND c.done = '0'
					AND c.dns = '1'
					AND d.changed != '0'
					ORDER BY c.guiid ASC";

$dnsresult = mysql_query($dnssql);

while ($dns = mysql_fetch_array($dnsresult)) {
	if ($dns['changed'] == 1 ) {
		/* DNS Zone Anlegen und Bind neustarten */
		
		/* Variablen vorbereiten */
		$dnscommand = "/etc/init.d/bind9 restart" ;
		if ($dns['masterslave'] == "master") {
			$zonefile = "/etc/bind/clients/". $dns['domain'] .".pri";
		}
		if ($dns['masterslave'] == "slave") {
			$zonefile = "/etc/bind/clients/". $dns['domain'] .".sla";
		}
		$zonecontent = "";
		$zoneconfcontent = "";

		$zonedate = date("Ymd");
		$serial = $dns['serial'];

		$zoneserial = $zonedate . $serial;
		$zoneconf = "/etc/bind/named.conf.ispcontrole.zones";


		$zonecontent .= "; BIND db file for ".$dns['domain']."\n";
		$zonecontent .= "\n";
		$zonecontent .= "\$TTL 86400\n";
		$zonecontent .= "\n";
		$zonecontent .= "@       IN      SOA     ns1.".$dns['domain'].".      hostmaster.".$dns['domain'].". (\n";
		$zonecontent .= "						".$zoneserial."	; serial number YYMMDDNN\n";
		$zonecontent .= "                        28800          ; Refresh\n";
        $zonecontent .= "                        7200           ; Retry\n";
        $zonecontent .= "						 864000         ; Expire\n";
        $zonecontent .= "                        86400          ; Min TTL\n";
		$zonecontent .= "                        )\n";
		$zonecontent .= "\n";
		$zonecontent .= "					NS      ".$dns['ns1'].". \n";
		if ($dns['ns2'] == "") {
        $zonecontent .= "\n";
		} else
		$zonecontent .= "					NS      ".$dns['ns2'].". \n";
		
		$zonecontent .= "\n";	
        $zonecontent .= $dns['domain'].".		         MX      10 ".$dns['mx1'].". \n";
		
		if ($dns['mx2'] == "") {
		$zonecontent .= "\n"; 
		}	else
		$zonecontent .= $dns['domain'].".		         MX      20 ".$dns['mx2'].". \n";
		
		$zonecontent .= "webmail		3600	A		". $dns['ip'] ."\n";
		$zonecontent .= "ftp		3600	A		". $dns['ip'] ."\n";
		$zonecontent .= "mail		3600	A		". $dns['ip'] ."\n";
		$zonecontent .= "smtp		3600	A		". $dns['ip'] ."\n";
		$zonecontent .= "pop3		3600	A		". $dns['ip'] ."\n";
		$zonecontent .= "imap		3600	A		". $dns['ip'] ."\n";
		$zonecontent .= "www		3600	A		". $dns['ip'] ."\n";
		$zonecontent .= $dns['domain'].".		3600	A		". $dns['ip'] ."\n";
		$zonecontent .= "*		3600	A		". $dns['ip'] ."\n";
        $zonecontent .= "\$ORIGIN ".$dns['domain'].".\n";

	  /* Zonendatei schreiben */
	  	$handle = fopen($zonefile, "w+");
		fwrite ($handle, $zonecontent);
		fclose ($handle);
	 
	 /* Zone in die named.conf.ispcontrole eintragen und Bind restarten */
	   if ($dns['masterslave'] == "master") { 
		$zoneconfcontent .= "zone \"". $dns['domain'] ."\" {\n";
		$zoneconfcontent .= "	type master;\n";
		$zoneconfcontent .= "	file \"" .$zonefile. "\";\n";
		$zoneconfcontent .= "	allow-update { none; };\n";
		$zoneconfcontent .= "};\n";
	   }
	   if ($dns['masterslave'] == "slave") { 
		$zoneconfcontent .= "zone \"". $dns['domain'] ."\" {\n";
		$zoneconfcontent .= "	type slave;\n";
		$zoneconfcontent .= "	file \"" .$zonefile. "\";\n";
		$zoneconfcontent .= "	masters { \n";
		$zoneconfcontent .= "		". $dns['masterip'] .";\n";
		$zoneconfcontent .= "	};\n";
		$zoneconfcontent .= "};\n";
	   }
		$handle = fopen($zoneconf, "a+");
		fwrite ($handle, $zoneconfcontent);
		fclose ($handle);
	
	/* Aktualisierungen der Eintrage durchfuehren */
	   $serial = $dns['serial'];
	   $serial = $serial++;
	   $dnsid = $dns['id'];
	   $updatesql = "update ispcontrole.ispc_dns set serial = '". mysql_real_escape_string($serial) ."', changed = '0', aktiv = '1' where id = '". mysql_real_escape_string($dnsid) ."'";
	   mysql_query($updatesql);
    /* Aktualisierungen der Eintraege durchfuehren ENDE*/
   
    /* Systemlogeintrag durchfuehren */
	   logme("dnsupdate.php", "DNS Zone ".$dns['domain']." erfolgreich mit Namen ".$zonefile." angelegt und eingelesen");
 
	  /* Bind Neustarten */
	  exec($dnscommand);
	} /* DNS Zone Anlegen Ende */

	if ($dns['changed'] == 2) {
		/* DNS Zone loeschen und Bind neustarten */

	} /* Ende DNS Zone loeschen */

	if ($dns['changed'] == 3) {
		/* DNS Zone aendern und Bind neustarten */

	} /* Ende DNS Zone loeschen */

} /* Ende While Schleife */

?>