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
	usage+="  logf \t monitors logging from the current time\n"
    usage+="  shell\t mount a bash shell for the current directory with a container\n"

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
   ## echo $@
    $docker_cli exec -it $@
}

function docker_logf {
	$docker_cli logs -f --tail 0 $@
}

function docker_shell {
    net=dev-net
    img=ubuntu
    sh=bash

    while [ "$1" != "" ]
    do
        case $1 in
            --network)
                net=$2
                shift
                shift
                ;;
            --shell)
                sh=$2
                shift
                shift
                ;;
            *)
                break
                ;;
        esac
    done

    img=$1
    shift

    name=$(echo $img | sed 's/\//-/g' | sed 's/:/-/g')

    docker run -it --rm -v $(pwd):/workdir --name $name --workdir /workdir --network $net $@ $img $sh
}

function docker_sh {
    tag=`docker ps | grep $1 | awk '{print $1}'`
    res=`$docker_cli exec -it $tag ls /bin/bash`
    res=`echo $?`

    if [[ "$res" == "0" ]]
    then
        sh=bash
    else
        sh=sh
    fi

    $docker_cli exec -it $tag $sh
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

	$docker_cli rmi $(docker images | grep "^$prefix" | awk '{print $3}')
}
function docker_rme {
    $docker_cli rm -f $(docker ps -a | grep Exited | awk '{print $1}')
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

    $docker_cli run --rm -it --workdir /workdir -v $(pwd):/workdir $@ $sh
}

function docker {
    if [[ "$1" == "" ]]
    then
        docker_help $@
    else
        case $1 in
            tags | cmd | sh | rmf | iso | logf | rme | shell)
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
