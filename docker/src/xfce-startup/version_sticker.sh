#!/bin/bash
### @accetto, September 2019

### resolve also symlinks
_current_dir="$(dirname "$(readlink -f "$0")")"

ubuntu=$("${_current_dir}/version_of.sh" ubuntu)
chromium=$("${STARTUPDIR}/version_of.sh" chromium)
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

                -f )
                    env | grep "FEATURES_" | sort
                    ;;

                -v )
                    if [ -n "${chromium}" ] ; then echo "Chromium ${chromium}" ; fi
                    if [ -n "${firefox}" ] ; then echo "Firefox ${firefox}" ; fi
                    echo "Ubuntu ${ubuntu}"
                    ;;

                -V )
                    if [ -n "${chromium}" ] ; then echo "Chromium ${chromium}" ; fi

                    # version=$("${_current_dir}/version_of.sh" dconf-editor)
                    # if [ -n "${version}" ] ; then echo "dconf-editor ${version}" ; fi

                    if [ -n "${firefox}" ] ; then echo "Firefox ${firefox}" ; fi

                    version=$("${_current_dir}/version_of.sh" jq)
                    if [ -n "${version}" ] ; then echo "jq ${version}" ; fi

                    version=$("${_current_dir}/version_of.sh" mousepad)
                    if [ -n "${version}" ] ; then echo "Mousepad ${version}" ; fi

                    version=$("${_current_dir}/version_of.sh" nano)
                    if [ -n "${version}" ] ; then echo "nano ${version}" ; fi

                    version=$("${_current_dir}/version_of.sh" novnc)
                    if [ -n "${version}" ] ; then echo "noVNC ${version}" ; fi

                    version=$("${_current_dir}/version_of.sh" python3)
                    if [ -n "${version}" ] ; then echo "Python ${version}" ; fi

                    version=$("${_current_dir}/version_of.sh" ristretto)
                    if [ -n "${version}" ] ; then echo "Ristretto ${version}" ; fi

                    version=$("${_current_dir}/version_of.sh" screenshooter)
                    if [ -n "${version}" ] ; then echo "Screenshooter ${version}" ; fi

                    version=$("${_current_dir}/version_of.sh" tigervnc)
                    if [ -n "${version}" ] ; then echo "TigerVNC ${version}" ; fi

                    echo "Ubuntu ${ubuntu}"

                    version=$("${_current_dir}/version_of.sh" websockify)
                    if [ -n "${version}" ] ; then echo "websockify ${version}" ; fi
                    ;;
            esac
            shift
        done
    else
        sticker="ubuntu${ubuntu}"

        if [ -n "${chromium}" ] ; then
            sticker="${sticker}-chromium${chromium}"
        elif [ -n "${firefox}" ] ; then
            sticker="${sticker}-firefox${firefox}"
        fi
        
        echo "${sticker}"
    fi
}

main $@
