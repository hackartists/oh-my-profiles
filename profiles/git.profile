git_cli=/usr/bin/git

function git_dev {
    u=$1
    p=`echo "${u:0:-4}" | sed -e "s/http:\/\///g" -e "s/https:\/\///g" -e "s/git\@//g" -e "s/-.*[a-z]:/\//g" -e "s/:/\//g"`

    mkdir -p $devel/$p
    $git_cli clone --recursive $1 $devel/$p
    cd $devel/$p
}

function git_hub {
    git_dev git@github.com:$1.git
}

function git {
    cmd=git_$1
    chk=`which $cmd`
    if [ "$?" != "0" ]
    then
        $git_cli $@
    else
        shift
        $cmd $@
    fi
}
