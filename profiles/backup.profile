#!/bin/bash

function backup {
    local d=`date +%Y%m%d%H%M`
    if [ -f $1 ]
    then
        filename=$(basename -- "$1")
        extension="${filename##*.}"
        cp $1 $filename-$d.$extension
        echo "$1 was backed up as $filename-$d.$extension"
    elif [ -d $1 ]
    then
        mv $1 $1-$d
        echo "$1 was backed up as $1-$d"
    fi

}
