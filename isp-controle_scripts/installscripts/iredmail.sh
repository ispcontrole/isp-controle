#!/bin/bash
#################################################################
#
# $Author: ostoffel $
# $Revision: 164 $
# $LastChangedDate: 2013-10-09 16:25:31 +0200 (Mi, 09 Okt 2013) $
# $URL: https://svn.isp-controle.de/svn/trunk/isp-controle_scripts/installscripte/postfix-install.sh $
# $Date: 2013-10-09 16:25:31 +0200 (Mi, 09 Okt 2013) $
# $Id: postfix-install.sh 164 2013-10-09 14:25:31Z ostoffel $
# $Header: https://svn.isp-controle.de/svn/trunk/isp-controle_scripts/installscripte/postfix-install.sh 164 2013-10-09 14:25:31Z ostoffel $
#
##################################################################

. /usr/ispc_inst/ispc.cfg
SED=`which sed`
 cd /usr/ispc_inst/iRedMail*
   IREDDIR=`pwd`
cd $IREDDIR

#26.10.2013 Bugfixing for http://bugs.isp-controle.de/thebuggenie/ispcontrole/issues/63#comment_522
# !! Abschalten der PHP Funtionen die fuer den weiteren gebrauch von ISP-Controle benoetigt werden unterbinden !!

conffile="'$IREDDIR'/conf/apache_php"
$SED -i 's/show_source,system,shell_exec,passthru,exec,phpinfo,proc_open/ /' $conffile

# IredMail vorbereiten und installieren !

AUTO_USE_EXISTING_CONFIG_FILE=y \
AUTO_INSTALL_WITHOUT_CONFIRM=y \
AUTO_CLEANUP_REMOVE_SENDMAIL=y \
AUTO_CLEANUP_REMOVE_MOD_PYTHON=y \
AUTO_CLEANUP_REPLACE_FIREWALL_RULES=REPLACEYN \
AUTO_CLEANUP_RESTART_IPTABLES=RESTARTYN \
AUTO_CLEANUP_REPLACE_MYSQL_CONFIG=y \
AUTO_CLEANUP_RESTART_POSTFIX=n \
bash iRedMail.sh
