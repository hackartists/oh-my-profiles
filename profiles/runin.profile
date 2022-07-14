#!/bin/bash

function runin {
    local TTY=$1
    shift
    setsid sh -c "exec $@ <> /dev/pts/$TTY >&0 2>&1"
}

alias fork="setsid sh -c "
