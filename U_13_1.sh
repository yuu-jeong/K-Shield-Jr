#########################################################################################
# - U-13 SUID, SGID, Sticky bit
#########################################################################################
echo "[ U - 1 3 ] Check"
echo "=======================[ U - 1 3 SUID / SGID / Sticky bit]============================" >> $RESULT_FILE 2>&1
echo "" >> $RESULT_FILE 2>&1

FILES="/sbin/dump /sbin/restore /sbin/unix_chkpwd /usr/bin/newgrp /usr/sbin/traceroute /usr/bin/at /usr/bin/lpq /usr/bin/lpq-lpd /usr/bin/lpr /usr/bin/lpr-lpd /usr/sbin/lpc /usr/sbin/lpc-lpd /usr/bin/lprm /usr/bin/lprm-lpd /text3.txt"

count=0

# Find file's symbolickLink
for file_chk in $FILES; do
        if [ -f "$file_chk" ]; then
                if [ -h "$file_chk" ]; then
                        echo "Symboliclink : `ls -al $real_path`" >> $RESULT_FILE 2>&1
                        real_path=`readlink $real_path`
                        while true; do
                                if [ -h "$real_path" ]; then
                                        echo "Symboliclink : `ls -al $real_path`" >> $RESULT_FILE 2>&1
                                        real_path=`readlink $real_path`
                                else
                                        file_chk=$real_path
                                        break
                                fi
                        done
                fi
                perm_chk=`ls -alL $file_chk | awk '{ print $1 }' | grep -i 's'`
                echo "`ls -al $file_chk`" >> $RESULT_FILE 2>&1
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

