#!/bin/bash
main () {
    local -a list=()
    list+=("id")
    list+=("ls -l /etc/passwd /etc/group")
    list+=("tail -n2 /etc/passwd")
    list+=("tail -n2 /etc/group")
    list+=("ls -ld ${STARTUPDIR} /home ${HOME}")
    list+=("ls -l ${STARTUPDIR}")
    list+=("mkdir -p ${HOME}/new-dir")
    list+=("touch ${HOME}/new-file")
    list+=("ls -l ${HOME}")
    for t in "${list[@]}" ; do
        echo -e "+ ${t}"
        ${t}
    done
}
main | tee test-01.log
