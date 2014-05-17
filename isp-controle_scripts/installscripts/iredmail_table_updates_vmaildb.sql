ALTER TABLE `alias` ADD `guiid` INT NOT NULL , ADD INDEX ( `guiid` );
ALTER TABLE `mailbox` ADD `guiid` INT NOT NULL , ADD INDEX ( `guiid` ); 
ALTER TABLE `domain` ADD `guiid` INT NOT NULL , ADD INDEX ( `guiid` );