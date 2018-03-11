oh_my_profiles_dir=$HOME/.oh-my-profiles
profile=$oh_my_profiles_dir/var/profile

function oh_my_profiles_imports {
    for f in $oh_my_profiles_dir/profiles/*.profile;
    do
        source $f
    done

    source $profile
}

function oh_my_profiles_init {
    oh_my_profiles_imports
    mkdir -p $oh_my_profiles_dir/var
}

oh_my_profiles_init
