#!/usr/bin/env bash

set +e

echo "Creating ${REPO_VISIBILITY} Repository."

read -r -d '' BODY << EOF
{
  "auto_init": true,
  "default_branch": "master",
  "name": "${REPO:?err}",
  "object_format_name": "sha1",
  "private": ${INPUT_PRIVATE}
}

EOF

echo "${BODY}"

if [ "${USERNAME}" = "${OWNER}" ];then
    echo "Personal Repository Detected."
    URL="${GIT_URL}/api/v1/user/repos"
else
    echo "Organization Repository Detected."
    URL="${GIT_URL}/api/v1/orgs/${OWNER}/repos"
fi

echo "CREATE URL: ${URL}"

curl -X POST \
     -H "Authorization: token ${PASSWORD}" \
     -H "accept: application/json" \
     -H "Content-Type: application/json" \
     -d "${BODY}" \
     "${URL}"
