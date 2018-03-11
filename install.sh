#!/bin/bash
name=.oh-my-profiles
install_dir=$HOME/$name
s=`echo $SHELL | sed 's/.*\///g'`
sh_conf=$HOME/.${s}rc

function oh_my_profiles_main {
    git clone https://github.com/pwnartist/oh-my-profiles.git $install_dir
    echo "source $install_dir/init.profile" >> $sh_conf
    source $sh_conf
}

oh_my_profiles_main
