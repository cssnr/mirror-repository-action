#!/usr/bin/env bash

set -e

echo "::group::Starting Mirror Repository Action ${GITHUB_ACTION_REF}"
echo "User: $(whoami)"
echo "Script: ${0}"
echo "Current Directory: $(pwd)"
echo "Home Directory: ${HOME}"
echo "---------- GITHUB ----------"
echo "GITHUB_EVENT_NAME: ${GITHUB_EVENT_NAME}"
echo "GITHUB_REF: ${GITHUB_REF}"
echo "GITHUB_REPOSITORY: ${GITHUB_REPOSITORY}"
echo "GITHUB_REPOSITORY_OWNER: ${GITHUB_REPOSITORY_OWNER}"
echo "::endgroup::"

if [ -z "${INPUT_URL}" ];then
    echo "No INPUT_URL: Processing variables manually."
    HOST="${INPUT_HOST:?err}"
    OWNER="${INPUT_OWNER:-${GITHUB_REPOSITORY_OWNER}}"
    REPO="${INPUT_REPO:-$(echo "${GITHUB_REPOSITORY}" | awk -F'/' '{print $2}')}"
    REMOTE_URL="${HOST}/${OWNER}/${REPO}"
else
    echo "INPUT_URL Provided: Processing variables from INPUT_URL."
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
echo "USERNAME: ${USERNAME}"

PASSWORD="${INPUT_PASSWORD:?err}"
#echo "PASSWORD: ${PASSWORD}"

GIT_HOST=$(echo "${REMOTE_URL}" | awk -F'/' '{print $3}')
echo "GIT_HOST: ${GIT_HOST}"

GIT_URL="https://${GIT_HOST}"
echo "GIT_URL: ${GIT_URL}"

if [ -n "${INPUT_CREATE}" ];then
    echo "::group::Attempting Create Repository"
    set +e
    # shellcheck source=/src/codeberg.sh
    source /src/codeberg.sh
    set -e
    echo "::endgroup::"
fi

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

echo "Pushing Changes"

git push --tags --follow-tags --force --prune mirror "refs/remotes/origin/*:refs/heads/*"

echo -e "\u001b[32;1mFinished Success."
