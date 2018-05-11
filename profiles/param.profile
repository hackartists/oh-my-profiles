profile=$oh_my_profiles_dir/var/profile

function addpath {
    n=$1

    echo "export $n=$(pwd)" >> $profile
    source $profile
}

function addbinpath {
    echo "addbinpath"

    if [ "$1" = "" ]
    then
        p=$(pwd)
    else
        p=$1
    fi

    echo "export PATH=\$PATH:$p" >> $profile
    source $profile
}
