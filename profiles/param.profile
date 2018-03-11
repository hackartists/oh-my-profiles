profile=$oh_my_profiles_dir/var

function addpath {
    n=$1

    echo "export $n=$(pwd)" >> $profile
}
