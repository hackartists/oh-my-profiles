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

function oh_my_profiles_init {
    oh_my_profiles_imports
    mkdir -p $oh_my_profiles_dir/var
    fpath=($oh_my_profiles_dir/zsh-completions $fpath)
}

oh_my_profiles_init
