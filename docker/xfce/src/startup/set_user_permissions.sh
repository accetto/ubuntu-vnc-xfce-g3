#!/bin/bash
### every exit != 0 fails the script
#set -e     # do not use
#set -u     # do not use

main() {
    local verbose=""

    if [ -n "${DEBUG}" ] ; then
        echo "Current user: $(id -u)"
        verbose="-v"
    fi

    ### Fix file permissions
    for i in "$@" ; do

        if [ -n "${verbose}" ] ; then echo "Fixing permissions for: ${i}" ; fi

        ### folder and its current content belong to the group zero for better portability (recursively)
        chgrp -R 0 "$i"

        ### group members allowed to execute current '*.sh' scripts in the folder (recursively)
        find "$i"/ -name '*.sh' -exec chmod ${verbose} g+x {} +

        ### group members allowed to execute current launchers in the folder (recursively)
        find "$i"/ -name '*.desktop' -exec chmod ${verbose} g+x {} +

        ### all users have write permissions to the current folder content (recursively)
        chmod -R ${verbose} a+rw "$i"

        ### all users have execute permissions to all current folder directories (recursively)
        find "$i" -type d -exec chmod ${verbose} a+x {} +
    done
}

main $@
