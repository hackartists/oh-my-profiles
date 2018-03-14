# Profile directories

This repository manages customized command profiles.

## Installation
Oh My Profiles can be installed by running `curl` or `wget`.

via curl

``` shell
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/pwnartist/oh-my-profiles/master/install.sh)"
```

via wget

``` shell
    sh -c "$(wget https://raw.githubusercontent.com/pwnartist/oh-my-profiles/master/install.sh -O -)"
```

## Profiles


### Docker profile

Docker profile adds two commands: `cmd` and `tags`.


| Command | Description                    |
|---------|--------------------------------|
| `cmd`   | terminal execution in a docker |
| `tags`  | listing all of tags            | 

## Parameter tunning profile

Parameter tunning profile let you manage easily your shell parameters. 
Currently, it supports to add favorite directories by `addpath`.

| Command | Description                    |
|---------|--------------------------------|
| `addpath`   | let you access to the directory by an alias |
| `addbinpath`   | let you execute executable binaries in the directory |

Example:

``` shell
    cd path-to-your-favorite
    addpath my-fav
    cd $my-fav
    
    chmod +x path-to-bin/exec
    addbinpath path-to-bin
    exec
    
    chmod +x path-to-bin2/exec
    cd path-to-bin2
    addbinpath
    exec
```
