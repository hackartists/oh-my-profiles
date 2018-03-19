git_cli=/usr/bin/git

function git_dev {
    p=`echo $1 | sed -e "s/http:\/\///g" -e "s/https:\/\///g" -e "s/git\@//g" -e "s/.git//g" -e "s/:/\//g"`

    mkdir -p $devel/$p
    $git_cli clone $1 $devel/$p
    cd $devel/$p
}

function git {
    case $1 in
        dev )
            cmd=git_$1
            shift
            $cmd $@
            ;;
        * )
            $git_cli $@
            ;;
    esac
}
