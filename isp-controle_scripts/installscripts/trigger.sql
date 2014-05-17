--
-- Trigger `ispc_ftpuser`
--
DROP TRIGGER IF EXISTS `ispc_cron_ftpuser`;
DELIMITER //
CREATE TRIGGER `ispc_cron_ftpuser` AFTER INSERT ON `ispc_ftpuser`
 FOR EACH ROW INSERT INTO ispc_crontab (id,guiid,ftpuser) VALUES ('', NEW.guiid, '1')
//
DELIMITER ;

--
-- Trigger `ispc_mailaccounts`
--
DROP TRIGGER IF EXISTS `ispc_cron_mailaccounts`;
DELIMITER //
CREATE TRIGGER `ispc_cron_mailaccounts` AFTER INSERT ON `ispc_mailaccounts`
 FOR EACH ROW INSERT INTO ispc_crontab (id,guiid,mailuser) VALUES ('', NEW.guiid, '1')
//
DELIMITER ;

--
-- Trigger `ispc_mail_domain`
--
DROP TRIGGER IF EXISTS `ispc_cron_maildomain`;
DELIMITER //
CREATE TRIGGER `ispc_cron_maildomain` AFTER INSERT ON `ispc_mail_domain`
 FOR EACH ROW INSERT INTO ispc_crontab (id,guiid,maildomain) VALUES ('', NEW.guiid, '1')
//
DELIMITER ;

--
-- Trigger `ispc_subdomain`
--
DROP TRIGGER IF EXISTS `ispc_cron_subdomain`;
DELIMITER //
CREATE TRIGGER `ispc_cron_subdomain` AFTER INSERT ON `ispc_subdomain`
 FOR EACH ROW INSERT INTO ispc_crontab (id,guiid,subdomain) VALUES ('', NEW.guiid, '1')
//
DELIMITER ;

--
-- Trigger `ispc_user`
--
DROP TRIGGER IF EXISTS `ispc_cron_systemuser`;
DELIMITER //
CREATE TRIGGER `ispc_cron_systemuser` AFTER INSERT ON `ispc_user`
 FOR EACH ROW BEGIN 
 INSERT INTO ispc_crontab (id,guiid,systemuser) VALUES ('', NEW.guiid, '1');
 INSERT INTO ispc_accounting (id,guiid) VALUES ('', NEW.guiid);
 END;
//
DELIMITER ;

--
-- Trigger `ispc_vhosts`
--
DROP TRIGGER IF EXISTS `ispc_cron_vhost`;
DELIMITER //
CREATE TRIGGER `ispc_cron_vhost` AFTER INSERT ON `ispc_vhosts`
 FOR EACH ROW INSERT INTO ispc_crontab (id,guiid,vhost) VALUES ('', NEW.guiid, '1')
//
DELIMITER ;

-- Trigger `ispc_webdomain`
--
DROP TRIGGER IF EXISTS `ispc_crontab_webdomain`;
DELIMITER //
CREATE TRIGGER `ispc_crontab_webdomain` AFTER INSERT ON `ispc_webdomain`
 FOR EACH ROW INSERT INTO ispc_crontab (id,guiid,webdomain) VALUES ('', NEW.guiid, '1')
//
DELIMITER ;

-- Trigger `ispc_crontab_dns`
--
DROP TRIGGER IF EXISTS `ispc_crontab_dns`;
DELIMITER //
CREATE TRIGGER `ispc_crontab_dns` AFTER INSERT ON `ispc_dns`
 FOR EACH ROW INSERT INTO ispc_crontab (id,guiid,dns) VALUES ('', NEW.guiid, '1')
//
DELIMITER ;