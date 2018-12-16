function rm {
    if [ "$1" == "--trash" ]
    then
        /bin/rm -rf ~/.Trash/*
    else
        mv $@ $HOME/.Trash/
    fi
}

