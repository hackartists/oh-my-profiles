#!/bin/bash

function backup {
    local d=`date +%Y%m%d%H%M`
    filename=$(basename -- "$1")
    extension="${filename##*.}"
    cp $1 $filename-$d.$extension
    echo "$1 was backed up as $filename-$d.$extension"
}
