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
    docker exec -it $@
}

function docker {
    case $1 in
        tags | cmd )
            cmd=docker-$1
            shift
            $cmd $@
            ;;
        * )
            /usr/local/bin/docker $@
            ;;
    esac
}
