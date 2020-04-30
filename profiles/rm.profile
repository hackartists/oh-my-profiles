function rm {
    local trash_dir=$HOME/.rm-trash
    mkdir -p $trash_dir

    if [[ "$1" == "--trash" ]]
    then
        /bin/rm -rf $trash_dir
        mkdir $trash_dir
    else
        for p in "$@";
        do
            # ignore any arguments
            if [[ "$p" = -* ]]; then :
            else
                mv "$p" $trash_dir/"${p##*/}-`date +%Y%m%d%H%M%S`"
            fi
        done
    fi
}

