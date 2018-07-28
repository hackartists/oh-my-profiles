docker_cli=/usr/local/bin/docker

function docker_help {
    usage=`$docker_cli $@`
    usage+="\n"
    usage+="Addtional customized commands:\n"
    usage+="  tags \t listing tags of a image\n"
    usage+="  cmd  \t executing command with default \"-it\" options\n"
    usage+="  sh   \t entering bash shell in a container if bash exists, otherwise sh\n"
	usage+="  rmf  \t remove images with prefix image name\n"
    usage+="  iso  \t run a container derived by a image and isolate current directory.\n"

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

function docker_rmf {
    prefix=$1

	case "$prefix" in
		"" )
			echo "Enter the prifix name of images."
			echo "if you want to remove all of images, use '-all','--all' or '-a' flags"
			echo "ex) docker rmf --all"
			exit 1
			;;
		"none" )
			prefix="<none"
			;;
		"-all" | "--all" | "-a" )
			prefix=""
			;;
	esac

	docker rmi $(docker images | grep "^$prefix" | awk '{print $3}')
}

function docker_iso {
    res=`docker run --rm --workdir /workdir -v $(pwd):/workdir $@ bash`
    res=`echo $?`

    if [[ "$res" == "0" ]]
    then
        sh=bash
    else
        sh=sh
    fi

    docker run --rm -it --workdir /workdir -v $(pwd):/workdir $@ $sh
}

function docker {
    if [[ "$1" == "" ]]
    then
        docker_help $@
    else
        case $1 in
            tags | cmd | sh | rmf | iso)
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
