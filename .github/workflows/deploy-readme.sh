#!/bin/bash

main() {
    local repo="${1?Need repo}"
    local gist="${2?Need gist}"
    local readme_context="${3?Need build context}"
    local readme_main="${4?Need readme main part}"
    local readme_append=${5?Need readme append template}

    local api_base_url="https://hub.docker.com/v2"
    local deployment_repo
    local readme_main_file="${PWD}/${readme_context}/${readme_main}"
    local readme_append_file="${PWD}/${readme_context}/${readme_append}"
    local scrap_append_file="${PWD}/${readme_context}/scrap-append.tmp"
    local readme_upload_file="${PWD}/${readme_context}/scrap-readme.md"
    local repo_name
    local repo_owner
    local response
    local user_name="${DOCKERHUB_USERNAME}"
    local user_pwd="${DOCKERHUB_PASSWORD}"
    local token

    if [ ! -f "${readme_main_file}" ] ; then
        echo  "File not found: '${readme_main_file}'"
        return 1
    fi
    if [ ! -f "${readme_append_file}" ] ; then
        echo  "File not found: '${readme_append_file}'"
        return 1
    fi

    ### extract the repo owner and its name
    ### alternative 1
    repo_name="$(basename $repo)"
    repo_owner="$(basename $(dirname ${repo}))"
    ### alternative 2
    # repo_name="${repo##*/}"
    # repo_owner="${repo%$repo_name}" ; repo_owner="${repo_owner::-1}" ; repo_owner="${repo_owner##*/}"
    ### also ensure that the deployment repo has only two parts like 'repo_owner/repo_name'
    # deployment_repo="$(basename $(dirname ${repo}))/$(basename ${repo})"
    deployment_repo="${repo_owner}/${repo_name}"

    ### create the actual README file for Docker Hub by replacing the variables in the append-template (badge links)
    ### and appending it to the main-readme partial file
    ### it is expected that the readme include template contains the following variables:
    ### ${OWNER}    - owner of the deployment repository and also the related deployment gist
    ### ${GIST}     - gist containing the badge endpoints
    ### ${REPO}     - name of the deployment repository

    ### replace the environment variables in the template
    ( OWNER="${repo_owner}" GIST="${gist}" REPO="${repo_name}" envsubst < "${readme_append_file}" > "${scrap_append_file}" )

    ### append the updated template to the main readme part
    cat "${readme_main_file}" "${scrap_append_file}" > "${readme_upload_file}"

    # get token to be able to talk to Docker Hub
    echo "GET token"
    token=$( curl -s \
        -X POST \
        "${api_base_url}/users/login/" \
        -H "Content-Type: application/json" \
        -d '{"username": "'${user_name}'", "password": "'${user_pwd}'"}' | sed -e 's/.*"token": "\(.*\)".*/\1/' )
    
    echo "UPDATE Docker Hub description using '${readme_upload_file}'"
    response=$( curl -s \
        -X PATCH \
        "${api_base_url}/repositories/${deployment_repo}/" \
        -H "Authorization: JWT ${token}" \
        --write-out %{response_code} \
        --output /dev/null \
        --data-urlencode "full_description@${readme_upload_file}" )

    if [ ${response} -eq 200 ] ; then
        echo "${response}. UPDATE success."
        return 0
    else
        echo "ERROR: ${response}. Unable to UPDATE Docker Hub description."
        echo user_name="${user_name}"
        echo deployment_repo="${deployment_repo}"
        echo readme_upload_file=${readme_upload_file}
        echo api_base_url=${api_base_url}
        echo "curl -H "Authorization: JWT ${token}" -X PATCH --data-urlencode full_description@${readme_upload_file} ${api_base_url}/repositories/${deployment_repo}/"
        curl -v -H "Authorization: JWT ${token}" -X PATCH --data-urlencode full_description@${readme_upload_file} ${api_base_url}/repositories/${deployment_repo}/
        return 1
    fi
}

main $@
