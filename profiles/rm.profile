function rm {
    if [ "$1" == "--trash" ]
    then
        /bin/rm -rf ~/.Trash
        mkdir ~/.Trash
    else
        for p in "$@";
        do
            # ignore any arguments
            if [[ "$p" = -* ]]; then :
            else
                if [ -e ~/.Trash/$p ];
                then
                    mv "$p" ~/.Trash/"${p##*/}-`date +%Y%m%d%H%M%S`"
                fi
            fi
        done
    fi
}

