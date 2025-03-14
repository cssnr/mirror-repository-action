#!/usr/bin/env bash
# https://github.com/cssnr/mirror-repository-action

set -e

# shellcheck disable=SC2317
function exit_trap() {
    _ST="$?"
    if [[ "${_ST}" != "0" ]]; then
        echo -e "⛔ \u001b[31;1mMirror Failed for: ${GITHUB_REPOSITORY}"
        echo "::error::Failed to mirror ${GITHUB_REPOSITORY}. See logs for details..."
    else
        echo -e "✅ \u001b[32;1mFinished Success"
    fi
    exit "${_ST}"
}
trap exit_trap EXIT HUP INT QUIT PIPE TERM

## Set Variables

echo "::group::Starting Mirror Repository Action ${GITHUB_ACTION_REF}"

echo "User: $(whoami)"
echo "Script: ${0}"
echo "Current Directory: $(pwd)"
echo "Home Directory: ${HOME}"

echo "---------- VARIABLES ----------"
echo "INPUT_SUMMARY: ${INPUT_SUMMARY}"
echo "GITHUB_EVENT_NAME: ${GITHUB_EVENT_NAME}"
echo "GITHUB_REF: ${GITHUB_REF}"
echo "GITHUB_REPOSITORY: ${GITHUB_REPOSITORY}"
echo "GITHUB_REPOSITORY_OWNER: ${GITHUB_REPOSITORY_OWNER}"

echo "INPUT_PRIVATE: ${INPUT_PRIVATE}"
if [[ "${INPUT_PRIVATE}" == "true" ]];then
    REPO_VISIBILITY="Private"
elif [[ "${INPUT_PRIVATE}" == "false" ]];then
    REPO_VISIBILITY="Public"
else
    echo "::warning::Unable to determine repository private status, defaulting to true."
    INPUT_PRIVATE="false"
    REPO_VISIBILITY="Private"
fi
echo "REPO_VISIBILITY: ${REPO_VISIBILITY}"

echo "::endgroup::"

## Process Variables

if [[ -z "${INPUT_URL}" ]];then
    echo -e "\u001b[35;1mNo INPUT_URL: Processing variables manually."
    HOST="${INPUT_HOST:?Missing Input Host}"
    OWNER="${INPUT_OWNER:-${GITHUB_REPOSITORY_OWNER}}"
    REPO="${INPUT_REPO:-$(echo "${GITHUB_REPOSITORY}" | awk -F'/' '{print $2}')}"
    REMOTE_URL="${HOST}/${OWNER}/${REPO}"
else
    echo -e "\u001b[35;1mINPUT_URL Provided: Processing variables from URL."
    HOST=$(echo "${INPUT_URL}" | sed -E 's|(https?://[^/]+).*|\1|')
    OWNER=$(echo "${INPUT_URL}" | sed -E 's|https?://[^/]+/([^/]+)/.*|\1|')
    REPO=$(echo "${INPUT_URL}" | sed -E 's|https?://[^/]+/[^/]+/([^/]+).*|\1|')
    REMOTE_URL="${INPUT_URL}"
fi

echo -e "HOST: \u001b[33;1m${HOST}"
echo -e "OWNER: \u001b[33;1m${OWNER}"
echo -e "REPO: \u001b[33;1m${REPO}"
echo -e "REMOTE_URL: \u001b[33;1m${REMOTE_URL}"

USERNAME="${INPUT_USERNAME:-${OWNER}}"
echo -e "USERNAME: \u001b[36;1m${USERNAME}"

PASSWORD="${INPUT_PASSWORD:?Missing Input Password}"
#echo "PASSWORD: ${PASSWORD}"

GIT_HOST=$(echo "${REMOTE_URL}" | awk -F'/' '{print $3}')
echo -e "GIT_HOST: \u001b[36;1m${GIT_HOST}"

GIT_URL="https://${GIT_HOST}"
echo -e "GIT_URL: \u001b[36;1m${GIT_URL}"

if [[ -n "${INPUT_CREATE}" ]];then
    echo "::group::Attempting Create Repository"
    set +e
    # shellcheck source=/src/codeberg.sh
    source /src/codeberg.sh
    set -e
    echo "::endgroup::"
fi

## Setup Mirror

echo "::group::Setting up Mirror"
git config --global --add safe.directory "$(pwd)"
git config --global credential.helper cache
git credential approve <<EOF
protocol=https
host=${GIT_HOST}
username=${USERNAME}
password=${PASSWORD}
EOF
git remote add mirror "${REMOTE_URL}"
git remote -v
echo "::endgroup::"

## Push Changes

echo "Pushing Changes"
COMMAND=("git" "push" "--tags" "--follow-tags" "--force" "--prune" "mirror" "refs/remotes/origin/*:refs/heads/*")
exec 5>&1
set +e
# shellcheck disable=SC2034
MIRROR_RESULTS=$( "${COMMAND[@]}" 2>&1 | tee >(cat >&5) ; exit "${PIPESTATUS[0]}" )
EXIT_STATUS="$?"
set -e

## Write Summary

if [[ "${INPUT_SUMMARY}" == "true" ]];then
    echo "📝 Writing Job Summary"
    # shellcheck source=/src/summary.sh
    source /src/summary.sh >> "${GITHUB_STEP_SUMMARY}" ||\
        echo "::error::Failed to Write Job Summary!"
fi

echo "::debug::EXIT_STATUS: ${EXIT_STATUS}"
exit "${EXIT_STATUS}"
