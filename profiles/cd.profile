function cd {
    name=$1
    test=`pushd $(pwd)/$name 2> /dev/null`
    tres=`echo $?`
    if [ $tres != 0 ]
    then
        d=`find $devel -maxdepth 3 -type d -name "$name" -print -quit`
        if [ "$d" != "" ]
        then
            name=$d
        fi
    fi

    pushd $name 1> /dev/null
}
