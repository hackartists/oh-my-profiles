
function iter_convert_to_png() {
    for f in $1 ;  do convert "$f" "${f%.*}.png" ; done
}
