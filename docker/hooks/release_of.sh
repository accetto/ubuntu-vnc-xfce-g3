#!/bin/bash -e

main() {
    local result=""

    case "$1" in

        chromium | chromium-browser | chromiumbrowser)
            result=$( \
                curl -s http://archive.ubuntu.com/ubuntu/pool/universe/c/chromium-browser/ \
                | grep -Po -m1 '(?<=href=")[^_]*_([0-9.]+-0ubuntu0\.18\.04\.[^_"]*)_[^"]*' \
                | cut -d _ -f 2 )
            ;;

    esac

    echo "${result}"
}

main $@
