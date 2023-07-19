########################################################################################
# U-24
########################################################################################
echo "[ U-24 ] : Check"
echo "======================= [ U - 24 ] ==============================" >> $RESULT_FILE 2>&1

get_ps=`ps -ef | grep -v 'grep' | grep '\[nfsd\]|\[lockd\]|\[statd\]'`
echo "1. NFS Process Check" >> $RESULT_FILE 2>&1

if [ $get_ps ]; then
        echo "$get_ps" >> $RESULT_FILE 2>&1
else
        echo "Not Found Process" >> $RESULT_FILE 2>&1
fi

echo "" >> $RESULT_FILE 2>&1
echo "2. NFS recinfo Check" >> $RESULT_FILE 2>&1

rpcinfo=`rpcinfo -p `
echo $rpcinfo  >> $RESULT_FILE 2>&1
get_recinfo=`rpcinfo -p | egrep 'nfs|nlockmgr|status'`
echo "" >> $RESULT_FILE 2>&1

if [ "$get_ps" != "" ] || [ "$get_rpcinfo" != "" ]; then
        echo "Result : Bad" >> $RESULT_FILE 2>&1
else
        echo "Result : Good" >> $RESULT_FILE 2>&1
fi

echo "" >> $RESULT_FILE 2>&1
echo "=========================== END ============================" >> $RESULT_FILE 2>&1
