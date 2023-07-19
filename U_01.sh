#!/bin/sh
lang_check=`locale -a 2>/dev/null | grep "en_US" | egrep -i "(utf8|utf-8)"`
if [ "$lang_check" = "" ]; then
        lang_check="C"
fi

LANG="$lang_check"
LC_ALL="$lang_check"
LANGUAGE="$lang_check"
export LANG
export LC_ALL
export LANGUAGE

if [ "`command -v netstat 2>/dev/null`" != "" ] || [ "`which netstat 2>/dev/null`" != "" ]; then
        port_cmd="netstat"
else
        port_cmd="ss"
fi

if [ "`command -v systemctl 2>/dev/nll`" != "" ] || [ "`which systemctl 2>/dev/null`" != "" ]; then
        systemctl_cmd="systemctl"
fi
RESULT_FILE="result_collect_`date +\"%Y%m%d%H%M\"`.txt"

echo "[Start Sctipt]"
echo "====================Linux Security Check Script Start====================" >> $RESULT_FILE 2>&1
echo "" >> $RESULT_FILE 2>&1
###############################################################################
# - U-01 -
###############################################################################
echo "[ U-01 } : Check"
echo "================= [ U - 0 1 ] ==============" >> $RESULT_FILE 2>&1
echo "" >> $RESULT_FILE 2>&1

echo "1. SSH" >> $RESULT_FILE 2>&1
echo "1-1. SSH Process Check" >> $RESULT_FILE 2>&1
get_ssh_ps=`ps -ef | grep -v "grep" | grep "sshd"`
if [ "$get_ssh_ps" != "" ]; then
        echo "$get_ssh_ps" >> $RESULT_FILE 2>&1
else
        echo "Not Founddd Process" >> $RESULT_FILE 2>&1
fi

echo "" >> $RESULT_FILE 2>&1

echo "1-2. SSH Service Check" >> $RESULT_FILE 2>&1
if [ "$systemctl_cmd" != "" ]; then
        get_ssh_service=`$systemctl_cmd list-units --type service | egrep '(ssh|sshd)\.service' | sed -e 's/^*//g' -e 's/^      *//g' | tr -s " \t"`
        if [ "$get_ssh_service" != "" ]; then
                echo "$get_ssh_service" >> $RESULT_FILE 2>&1
        else
                echo "Not Found Service" >> $RESULT_FILE 2>&1
        fi
else
        echo "Not Found Systemctl Command" >> $RESULT_FILE 2>&1
fi
echo "" >> $RESULT_FILE 2>&1

echo "1-3. SSH Port Check" >> $RESULT_FILE 2>&1
if [ "$port_cmd" != "" ]; then
        get_ssh_port=`$port_cmd -na | grep "tcp" | grep "LISTEN" | grep ':22[ \t]'`

        if [ "$get_ssh_port" != "" ]; then
                echo "$get_ssh_port" >> $RESULT_FILE 2>&1
        else
                echo "Not Found Port" >> $RESULT_FILE 2>&1
        fi
else
        echo "Not Found Port Command" >> $RESULT_FILE 2>&1
fi
if [ "$get_ssh_ps" != "" ] || [ "$get_ssh_service" != "" ] || [ "$get_ssh_port" != "" ]; then
        echo "" >> $RESULT_FILE 2>&1
        echo "1-4. SSH Configuration File Check" >> $RESULT_FILE 2>&1
        if [ -f "/etc/ssh/sshd_config" ]; then
                get_ssh_conf=`cat /etc/ssh/sshd_config | egrep -v '^#|^$' | grep "PremitRootLogin"`
                if [ "$get_ssh_conf" != "" ]; then
                        echo "/etc/ssh/sshd_config : $get_ssh_conf" >> $RESULT_FILE 2>&1
                        get_conf_check=`echo "$get_ssh_conf" | awk '{ print $2 }'`
                        if [ "$get_conf_check" = "no" ]; then
                                ssh_flag=1
                        else
                                ssh_flag=0
                        fi
                else
                        ssh_flag=1
                        echo "/etc/ssh/sshd_config : Not Found PermitRootLogin Configuration" >> $RESULT_FILE 2>&1
                fi
        else
                ssh_flag=2
                echo "Not Found SSH Configuration File" >> $RESULT_FILE 2>&1
        fi
        echo "" >> $RESULT_FILE 2>&1
else
        ssh_flag=1
fi

echo "2. Telnet" >> $RESULT_FILE 2>&1
echo "2-1. Telnet Process Check" >> $RESULT_FILE 2>&1
get_telnet_pss=`ps -ef | grep -v "grep" | grep "telnet"`
if [ "$get_telnet_ps" != "" ]; then
        echo "$get_telnet_ps" >> $RESULT_FILE 2>&1
else
        echo "Not Found Precess" >> $RESULT_FILE 2>&1
fi
echo "" >> $RESULT_FILE 2>&1

echo "2-2. Telnet Service Check" >> $RESULT_FILE 2>&1
if [ "$systemctl_cmd" != "" ]; then
        get_telnet_service=`$systemctl_cmd list-units --type service | egrep '(telnet|telnetd)\.service' | sed -e 's/^ *//g' -e 's/^    *//g' | tr -s " \t"`
        if [ "$get_telnet_service" != "" ]; then
                echo "$get_telnet_service" >> $RESULT_FILE 2>&1
        else
                echo "Not Found Service" >> $RESULT_FILE 2>&1
        fi
else
        echo "Not Found systemctl Command" >> $RESULT_FILE 2>&1
fi
echo "" >> $RESULT_FILE 2>&1

echo "2-3. Telnet Port Check" >> $RESULT_FILE 2>&1
if [ "$port_cmd" != "" ]; then
        get_telnet_port=`$port_cmd -na | grep "tcp" | grep "LISTEN" | grep ':23[ \t]'`
        if [ "$get_telnet_port" != "" ]; then
                echo "$get_telnet_port" >> $RESULT_FILE 2>&1
        else
                echo "Not Found Port" >> $RESULT_FILE 2>&1
        fi
else
        echo "Not Found Port Command" >> $RESULT_FILE 2>&1
fi

if [ "$get_telnet_ps" != "" ] || [ "$get_telnet_service" != "" ] || [ "$get_telnet_port" != "" ]; then
        telnet_flag=0
        echo "" >> $RESULT_FILE 2>&1
        echo "2.4 Telnet Configuration Check" >> $RESULT_FILE 2>&1
        if [ -f "/etc/pam.d/remote" ]; then
                pam_file="/etc/pam.d/remote"
elif [ -f "/etc/pam.d/login" ]; then
                pam_file="/etc/pam.d/login"
        fi

        if [ "$pam_file" != "" ]; then
                echo "- $pam_file" >> $RESULT_FILE 2>&1
                get_conf=`cat $pam_file | egrep -v '^#|^$' | grep "pam_securetty.so"`
                if [ "$get_conf" != "" ]; then
                        echo "$get_conf" >> $RESULT_FILE 2>&1
                        if [ -f "/etc/securetty" ]; then
                                echo "- /etc/securetty" >> $RESULT_FILE 2>&1
                                echo "`cat /etc/securetty`" >> $RESULT_FILE 2>&1
                                get_pts=`cat /etc/securetty | egrep -v '^#|^$' | grep "^[ \t]*pts"`
                                if [ "$get_pts" = "" ]; then
                                        telnet_flag=1
                                fi
                        else
                                echo "Not Found Telnet tty Configuration File" >> $RESULT_FILE 2>&1
                        fi
                else
                        echo "$pam_file : Not Found pam_securetty.so Configuration" >> $RESULT_FILE 2>&1
                fi
        else
                telnet_flag=2
                echo " Not Found Telnet Pam Configuration File" >> $RESULT_FILE 2>&1
                telnet_flag=2
                echo " Not Found Telnet Pam Configuration File" >> $RESULT_FILE 2>&1
        fi
else
        telnet_flag=1
fi

# Bad : 0 , Good : 1, Not Yet : 2
if [ $ssh_flag -eq 1 ] && [ $telnet_flag -eq 1 ]; then
        echo "Result : Good" >> $RESULT_FILE 2>&1
elif [ $ssh_flag -eq 0 ] || [ $telnet_flag -eq 0 ]; then
        echo "Result : Bad" >> $RESULT_FILE 2>&1
elif [ $ssh_flag -eq 2 ] || [ $telnet_flag -eq 2 ]; then
        echo "Result : Not Yet" >> $RESULT_FILE 2>&1
fi

echo "" >> $RESULT_FILE 2>&1
echo "===================== END ========================" >> $RESULT_FILE 2>&1
echo "" >> $RESULT_FILE 2>&1
