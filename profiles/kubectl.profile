function kll {
    kubectl logs  $(kgp | grep $1 | awk '{print $1}' tail -n 1) $2
}

function kllf {
    kubectl logs -f $(kgp | grep $1 | awk '{print $1}') $2
}
