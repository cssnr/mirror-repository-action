#!/usr/bin/env bash

set -e

echo "Running: ${0} as: $(whoami) in: $(pwd)"

echo "---------- GITHUB ----------"

echo "GITHUB_EVENT_NAME: ${GITHUB_EVENT_NAME}"
echo "GITHUB_REF: ${GITHUB_REF}"
#echo "GITHUB_BASE_REF: ${GITHUB_BASE_REF}"
#echo "GITHUB_HEAD_REF: ${GITHUB_HEAD_REF}"
#echo "GITHUB_REF_NAME: ${GITHUB_REF_NAME}"
#echo "GITHUB_REPOSITORY: ${GITHUB_REPOSITORY}"
#echo "GITHUB_RUN_NUMBER: ${GITHUB_RUN_NUMBER}"
#echo "GITHUB_RUN_ATTEMPT: ${GITHUB_RUN_ATTEMPT}"
echo "GITHUB_REPOSITORY: ${GITHUB_REPOSITORY}"
echo "GITHUB_REPOSITORY_OWNER: ${GITHUB_REPOSITORY_OWNER}"

echo "---------- INPUTS ----------"

[[ -n "${INPUT_URL}" ]] && REMOTE_URL="${INPUT_URL}"
#echo "REMOTE_URL: ${REMOTE_URL}"
if [ -z "${INPUT_URL}" ];then
    HOST="${INPUT_HOST:?err}"
    echo "HOST: ${HOST}"
    OWNER="${INPUT_OWNER:-${GITHUB_REPOSITORY_OWNER}}"
    echo "OWNER: ${OWNER}"
    REPO="${INPUT_REPO:-$(echo "${GITHUB_REPOSITORY}" | awk -F'/' '{print $2}')}"
    echo "REPO: ${REPO}"
    REMOTE_URL="${HOST}/${OWNER}/${REPO}"
fi

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
    echo "Attempting Create Repository: ${INPUT_CREATE}"
    set +e
    # shellcheck source=/src/codeberg.sh
    source /src/codeberg.sh
    set -e
fi


git config --global --add safe.directory "$(pwd)"

git config --global credential.helper cache
git credential approve <<EOF
protocol=https
host=${GIT_HOST}
username=${USERNAME}
password=${PASSWORD}
EOF

#echo "git branch: $(git branch)"
#BRANCH1="$(git rev-parse --abbrev-ref HEAD)"
#echo "BRANCH1: ${BRANCH1}"
BRANCH="$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)"
echo "BRANCH: ${BRANCH}"

git remote add mirror "${REMOTE_URL}"
git remote -v

git push --tags --follow-tags --force --prune mirror "refs/remotes/origin/*:refs/heads/*"

#if [ "${GITHUB_EVENT_NAME}" == "push" ];then
#    echo "event: ${GITHUB_EVENT_NAME}"
#    #git push mirror "${BRANCH}"
#    git push --tags --force --prune mirror "refs/remotes/origin/*:refs/heads/*"
#else
#    echo -e "\u001b[31;1mUNKNOWN event: ${GITHUB_EVENT_NAME}"
#fi

echo -e "\u001b[32;1mFinished Success."
