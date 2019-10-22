#!/bin/bash

pipe=~/.pipe_exec

if [[ ! -p $pipe ]]; then
    mkfifo $pipe
    chmod 600 $pipe
fi

if [[ -z "$SCHROOT_SESSION_ID" ]]; then
    while true
    do
        if read line <$pipe; then
    	echo $line
    	eval $line
        fi
    done
else
    if [[ -L $0 ]]; then
        # called as a symlink, we want to send the symlink name and parameters
	echo `basename $0` "$@"  > $pipe
    else
        # called as original, send just the parameters
        echo "$@" > $pipe
    fi
fi

