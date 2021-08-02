#!/bin/bash

main() {

    local blend=${1?Need blend}
    local cmd=${2?Need command}

    local log="scrap_builder.log"

    case "${cmd}" in

        pre_build | build | push | post_push )

            ./docker/hooks/"${cmd}" dev "${blend}"
            ;;

        all )

            ./docker/hooks/pre_build dev "${blend}" > "${log}"

            if [[ $? -eq 0 ]] ; then

                if grep -Po 'new image should be built|Building of new image has been forced' "${log}" ; then

                    for c in "build" "push" "post_push" ; do

                        echo
                        echo "-------------"
                        echo "--> ${c}"
                        echo "-------------"
                        echo

                        ./docker/hooks/"${c}" dev "${blend}"

                        if [[ $? -ne 0 ]] ; then exit ; fi
                    done

                    rm -f "${log}"

                    echo
                    echo "----"
                    echo "Done"
                    echo "----"
                    echo

                else
                    echo
                    echo "------------------------------------------------"
                    echo "No build needed for '${blend}'"
                    echo "------------------------------------------------"
                    echo
                fi
            fi
            ;;

        *)
            echo "Unknown command: ${cmd}"
            ;;
    esac
}

main $@
