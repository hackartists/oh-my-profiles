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

function git_gx {
    p=github.com/ground-x/$1

    mkdir -p $devel/$p
    $git_cli clone --recursive git@github.com:ground-x/$1 $devel/$p
    cd $devel/$p
}

function git {
    case $1 in
        dev | gx | hub)
            cmd=git_$1
            shift
            $cmd $@
            ;;
        * )
            $git_cli $@
            ;;
    esac
}
