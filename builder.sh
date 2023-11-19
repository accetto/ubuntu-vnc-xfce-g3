#!/bin/bash -e
### @accetto, August 2021
### updated: September 2022, January 2023

### depends on the hook scripts
### set the environment variables first, e.g. 'source .secrets'

### usage: './<script-name> <blend> <cmd> [build-options]'

die() {
    local message="${1:-(unknown)}"
    local -i code=${2:-1}
    local place="${3:-$0}"

    echo -e "EXITING at line "${BASH_LINENO[0]}" in '${place}' with code ${code}: ${message}" >&2
    exit ${code}
}

clear_log() {

    ### just for debugging
    # cp -f "${_ci_builder_log}" "${_ci_builder_log}_copy"

    > "${_builder_log}"
    echo -e "\n==> EXECUTING @$(date -u +'%Y-%m-%d_%H-%M-%S'): ${0} $@\n"
}

show_error() {

    echo -e "\nERROR: ${@:-(unknown)}\n" >&2
}

show_unlogged_help() {

    # help is never logged
    exec 1>&-
    {
        cat <<EOT

This script can:
- build and publish the individual images
- execute the individual hook scripts of the building pipeline '/docker/hooks/'
- refresh the local builder 'g3-cache'

Usage: $0 <blend> <command> [<docker-cli-options>]

blend   := (latest|jammy|focal)[-chromium|-firefox]
command := (all|all-no-push)|(pre_build|build|push|post_push|cache)

The <docker-cli-options> (e.g. '--no-cache') are passed to the Docker CLI commands used internally.

The script creates a complete execution log.
EOT
    } >&3
}

main() {

    if [[ $# -eq 0 ]] ; then

        show_unlogged_help
        return 0
    fi

    if [[ "${1}" == "-h" || "${1}" =~ help ]] ; then
    
        show_unlogged_help
        return 0
    fi

    local blend=${1}
    local cmd=${2}

    if [[ $# -ge 2 ]] ; then shift 2 ; fi

    local -a all_pipeline
    local -i exit_code=0

    case "${cmd}" in

        pre_build | build | push | post_push | cache )

            clear_log
            "${_build_context}"/hooks/"${cmd}" dev "${blend}" $@
            exit_code=$?
            if [[ ${exit_code} -ne 0 ]] ; then die "Hook script '${cmd}' failed with code ${exit_code}." ${exit_code} ; fi
            ;;

        all | all-no-push )

            clear_log
            "${_build_context}"/hooks/pre_build dev "${blend}" $@
            exit_code=$?
            if [[ ${exit_code} -ne 0 ]] ; then die "Hook script 'pre_build' failed with code ${exit_code}." ${exit_code} ; fi

            if [[ ! -f "${_build_context}"/scrap-demand-stop-building ]] ; then

                case "${cmd}" in
                    all-no-push ) all_pipeline=("build")                    ;;
                    all         ) all_pipeline=("build" "push" "post_push") ;;

                    * )
                        show_error "Unknown command: '${cmd}'"
                        ;;
                esac

                for c in ${all_pipeline[@]} ; do

                    echo
                    echo "==> ${c} '${blend}'"
                    echo

                    "${_build_context}"/hooks/"${c}" dev "${blend}" $@
                    exit_code=$?
                    if [[ ${exit_code} -ne 0 ]] ; then die "Hook script '${c}' failed with code ${exit_code}." ${exit_code} ; fi
                done

                echo
                case "${cmd}" in

                    all-no-push )
                        echo "==> Built '${blend}'"
                        ;;
                    all )
                        echo "==> Published '${blend}'"
                        ;;
                    * )
                        show_error "Unknown command: '${cmd}'"
                        ;;
                esac
                echo
                
            else
                echo
                echo "==> No build needed for '${blend}'"
                echo
            fi
            ;;

        *)
            show_error "Invalid arguments '${blend}' '${cmd}'"
            ;;
    esac

    echo -e "\n==> FINISHED  @$(date -u +'%Y-%m-%d_%H-%M-%S'): ${0} $@\n"
}

declare _build_context="./docker"
declare _builder_log="scrap_builder.log"

### duplicate 'stdout' so we can close it when displaying help
exec 3>&1

### main entry point
declare -i __exit_code=0
main $@ 2>&1 | tee -a "${_builder_log}"
__exit_code=${PIPESTATUS[0]}

exit ${__exit_code}
