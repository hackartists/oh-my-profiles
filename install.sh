name=.oh-my-profiles
install_dir=$HOME/$name
s=`echo $SHELL | sed 's/.*\///g'`
sh_conf=$HOME/.${s}rc

function oh_my_profiles_main {
    git clone https://github.com/pwnartist/oh-my-profiles.git $install_dir
    for f in $install_dir/zsh-theme/*
    do
        ln -s $f $HOME/.oh-my-zsh/themes/
    done
    echo "source $install_dir/init.profile" >> $sh_conf
    source $install_dir/init.profile
}

oh_my_profiles_main
