#############################################################################
# - U-07 /etc/passwd
############################################################################
echo "[ U-07 ] : Check"
echo "======================[ U - 0 7 /etc/passwd ] ===========================" >> $RESULT_FILE 2>&1
echo "" >> $RESULT_FILE 2>&1

if [ -f "/etc/passwd" ]; then
        ls -l /etc/passwd >> $RESULT_FILE 2>&1
        permission_val=`stat -c '%a' /etc/passwd`
        owner_val=`stat -c '%U' /etc/passwd`
        owner_perm_val=`echo "$permission_val" | awk '{ print substr($0, 1, 1) }'`
        group_perm_val=`echo "$permission_val" | awk '{ print substr($0, 2, 1) }'`
        other_perm_val=`echo "$permission_val" | awk '{ print substr($0, 3, 1) }'`
        if [ "$owner_perm_val" -le 6 ] && [ "$group_perm_val" -le 4 ] && [ "$other_perm_val" -le 4 ] && [ "$owner_val" = "root" ]; then
                echo "Result : Good" >> $RESULT_FILE 2>&1
        else
                echo "Result : Bad" >> $RESULT_FILE 2>&1
        fi
else
        echo "Not Found /etc/passwd file" >> $RESULT_FILE 2>&1
        echo "Result : Not Yet" >> $RESULT_FILE 2>&1
fi
echo "" >> $RESULT_FILE 2>&1
echo "========================= END ================================" >> $RESULT_FILE 2>&1
echo "" >> $RESULT_FILE 2>&1
