docker_cli=/usr/local/bin/docker

function docker_help {
    usage=`$docker_cli $@`
    usage+="\n"
    usage+="Addtional customized commands:\n"
    usage+="  tags \t listing tags of a image\n"
    usage+="  cmd  \t executing command with default \"-it\" options\n"
    usage+="  sh   \t entering bash shell in a container if bash exists, otherwise sh\n"

    echo $usage
}

function docker_tags {
    img_name=$1

    if [[ "$img_name" != *"/"* ]]
    then
        img_name=library/$img_name
    fi
    curl --stderr /dev/null https://registry.hub.docker.com/v2/repositories/$img_name/tags/ | jq -r '.results[]["name"]'
}

function docker_cmd {
    echo $@
    $docker_cli exec -it $@
}

function docker_sh {
    res=`$docker_cli exec -it $1 ls /bin/bash`
    res=`echo $?`

    if [[ "$res" == "0" ]]
    then
        sh=bash
    else
        sh=sh
    fi

    $docker_cli exec -it $1 $sh
}

function docker {
    if [[ "$1" == "" ]]
    then
        docker_help $@
    else
        case $1 in
            tags | cmd | sh)
                cmd=docker_$1
                shift
                $cmd $@
                ;;
            * )
                $docker_cli $@
                ;;
        esac
    fi
}
