-- phpMyAdmin SQL Dump
-- version 4.0.6
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Erstellungszeit: 17. Sep 2013 um 15:00
-- Server Version: 5.5.31-0+wheezy1
-- PHP-Version: 5.4.4-14+deb7u4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Datenbank: `ispcontrole`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `domains`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `ispc_accounting`
--

CREATE TABLE IF NOT EXISTS `ispc_accounting` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `guiid` int(11) NOT NULL,
  `ftpacc` int(11) DEFAULT '0',
  `shellacc` int(11) DEFAULT '0',
  `mailacc` int(11) DEFAULT '0',
  `maildom` int(11) DEFAULT '0',
  `webdom` int(11) DEFAULT '0',
  `subdom` int(11) DEFAULT '0',
  `db` int(11) DEFAULT '0',
  `dns` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `guiid` (`guiid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Tabelle fuer Accounting' AUTO_INCREMENT=1 ;

--
-- Tabellenstruktur für Tabelle `ispc_crontab`
--

CREATE TABLE IF NOT EXISTS `ispc_crontab` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `guiid` int(11) NOT NULL,
  `systemuser` tinyint(1) DEFAULT '0',
  `ftpuser` tinyint(1) DEFAULT '0',
  `mailuser` tinyint(1) DEFAULT '0',
  `maildomain` tinyint(1) DEFAULT '0',
  `vhost` tinyint(1) DEFAULT '0',
  `webdomain` tinyint(1) DEFAULT '0',
  `subdomain` tinyint(1) NOT NULL DEFAULT '0',
  `dns` tinyint(1) NOT NULL DEFAULT '0',
  `time` int(11) DEFAULT NULL,
  `done` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `guiid` (`guiid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Systemcron' AUTO_INCREMENT=1 ;

--
-- Daten für Tabelle `ispc_crontab`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `ispc_ftpuser`
--

CREATE TABLE IF NOT EXISTS `ispc_ftpuser` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `guiid` int(11) NOT NULL,
  `ftpuser` varchar(255) NOT NULL COMMENT 'FTP-Benutzername',
  `ftppassword` varchar(255) NOT NULL COMMENT 'FTP-Password',
  `ftpdir` varchar(255) NOT NULL COMMENT 'Wo hat der FTP User Zugang ',
  `oldguiid` int(11) DEFAULT NULL,
  `changed` enum('0','1','2','3') NOT NULL,
  `aktiv` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `ftpuser` (`ftpuser`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;



-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `ispc_keys`
--

CREATE TABLE IF NOT EXISTS `ispc_keys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `guiid` int(11) NOT NULL,
  `skoldpw` varchar(255) NOT NULL,
  `skold` blob NOT NULL,
  `sknew` blob NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `guiid` (`guiid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;


--
-- Tabellenstruktur für Tabelle `ispc_mailaccounts`
--

CREATE TABLE IF NOT EXISTS `ispc_mailaccounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `guiid` int(11) NOT NULL,
  `maildomainname` varchar(255) NOT NULL,
  `mailadresse` varchar(255) NOT NULL,
  `mailpassword` varchar(255) NOT NULL,
  `changed` enum('0','1','2','3') DEFAULT '0',
  `aktiv` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `maildomainname` (`maildomainname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Mailaccounts' AUTO_INCREMENT=1 ;



-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `ispc_mail_domain`
--

CREATE TABLE IF NOT EXISTS `ispc_mail_domain` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `guiid` bigint(20) NOT NULL,
  `maildomainname` varchar(255) NOT NULL,
  `changed` enum('0','1','2','3') DEFAULT '0',
  `aktiv` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `maildomainname` (`maildomainname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;



-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `ispc_subdomain`
--

CREATE TABLE IF NOT EXISTS `ispc_subdomain` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `guiid` int(11) NOT NULL,
  `subdomain` varchar(255) NOT NULL,
  `directory` text NOT NULL,
  `changed` enum('0','1','2','3') DEFAULT '0',
  `aktiv` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `guiid` (`guiid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;


-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `ispc_systemlog`
--

CREATE TABLE IF NOT EXISTS `ispc_systemlog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `guiid` int(11) DEFAULT '0',
  `script` varchar(255) DEFAULT NULL,
  `was` mediumtext,
  `time` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `script` (`script`),
  KEY `time` (`time`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Tabellenstruktur für Tabelle `ispc_user`
--

CREATE TABLE IF NOT EXISTS `ispc_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `guiid` bigint(20) NOT NULL,
  `username` varchar(20) CHARACTER SET latin1 NOT NULL COMMENT 'Benutzername fuer Anmeldung',
  `password` varchar(255) CHARACTER SET latin1 NOT NULL COMMENT 'Password Benutzernanmeldung',
  `realname` varchar(255) CHARACTER SET latin1 NOT NULL,
  `vorgabe` tinyint(1) NULL DEFAULT '0',
  `email_extern` varchar(255) CHARACTER SET latin1 NOT NULL,
  `email_domain` enum('0','1','2') CHARACTER SET latin1 NOT NULL DEFAULT '0',
  `email_konten` enum('0','1','2') CHARACTER SET latin1 NOT NULL DEFAULT '0',
  `dns` enum('0','1','2') CHARACTER SET latin1 NOT NULL DEFAULT '0' COMMENT 'Kann DNS verwalten',
  `mysql` enum('0','1','2') CHARACTER SET latin1 NOT NULL DEFAULT '0' COMMENT 'Kann Mysql DBs verwalten',
  `web` enum('0','1','2') CHARACTER SET latin1 NOT NULL DEFAULT '0' COMMENT 'kann webseiten verwalten',
  `subdomain` enum('0','1','2') NOT NULL DEFAULT '0',
  `ftp` enum('0','1','2') CHARACTER SET latin1 NOT NULL DEFAULT '0' COMMENT 'kann FTP Accs verwalten',
   `changed` ENUM( '0', '1', '2' ) NULL DEFAULT '0',
   `info` ENUM ( '0', '1' ) NULL DEFAULT '0',
  `aktiv` enum('0','1') NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Daten für Tabelle `ispc_user`
--

INSERT INTO `ispc_user` (`id`, `guiid`, `username`, `password`, `realname`, `vorgabe`,  `email_extern`, `email_domain`, `email_konten`, `dns`, `mysql`, `web`, `subdomain`, `ftp`, `aktiv`) VALUES
(1, 1, 'admin', '21232f297a57a5a743894a0e4a801fc3', 'Administrator', '0', 'root@localhost', '2', '2', '2', '2', '2', '2', '2', '1');


-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `ispc_vhosts`
--

CREATE TABLE IF NOT EXISTS `ispc_vhosts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `guiid` int(11) NOT NULL,
  `vhost_name` varchar(255) NOT NULL,
  `vhost_dir` varchar(255) NOT NULL DEFAULT '/var/www/domainname',
  `vhostip` varchar(20) DEFAULT '127.0.0.0',
  `changed` enum('0','1','2','3') DEFAULT '0' COMMENT '0 nichts,1 anlegen, 2 entfernen',
  `aktiv` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Vhost Tabelle fuer Apache' AUTO_INCREMENT=1 ;


-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `ispc_webdomain`
--

CREATE TABLE IF NOT EXISTS `ispc_webdomain` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `guiid` int(11) NOT NULL,
  `domainname` varchar(255) NOT NULL COMMENT 'Domainname',
  `changed` enum('0','1','2','3') DEFAULT '0',
  `aktiv` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--

CREATE TABLE IF NOT EXISTS `ispc_dns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `guiid` int(11) NOT NULL,
  `domain` varchar(255) NOT NULL,
  `masterslave` ENUM( 'master', 'slave' ) NOT NULL DEFAULT 'master',
  `masterip` VARCHAR( 16 ) NULL,
  `ns1` VARCHAR(255) NULL,
  `ns2` VARCHAR(255) NULL,
  `mx1` VARCHAR(255) NOT NULL,
  `mx2` VARCHAR(255) NULL,
  `ip` varchar(16) NOT NULL,
  `serial` int(11) NOT NULL DEFAULT '1',
  `changed` enum('0','1','2','3') DEFAULT '0',
  `aktiv` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `domain` (`domain`),
  KEY `guiid` (`guiid`),
  KEY `changed` (`changed`),
  KEY `aktiv` (`aktiv`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='DNS Tabelle fuer BIND9' AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `ispc_dns_zonedata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `guiid` int(11) NOT NULL,
  `domain` varchar(255) NOT NULL,
  `type` enum('A','AAAA','CNAME','DNAME','TXT') NOT NULL,
  `data` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `guiid` (`guiid`,`domain`),
  KEY `domain` (`domain`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='dns zonen infos' AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `ispc_webdomain_v` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `guiid` int(11) NOT NULL,
  `domain` varchar(255) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Vorgabe WebdomainNamen' AUTO_INCREMENT=1 ;

--
-- Constraints der exportierten Tabellen
--
ALTER TABLE `ispc_dns_zonedata`
  ADD CONSTRAINT `ispc_dns_zonedata_ibfk_1` FOREIGN KEY (`domain`) REFERENCES `ispc_dns` (`domain`) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE `ispc_mailaccounts`
  ADD CONSTRAINT `ispc_mailaccounts_ibfk_2` FOREIGN KEY (`maildomainname`) REFERENCES `ispc_mail_domain` (`maildomainname`) ON DELETE CASCADE ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
