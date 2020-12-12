#!/bin/bash
### @accetto, September 2019

### resolve also symlinks
_current_dir="$(dirname "$(readlink -f "$0")")"

ubuntu=$("${_current_dir}/version_of.sh" ubuntu)
firefox=$("${STARTUPDIR}/version_of.sh" firefox)

main() {
    local key

    if [ $# -gt 0 ] ; then
        while [ $# -gt 0 ] ; do
            key="$1"
            if [ "${key}" = '--' ] ; then shift ; fi
            case "${key}" in
                -h )
                    echo "Usage: version_sticker [-h] [-v] [-V] [-f]"
                    echo "-h    help"
                    echo "-v    short version sticker"
                    echo "-V    verbose version sticker"
                    echo "-f    features"
                    ;;
                -v )
                    echo "Ubuntu ${ubuntu}"
                    echo "Firefox ${firefox}"
                    ;;
                -V )
                    echo "Ubuntu ${ubuntu}"
                    version=$("${_current_dir}/version_of.sh" nano)
                    if [ -n "${version}" ] ; then echo "nano ${version}" ; fi
                    version=$("${_current_dir}/version_of.sh" jq)
                    if [ -n "${version}" ] ; then echo "jq ${version}" ; fi
                    version=$("${_current_dir}/version_of.sh" mousepad)
                    if [ -n "${version}" ] ; then echo "Mousepad ${version}" ; fi
                    version=$("${_current_dir}/version_of.sh" tigervnc)
                    if [ -n "${version}" ] ; then echo "TigerVNC ${version}" ; fi
                    version=$("${_current_dir}/version_of.sh" screenshooter)
                    if [ -n "${version}" ] ; then echo "xfce4-screenshooter ${version}" ; fi
                    version=$("${_current_dir}/version_of.sh" ristretto)
                    if [ -n "${version}" ] ; then echo "Ristretto ${version}" ; fi
                    version=$("${_current_dir}/version_of.sh" novnc)
                    if [ -n "${version}" ] ; then echo "noVNC ${version}" ; fi
                    version=$("${_current_dir}/version_of.sh" websockify)
                    if [ -n "${version}" ] ; then echo "websockify ${version}" ; fi
                    echo "Firefox ${firefox}"
                    ;;
                -f )
                    env | grep "FEATURES_" | sort
                    ;;
            esac
            shift
        done
    else
        ### example: ubuntu20.04.1-firefox81.0
        sticker="ubuntu${ubuntu}"-"firefox${firefox}"
        echo "${sticker}"
    fi
}

main $@
