# Profile directories

This repository manages customized command profiles.

## Installation
Oh My Profiles can be installed by running `curl` or `wget`.

via curl

``` shell
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/hackartists/oh-my-profiles/master/install.sh)"
```

via wget

``` shell
    sh -c "$(wget https://raw.githubusercontent.com/hackartists/oh-my-profiles/master/install.sh -O -)"
```

## Profiles


### Docker profile

Docker profile adds two commands: `cmd` and `tags`.


| Command | Description                    |
|---------|--------------------------------|
| `cmd`   | terminal execution in a docker |
| `tags`  | listing all of tags            | 
| `sh`    | execute a shell(`bash` or `sh`)|
| `rmf`   | delete images with prefix name |
| `iso`   | isolate docker image with current directory | 

Example:

``` shell
name=container-name
docker cmd $cname cat /etc/passwd  # this will execute `cat /etc/passwd` in $cname container
docker sh $cname  # this will simply execute bash of $cname container
docker tags ubuntu  # this will list tags of ubuntu image
docker rmf hyperledger   # this will remove all of hyperledger dockers
docker iso bash     # this will run bash image with isolated current directory
docker iso -v /host/volume1:/container/dir2 -e CONTAINER_ENV="env" bash  ## also we can use additional options, which ca be used for run options
```

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

## Git profile
For managing source codes for developers, git profile added consistent hierarchical directory path of git clone.
Before you uses this profile, you should set `devel` paramerter. 
Simply, you can add the devel paramerter belows:

``` shell
cd path-to-devel
addpath devel
```

After adding `devel` environment parameter, you can use `git dev` sub-command.

| Command | Description                    |
|---------|--------------------------------|
| `dev`   | Make directory hierarchy and clone a repository |

Example:

``` shell
git dev url-for-clone
```

### CD profile
For quickly move between directories for development, finding and moving into a development directory feature was added into `cd`.
`cd` firstly find and move natively; namely, it can work as original `cd` command.
Secondly, `cd` will find and move the name of a specified directory from `$devel` directory.
For moving the directory from `$devel`, `cd` will find the name from `$devel` only inside 3-depth.

Natively, we can change directory to `cd $devel/github.com/hyperledger/fabric`.
This profile make us change directory to only just with `cd fabric`
