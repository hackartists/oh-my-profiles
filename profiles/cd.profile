#!/bin/bash
export CDPATH=.

while IFS= read -r line
do
    export CDPATH=$CDPATH:$line
done <<< $(find $devel -maxdepth 3 -type d)

