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

        if [ -z "${FEATURES_USER_GROUP_OVERRIDE}" ] ; then

            ### set directory permissions (recursively)
            find "$i" -type d -exec chmod ${verbose} 775 {} +

            ### set file permissions (recursively)
            find "$i" -type f -exec chmod ${verbose} 774 {} +

            ### specific file permissions (recursively)
            find "$i"/ -type f -name '*.sh' -exec chmod ${verbose} 775 {} +
            find "$i"/ -type f -name '*.desktop' -exec chmod ${verbose} 775 {} +

        else

            ### FEATURES_USER_GROUP_OVERRIDE requires looser permissions

            ### set directory permissions (recursively)
            find "$i" -type d -exec chmod ${verbose} 777 {} +

            ### set default file permissions (recursively)
            find "$i" -type f -exec chmod ${verbose} 776 {} +

            ### specific file permissions (recursively)
            find "$i"/ -type f -name '*.sh' -exec chmod ${verbose} 777 {} +
            find "$i"/ -type f -name '*.desktop' -exec chmod ${verbose} 777 {} +
        fi
    done
}

main $@
