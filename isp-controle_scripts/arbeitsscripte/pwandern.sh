
################################################################
#
# $Author: ostoffel $
# $Revision: 42 $
# $LastChangedDate: 2013-08-27 16:53:11 +0200 (Di, 27 Aug 2013) $
# $URL: https://svn.isp-controle.de/svn/trunk/isp-controle_scripts/arbeitsscripte/pwandern.sh $
# $Date: 2013-08-27 16:53:11 +0200 (Di, 27 Aug 2013) $
# $Id: pwandern.sh 42 2013-08-27 14:53:11Z ostoffel $
# $Header: https://svn.isp-controle.de/svn/trunk/isp-controle_scripts/arbeitsscripte/pwandern.sh 42 2013-08-27 14:53:11Z ostoffel $
#
#################################################################

#!/bin/sh
# \
exec expect -f "$0" ${1+"$@"}
set password [lindex $argv 1]
spawn passwd [lindex $argv 0]
sleep 1
expect "assword:"
send "$password\r"
expect "assword:"
send "$password\r"
expect eof
