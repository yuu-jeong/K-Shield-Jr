##############################################################################################
# - U-20 Anonymous FTP disabled
##############################################################################################
echo "[ U-20 ] : Check"
echo "======================= [ U - 2 0 ] =============================" >> $RESULT_FILE 2>&1

FTP=1
vsftp_flag=0

echo "1. FTP Process Check" >> $RESULT_FILE 2>&1
get_ps=`ps -ef | grep -v 'grep' | grep 'ftpd' | grep -v 'tftp'`
if [ "$get_ps" != "" ]; then
        echo "$get_ps" >> $RESULT_FILE 2>&1
        if [ "`echo \"$get_ps\" | grep 'vsftp'`" != "" ]; then
                vsftp_flag=1
        fi
else
        echo "Not Found Process" >> $RESULT_FILE 2>&1
fi

echo "" >> $RESULT_FILE 2>&1
echo "2. FTP Service Check" >> $RESULT_FILE 2>&1

if [ "$systemctl_cmd" != "" ]; then
        get_service=`$systemctl_cmd list-units --type service | grep 'ftpd\.service' | sed -e 's/^ *//g' -e 's/^        *//g' | tr -s " \t"`
        if [ "$get_service" != "" ]; then
                echo "$get_service" >> $RESULT_FILE 2>&1
        else
                echo "Not Found Service" >> $RESULT_FILE 2>&1
        fi
else
        echo "Not Found systemctl Command" >> $RESULT_FILE 2>&1
fi

echo "" >> $RESULT_FILE 2>&1
echo "3. FTP Port Check" >> $RESULT_FILE 2>&1

if [ "$port_cmd" != "" ]; then
        get_port=`$port_cmd -na | grep "tcp" | grep "LISTEN" | grep ':21[ \t]'`
        if [ "$get_port" != "" ]; then
                echo "$get_port" >> $RESULT_FILE 2>&1
        else
                echo "NotFound Port" >> $RESULT_FILE 2>&1
        fi
else
        echo " Not Found Port Command" >> $RESULT_FILE 2>&1
fi

echo "" >> $RESULT_FILE 2>&1

if [ "$get_ps" != "" ] || [ "$get_service" != "" ] || [ "$get_port" != "" ]; then
        echo "4. FTP Anonymous Configuration Check" >> $RESULT_FILE 2>&1
        if [ $vsftp_flag -eq 0 ]; then
                if [ -f "/etc/passwd" ]; then
                        user_chk=`cat /etc/passwd | grep ^ftp:`
                        if [ "$user_chk" != "" ]; then
                                FTP=0
                        fi
                fi
        else
                if [ -f "/etc/vsftpd/vsftpd.conf" ]; then
                        conf_chk=`cat "/etc/vsftpd/vsftpd.conf" | grep -v '^#' | grep 'anonymous_enable'`
                        echo "Where : /etc/vsftpd/vsftpd.conf" >> $RESULT_FILE 2>&1
                elif [ -f "/etc/vsftpd.conf" ]; then
                        conf_chk=`cat "/etc/vsftpd.conf" | grep -v '^#' | grep 'anonymous_enable'`
                        echo "Where : /etc/vsftpd.conf"  >> $RESULT_FILE 2>&1
                else
                        echo "Not Found !" >> $RESULT_FILE 2>&1
                fi

                if [ "$conf_chk" != "" ]; then
                        echo "$conf_chk"  >> $RESULT_FILE 2>&1
                        conf_chk_tmp=`echo "$conf_chk" | awk -F"=" '{ print $2 }' | grep -i 'no'`
                        if [ "$conf_chk_tmp" == "" ]; then
                                FTP=0
                        fi
                else
                        echo "Not Found !"  >> $RESULT_FILE 2>&1
                fi
        fi
fi

#flag=0

#echo "4. FTP Anonymous FTP Configuration Check"  >> $RESULT_FILE 2>&1

#if [ `fgrep 'anonymous_enable=YES' /etc/vsftpd/vsftpd.conf` ]; then
#       echo "anonymous_enable=YES" >> $RESULT_FILE 2>&1
#       flag=0
#else
#       echo "Not Found"  >> $RESULT_FILE 2>&1
#       flag=1
#fi


#if [ $FTP -eq 1 ] && [ $flag -eq 1 ]; then
#       echo "Result : Good" >> $RESULT_FILE 2>&1
#else
#       echo "Result : Bad" >> $RESULT_FILE 2>&1
#fi

echo "" >> $RESULT_FILE 2>&1
echo "============================= END ===========================" >> $RESULT_FILE 2>&1
echo "" >> $RESULT_FILE 2>&1
                                                                                                                    358,8         Bo
