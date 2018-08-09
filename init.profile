oh_my_profiles_dir=$HOME/.oh-my-profiles
profile=$oh_my_profiles_dir/var/profile

function oh_my_profiles_imports {
    for f in $oh_my_profiles_dir/profiles/*.profile;
    do
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
    ov=`git rev-parse --short origin/master`

    if [ "$cv" != "$ov" ]
    then
        echo "[Oh My Profile] Would you like to update? [Y/n]: \c"
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
    cd $install_dir
    cv=`git rev-parse --short HEAD`
    ov=`git rev-parse --short origin/master`

    if [ "$cv" != "$ov" ]
    then
        echo "[Emacs] Would you like to update? [Y/n]: \c"
        read line
        if [[ "$line" == Y* ]] || [[ "$line" == y* ]] || [ -z "$line" ]; then
            git pull
        fi
    fi
    cd $dir
}

function oh_my_profiles_init {
    oh_my_profiles_update
    oh_my_profiles_imports
    mkdir -p $oh_my_profiles_dir/var
    fpath=($oh_my_profiles_dir/zsh-completions $fpath)
}

oh_my_profiles_init
