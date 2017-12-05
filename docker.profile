cli=/usr/local/bin/docker

function docker-help {
    usage=`$cli $@`
    usage+="\n"
    usage+="Addtional customized ommands:\n"
    usage+="  tags \t listing tags of a image\n"
    usage+="  cmd  \t executing command with default \"-it\" options\n"
    usage+="  sh   \t entering bash shell in a container if bash exists, otherwise sh\n"

    echo $usage
}

function docker-tags {
    img_name=$1

    if [[ "$img_name" != *"/"* ]]
    then
        img_name=library/$img_name
    fi
    curl --stderr /dev/null https://registry.hub.docker.com/v2/repositories/$img_name/tags/ | jq -r '.results[]["name"]'
}

function docker-cmd {
    echo $@
    $cli exec -it $@
}

function docker-sh {
    if [[ `$cli exec -it ls /bin/base 2 > /dev/null` != "" ]]
    then
        sh=bash
    else
        sh=sh
    fi

    $cli exec -it $1 $sh
}

function docker {
    if [[ "$1" == "" ]]
    then
        docker-help $@
    else
        case $1 in
            tags | cmd | sh)
                cmd=docker-$1
                shift
                $cmd $@
                ;;
            * )
                $cli $@
                ;;
        esac
    fi
}
