profile=$oh_my_profiles_dir/var/profile

function addpath {
    n=$1

    echo "export $n=$(pwd)" >> $profile
    source $profile
}
