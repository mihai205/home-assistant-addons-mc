#!/usr/bin/env bash
#!/usr/bin/with-contenv bashio

function hasp::version() {
    local input_version=${1}
    local download_link=""

    if [ "$input_version" = "LATEST" ]; then
        input_version="LATEST"
    else
        download_link=$(cat /usr/bin/download_versions.json | jq -r -c '.[] | select(.bedrock_version | contains('\"$input_version\"')) | .download ')
    fi
    echo "${download_link}"
}


function hasp::version.cleanup() {
    local cleanup_path=${1}
    local path_stack=""

    path_stack=$(pwd)

    cd "${cleanup_path}" || exit 1

    mv ./worlds /tmp/worlds 2> /dev/null || true
    rm -rf -- * 2> /dev/null || true
    mv /tmp/worlds . 2> /dev/null || true
    cd "${path_stack}" || exit 1
}