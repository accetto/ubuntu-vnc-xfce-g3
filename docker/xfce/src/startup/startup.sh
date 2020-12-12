#!/bin/bash

#set -e     ### do not use this

declare _mydir=$(dirname $0)

source "${_mydir}"/help.rc
source "${_mydir}"/parser.rc
source "${_mydir}"/user_generator.rc
source "${_mydir}"/vnc_startup.rc

cleanup () {
    local readonly last_pid=$!

    ### also forwarding of shutdown signal
    if [ -n "${last_pid}" ] || [ -n "${_wait_pid}" ] ; then
        
        if [ "${last_pid}" != "${_wait_pid}" ] ; then
            if [ -n "${_verbose}" ] ; then echo "Killing last background PID '${last_pid}'" ; fi
            kill -s SIGTERM "${last_pid}"
        fi

        ### kill the PID the container is waiting on
        if [ -n "${_wait_pid}" ] ; then
            if [ -n "${_verbose}" ] ; then echo "Killing blocking PID '${_wait_pid}'" ; fi
            ### ignore the errors if not alive any more
            kill -s SIGTERM "${_wait_pid}" > /dev/null 2>&1
        fi
    fi

    die "$1" 0
}

execute_command() {

    if [ -n "$@" ] ; then
    
        if [ -n "${_verbose}" ] ; then echo "Executing startup command: $@" ; fi

        ### use 'eval' not 'exec'
        ### note the single space before the command!
        eval " $@"

        if [ $? -ne 0 ] ; then
            cleanup
        fi
    fi
}

main() {

    ### option interdependencies
    if [ "${_arg_verbose}" == "on" ] || [ "${_arg_debug}" == "on" ] ; then 
        _verbose=1
    fi
    if [ "${_arg_skip_vnc}" == "on" ] ; then
        _arg_skip_novnc="on"
    fi

    ### option "--debug"
    if [ "${_arg_debug}" == "on" ] ; then
        echo "Script: $0"
        echo "\${HOME}=${HOME}"

        echo "ls -la /" ; ls -la /
        echo "ls -ls /etc/passwd /etc/group" ; ls -ls /etc/passwd /etc/group
        echo "ls -la /home" ; ls -la /home
        echo "ls -la ${HOME}" ; ls -la "${HOME}"
        echo "ls -la ." ; ls -la .
    fi

    ### create container user
    generate_container_user

    if [ "$?" != "0" ] ; then
        echo "ERROR: Unable to generate the container user '$(id -u):$(id -g)'."
        if [ $(id -g) -ne 0 ] ; then
            echo -e "HINT: You have overriden also the user's group ID. Be sure to use an image \nthat has been built with the build argument ARG_FEATURES_USER_GROUP_OVERRIDE."
        fi
        cleanup
    fi

    ### options '--version-sticker' and '--version-sticker-verbose'
    if [ "${_arg_version_sticker}" == "on" ] || [ "${_arg_version_sticker_verbose}" == "on" ] ; then

        ### this handles also '--skip-vnc' and '--skip-novnc' options
        start_vnc

        ### do not use '_verbose' which can be forced by '--debug'
        if [ "${_arg_version_sticker_verbose}" == "off" ] ; then

            ### print out default version sticker
            "${STARTUPDIR}"/version_sticker.sh
            cleanup

        else
            ### print out verbose version sticker
            ### be sure to use capital '-V'
            "${STARTUPDIR}"/version_sticker.sh -f -V
            cleanup
        fi
    fi

    ### options '--tail-vnc' and '--tail-null'
    if [ "${_arg_tail_vnc}" == "on" ] || [ ${_arg_tail_null} == "on" ] ; then

        ### this handles also '--skip-vnc' and '--skip-novnc' options
        start_vnc

        ### command array expands to all elements quoted as a whole
        execute_command "${_arg_command[*]}"

        ### option '--tail-vnc' and VNC has been started
        if [ ${_arg_tail_vnc} == "on" ] && [ -n "${_wait_pid}" ] ; then

            ### tail the VNC log infinitely
            echo "Tailing VNC log '${_vnc_log}'"
            tail -f "${_vnc_log}"
            cleanup

        else

            ### tail the null device infinitelly
            if [ -n $"{_verbose}" ] ; then echo "Tailing '/dev/null'" ; fi
            tail -f /dev/null
            cleanup
        fi
    fi

    ### default backround execution mode
    ### be sure to end all previous branches by calling 'cleanup'
    ### option '--wait' is purely because of the parser

    ### this handles also '--skip-vnc' and '--skip-novnc' options
    start_vnc

    ### command array expands to all elements quoted as a whole
    execute_command "${_arg_command[*]}"

    if [ -n "${_wait_pid}" ] ; then

        ### VNC has been started - wait on its PID
        wait ${_wait_pid}
    else

        ### VNC not started - go asleep infinitely
        sleep infinity
    fi
}

### MAIN ENTRY POINT

if [ -z "${DEBUGGER}" ] ; then
    trap cleanup SIGINT SIGTERM ERR
    : ${HOME?} ${STARTUPDIR?}
fi

declare _novnc_log="${STARTUPDIR}"/novnc.log
declare _verbose=""
declare _vnc_log="${STARTUPDIR}"/vnc.log
declare _wait_pid=""

### option '--skip-startup'
if [ "${_arg_skip_startup}" == "on" ] ; then

    ### command array expands to all elements quoted as a whole
    execute_command "${_arg_command[*]}"

else

    main $@

fi

cleanup
