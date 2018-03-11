oh_my_profiles_dir=$HOME/.oh-my-profiles

function oh_my_profiles_imports {
    for f in $oh_my_profiles_dir/profiles/*.profile;
    do
        echo "[Import] $f"
        source f
    done
}

function oh_my_profiles_init {
    oh_my_profiles_imports
    mkdir -p $oh_my_profiles_dir/var
}

oh_my_profiles_init
