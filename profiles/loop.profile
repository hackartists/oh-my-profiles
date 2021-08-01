function loop {
    interval=1s
    if [ "$INTERVAL" != "" ]
    then
        interval=$INTERVAL
    fi
    i=0

    while [ 1=1 ]
    do
        res=`$@`
        echo "$res"
        echo "Completed: $i tries"
        i=$((i+1))
        sleep $interval
    done

}
