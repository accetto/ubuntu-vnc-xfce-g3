#!/bin/bash
#set -e     # do not use
#set -u     # do not use

main() {
    local verbose=""

    if [[ -n "${DEBUG}" ]] ; then
        echo "Current user: $(id -u):$(id -g)"
        verbose="-v"
    fi

    ### Fix file permissions
    for i in "$@" ; do

        if [[ -n "${verbose}" ]] ; then

            echo "Fixing permissions for: ${i}"
        fi

        ### set directory permissions (recursively)
        find "$i" -type d -exec chmod ${verbose} 755 {} +

        ### set file permissions (recursively)
        find "$i" -type f -exec chmod ${verbose} 644 {} +

        ### specific file permissions (recursively)
        find "$i"/ -type f -name '*.sh' -exec chmod ${verbose} 744 {} +
        find "$i"/ -type f -name '*.desktop' -exec chmod ${verbose} 744 {} +
    done

    ### startup script is special
    chmod 755 "${STARTUPDIR}"/startup.sh
}

main $@
