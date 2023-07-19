#########################################################################################
# - U-13 SUID, SGID, Sticky bit
#########################################################################################
echo "[ U - 1 3 ] Check"
echo "=======================[ U - 1 3 SUID / SGID / Sticky bit]============================" >> $RESULT_FILE 2>&1
echo "" >> $RESULT_FILE 2>&1

FILES="/sbin/dump /sbin/restore /sbin/unix_chkpwd /usr/bin/newgrp /usr/sbin/traceroute /usr/bin/at /usr/bin/lpd /usr/bin/lpd-ppd /usr/bin/lpr /usr/bin/lpr-lpd /usr/sbin/lpc-lpd /usr/bbin/lprm /usr/bin/lprm-lpd"

count=0

for file_chk in $FILES; do
        if [ -f "$file_chk" ]; then
                perm_chk=`ls -alL $file_chk | awk '{ print $1 }' | grep -i 's'`
                echo "`ls -al $file_chk`" >> $RESULT_FILE 2>&1
                if [ "$perm_chk" != "" ]; then
                        count=`expr $count + 1`
                fi
        fi
done

echo "Count Result : $count" >> $RESULT_FILE 2>&1

if [ $count -eq 0 ]; then
        echo "Result : Good" >> $RESULT_FILE 2>&1
else
        echo "Result : Bad" >> $RESULT_FILE 2>&1
fi

echo "" >> $RESULT_FILE 2>&1
echo "========================================= END ==========================================" >> $RESULT_FILE 2>&1
