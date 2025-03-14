#!/usr/bin/env bash
# shellcheck disable=SC2154

if [[ "${EXIT_STATUS}" == 0 ]];then
_result="✅ Successfully Mirrored: \`${GITHUB_REPOSITORY}\`"$'\n\n'"- ${REMOTE_URL}"
    _details="<details><summary>Results</summary>"
else
    _result="⛔ Error Mirroring: \`${GITHUB_REPOSITORY}\`"
    _details="<details open><summary>Errors</summary>"
fi

cat << EOM
## Mirror Repository Action

${_result}

${_details}

\`\`\`text
${MIRROR_RESULTS}
\`\`\`

</details>

[View Documentation, Report Issues or Request Features](https://github.com/cssnr/mirror-repository-action?tab=readme-ov-file#readme)

---
EOM
