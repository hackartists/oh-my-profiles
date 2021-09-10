function kas_help {
    echo "KAS Utilities"
}

function kas_db_connect {
    local env=$1
    local srv=$2
    shift
    shift

    kas ctx $env

    case $env in
        qa-2 )
            sqlhost=kas-qa-2-app.cluster-cnuopt13avbx.ap-northeast-2.rds.amazonaws.com
            sqluser=gx-dev-rw
            sqlpw=$GX_QA_MYSQL_PWD
            ;;
    esac

    local pod=`kubectl get pods --field-selector=status.phase=Running | grep $srv | head -1 | awk '{print $1}'`
    kubectl exec -n kas-$env -c $srv $pod -- apk add mysql-client

    kubectl exec -n kas-$env -it -c $srv $pod -- /bin/sh -c "MYSQL_PWD=$sqlpw mysql -h $sqlhost -u $sqluser"
}

function kas_db {
    if [ "$1" = "connect" ]
    then
        shift
        kas_db_connect $@
        return
    fi

    local env=$1
    local srv=$2
    shift
    shift

    kas ctx $env

    case $env in
        qa-2 )
            sqlhost=kas-qa-2-app.cluster-cnuopt13avbx.ap-northeast-2.rds.amazonaws.com
            sqluser=gx-dev-rw
            sqlpw=$GX_QA_MYSQL_PWD
            ;;
    esac

    local pod=`kubectl get pods --field-selector=status.phase=Running | grep $srv | head -1 | awk '{print $1}'`
    kubectl exec -n kas-$env -c $srv $pod -- apk add mysql-client

    while [ "$1" != "" ]
    do
        echo "Executing $1 on $pod"
        kubectl exec -n kas-$env -it -c $srv $pod -- /bin/sh -c "wget $1 -O /app/sql.ddl"
        kubectl exec -n kas-$env -it -c $srv $pod -- /bin/sh -c "MYSQL_PWD=$sqlpw mysql -h $sqlhost -u $sqluser < /app/sql.ddl"
        shift
    done
}

function kas_ctx {
    local env=$1
   case $env in
       dev )
           cn=service-dev
           ;;
       qa-2 )
           cn=service-qa-common
           ;;
       perf )
           cn=service-qa-perf
           ;;
       * )
           cn=service-$env-common
           ;;
   esac

	kubectl config use-context arn:aws:eks:ap-northeast-2:069889557760:cluster/$cn
	kubectl config set-context --current --namespace=kas-$env
}

function kas_config {
    if [ "" = "$1" ]
    then
        srv=`basename $(pwd)`
    else
        srv=$1
    fi

    if [ "" = "$2" ]
    then
        conf=config.yaml
    else
        conf=$2
    fi

    kas ctx dev
    kubectl exec -it -n kas-dev -c $srv deployment/$srv cat /config/config.yaml > $conf
}

function kas_vpn {
    isOpened=`openvpn3 sessions-list | grep kubeVPN | wc -l`
    case $1 in
        open )
            if [ $isOpened  = 0 ]
            then
                openvpn3 session-start -c $HOME/kubeVPN.ovpn
            else
                echo "connection has been already opened."
            fi
            ;;
        close )
            if [ $isOpened -gt 0 ]
            then
                openvpn3 session-manage --disconnect -c $HOME/kubeVPN.ovpn
            else
                echo "not found any connection"
            fi
            ;;
    esac
}

function kas_okta_update {
    kas_okta_create $@
}

function kas_okta_create {
    setup_file=~/.okta-aws
    aws_config=~/.aws/config
    # pip3 install okta-awscli
    user=$USER

    rm -rf ~/.aws
    rm -rf $setup_file
    touch $setup_file
    cat <<EOT >> $setup_file
[default]
username = $user@groundx.xyz
factor = OKTA
app-link = https://groundx.okta.com/home/amazon_aws/0oa3b7q2dEHRFlkab5d6/272
base-url = groundx.okta.com
duration = 43200
EOT

    mkdir -p ~/.aws
    touch $aws_config
    cat <<EOT >> $aws_config
[default]
region = ap-northeast-2
output=json
EOT

    echo "Setting up Okta (default)..."
    okta-awscli --okta-profile default --profile default
    echo "Testing AWS CLI (default)"
    aws sts get-caller-identity

    echo ""
    echo "Setting up Kubernetes Clusters for Development Team"
    echo "Updating kubernetes config for DEV"
    aws --profile default eks update-kubeconfig --name service-dev --region ap-northeast-2
    # aws --profile default eks update-kubeconfig --name service-dev-common --region ap-northeast-2

    echo "Updating kubernetes config for QA"
    aws --profile default eks update-kubeconfig --name service-qa --region ap-northeast-2
    # aws --profile default eks update-kubeconfig --name service-qa-common --region ap-northeast-2

    echo "Updating kubernetes config for PERF"
    aws --profile default eks update-kubeconfig --name service-qa-perf --region ap-northeast-2

    # echo "Updating kubernetes config for PROD"
    # aws --profile service-prod eks update-kubeconfig --name service-prod-common --region ap-northeast-2

}

function kas_okta {
    if [[ "$1" == "" ]]
    then
        kas_help $@
    else
        case $1 in
            update | create)
                cmd=$0_$1
                shift
                $cmd $@
                ;;
            * )
                $docker_cli $@
                ;;
        esac
    fi
}

function kas_action_resource {
    env=$1
    srv=$2

    code=`kas_action_getcode $env $srv`

    resources=`curl -s -X GET https://$host/v1/authority/service/${code} | jq -c ".Resources|map(.Name)[]"`

    echo $resources
}

function kas_action_register {
    env=$1
    srv=$2

    code=`kas_action_getcode $env $srv`
    isadmin=false
    method="get"
    desc=""
    deps_opts=""

    while [ "$1" != "" ]
    do
       case $1 in
           -d)
               deps_opts=$2
               shift
               ;;
           --desc)
               desc=$2
               shift
               ;;
           -m)
               method=$2
               shift
               ;;
           -p)
               path=$2
               shift
               ;;
           -a)
               isadmin=$2
               shift
               ;;
           *)
               action=$1
               ;;
       esac
       shift
    done

    deps=(${deps_opts//,/ })
    rc=0
    data="{\"ResourceID\": $rc, \"ActionName\": \"$action\", \"AccessLevel\": \"read\", \"ActionDescription\": \"$desc\", \"RestIF\": { \"Path\": \"$path\", \"Method\": \"$method\" }, \"DependencyActions\": [], \"IsAdminAPI\": $isadmin }"

    for i in "${deps[@]}"
    do

    done


}

function kas_action_getcode {
    env=$1
    srv=$2

    if [[ "$1" == "" ]]
    then
        kas_help $@
        exit -1
    fi
    case $env in
        dev)
            host="auth-api.dev.klaytn.com"
            ;;
        prod)
            host="auth-api.klaytnapi.com"
            ;;
    esac

    srvcode=`curl -s -X GET https://$host/v1/authority/service | jq -c "map(select(.Name==\"$srv\"))[0].ID"`

    echo "$srvcode"
}

function kas_action_service {
    env=$1

    if [[ "$1" == "" ]]
    then
        kas_help $@
        return
    fi
    case $env in
        dev)
            host="auth-api.dev.klaytn.com"
            ;;
        prod)
            host="auth-api.klaytnapi.com"
            ;;
    esac

    srvs=`curl -s -X GET https://$host/v1/authority/service | jq -c "map(.Name)[]"`
    echo $srvs
}

function kas_action {
    if [[ "$1" == "" ]]
    then
        kas_help $@
    else
        case $1 in
            register|service|getcode|resource)
                cmd=$0_$1
                shift
                $cmd $@
                ;;
        esac
    fi
}

function kas_test {
    auth=$1
    while [ 1=1 ]
    do
        curl https://wallet-api.klaytnapi.com/v2/account --header "authorization: $auth" --header "x-chain-id: 1001";
    done
}

function kas {
    if [[ "$1" == "" ]]
    then
        kas_help $@
    else
        case $1 in
            help | okta | vpn | config | ctx | db | action | test)
                cmd=$0_$1
                shift
                $cmd $@
                ;;
            * )
                $docker_cli $@
                ;;
        esac
    fi
}
