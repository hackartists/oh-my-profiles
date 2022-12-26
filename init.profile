oh_my_profiles_dir=$HOME/.oh-my-profiles
profile=$oh_my_profiles_dir/var/profile
confdir=$HOME/.config/oh-my-profiles

function oh_my_profiles_imports {
    if [ -d $confdir ]
    then
        for f in $confdir/*.profile;
        do
            source $f
        done
    fi

    for f in $oh_my_profiles_dir/profiles/*.profile;
    do
        echo "$f"
        source $f
    done

    if [ -e $profile ]
    then
        source $profile
    fi
}

function oh_my_profiles_update {
    install_dir=$oh_my_profiles_dir
    dir=`pwd`
    cd $install_dir
    cv=`git rev-parse --short HEAD`
    b=`git rev-parse --abbrev-ref HEAD`
    ov=`git rev-parse --short origin/$b`

    if [ "$cv" != "$ov" ]
    then
        echo "[Oh My Profile:$cv/$ov] Would you like to update? [Y/n]: \c"
        read line
        if [[ "$line" == Y* ]] || [[ "$line" == y* ]] || [ -z "$line" ]; then
            git pull
            for f in $install_dir/zsh-theme/*
            do
                ln -s $f $HOME/.oh-my-zsh/themes/
            done
        fi
    fi

    install_dir=$HOME/.emacs.d
    if [ -d "$install_dir/.git" ]
    then

        cd $install_dir
        cv=`git rev-parse --short HEAD`
        b=`git rev-parse --abbrev-ref HEAD`
        ov=`git rev-parse --short origin/$b`

        if [ "$cv" != "$ov" ]
        then
            echo "[Emacs] Would you like to update? [Y/n]: \c"
            read line
            if [[ "$line" == Y* ]] || [[ "$line" == y* ]] || [ -z "$line" ]; then
                git pull
            fi
        fi
    fi
    cd $dir
}

function oh_my_profiles_setup_devel {
    if [[ "$devel" == "" ]]
    then
        devel=$HOME/data/devel
        mkdir -p $devel
    fi
}

function oh_my_profiles_init {
    oh_my_profiles_update
    oh_my_profiles_setup_devel
    oh_my_profiles_imports
    fpath=($oh_my_profiles_dir/zsh-completions $fpath)
}

oh_my_profiles_init
