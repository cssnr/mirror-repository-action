[![GitHub Tag Major](https://img.shields.io/github/v/tag/cssnr/mirror-repository-action?sort=semver&filter=!v*.*&logo=git&logoColor=white&labelColor=585858&label=%20)](https://github.com/cssnr/mirror-repository-action/tags)
[![GitHub Tag Minor](https://img.shields.io/github/v/tag/cssnr/mirror-repository-action?sort=semver&filter=!v*.*.*&logo=git&logoColor=white&labelColor=585858&label=%20)](https://github.com/cssnr/mirror-repository-action/tags)
[![GitHub Release Version](https://img.shields.io/github/v/release/cssnr/mirror-repository-action?logo=git&logoColor=white&labelColor=585858&label=%20)](https://github.com/cssnr/mirror-repository-action/releases/latest)
[![Workflow Release](https://img.shields.io/github/actions/workflow/status/cssnr/mirror-repository-action/release.yaml?logo=github&label=release)](https://github.com/cssnr/mirror-repository-action/actions/workflows/release.yaml)
[![Workflow Test](https://img.shields.io/github/actions/workflow/status/cssnr/mirror-repository-action/test.yaml?logo=github&label=test)](https://github.com/cssnr/mirror-repository-action/actions/workflows/test.yaml)
[![Workflow Lint](https://img.shields.io/github/actions/workflow/status/cssnr/mirror-repository-action/lint.yaml?logo=github&label=lint)](https://github.com/cssnr/mirror-repository-action/actions/workflows/lint.yaml)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=cssnr_mirror-repository-action&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=cssnr_mirror-repository-action)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/cssnr/mirror-repository-action?logo=github&label=updated)](https://github.com/cssnr/mirror-repository-action/graphs/commit-activity)
[![Codeberg Last Commit](https://img.shields.io/gitea/last-commit/cssnr/mirror-repository-action/master?gitea_url=https%3A%2F%2Fcodeberg.org%2F&logo=codeberg&logoColor=white&label=updated)](https://codeberg.org/cssnr/mirror-repository-action)
[![GitHub Top Language](https://img.shields.io/github/languages/top/cssnr/mirror-repository-action?logo=htmx)](https://github.com/cssnr/mirror-repository-action)
[![GitHub Org Stars](https://img.shields.io/github/stars/cssnr?style=flat&logo=github)](https://cssnr.github.io/)
[![Discord](https://img.shields.io/discord/899171661457293343?logo=discord&logoColor=white&label=discord&color=7289da)](https://discord.gg/wXy6m2X8wY)

# Mirror Repository Action

- [Inputs](#Inputs)
- [Setup Instructions](#Setup-Instructions)
- [Example](#Example)
- [Tags](#Tags)
- [Support](#Support)
- [Contributing](#Contributing)

Mirror Git Repository to Remote Host.

## Inputs

| Input      | Required  | Default      | Description                                              |
| :--------- | :-------: | :----------- | :------------------------------------------------------- |
| `url`      | or `host` | -            | \* Full URL to Mirror; Overrides: `host`/`owner`/`repo`  |
| `host`     | or `url`  | -            | \* Full Host to Mirror; Example: `https://codeberg.org`  |
| `owner`    |     -     | Repo Owner   | \* Repository Owner of Mirror (if different from source) |
| `repo`     |     -     | Repo Name    | \* Repository Name of Mirror (if different from source)  |
| `create`   |     -     | `false`      | \* Set to `true` to attempt to Create the Mirror Repo    |
| `username` |     -     | Repo Owner   | Username for Authentication to Mirror                    |
| `password` |  **Yes**  | -            | Token or Password for Authentication to Mirror           |
| `summary`  |     -     | `true`       | Add Job Summary. Set to `false` to Disable               |
| `priavte`  |     -     | Repo Private | If the Mirror Repo Status is Different from Source       |

**url/host:** You must provide either a full repository `url` or a `host` value.  
Example: https://github.com/cssnr/mirror-repository-action

**owner/repo:** If different from source, you must specify these values (overridden by `url`).

**create:** Tested with codeberg but should also work with gitea/forgejo. Set to `true` to enable.

**summary:** Write a Summary for the job. To disable this set to `false`.

<details><summary>👀 View Example Job Summary</summary>

---

✅ Successfully Mirrored: `cssnr/mirror-repository-action`

<details><summary>Results</summary>

```text
remote:
remote: Create a new pull request for 'summary':
remote:   https://codeberg.org/cssnr/mirror-repository-action/compare/master...summary
remote:
To https://codeberg.org/cssnr/mirror-repository-action
   98ffcda..94add29  origin/summary -> summary
```

</details>

---

</details>

## Setup Instructions

1. Create a Token for Mirror to use as a Password for Pushing Commits, or Creating Repositories.

   - Codeberg/Gitea/Forgejo go here: https://codeberg.org/user/settings/applications
   - Select Permissions: `write:organization` `write:repository` `write:user`

2. Create Remote Repository to Mirror (or set `create` to `true` for codeberg.org).

3. Go to the settings for your source repository on GitHub and add the `CODEBERG_TOKEN` secret.

   - For organizations, you can add the token one time at the Organization level.

4. Add the following file to source repository on GitHub: `.github/workflows/mirror.yaml`

   - The `owner` is automatically set to the GitHub Organization or Username if personal. Set to override.
   - The `repo` is automatically set to the GitHub Repository Name. This should only be set to rename repo.
   - For Codeberg, use the `host` to `https://codeberg.org` and set the `username` to your Codeberg username.

> [!TIP]  
> This process has been automated with a Web Extension.  
> However, currently requires manual installation:
> [cssnr/github-extension](https://github.com/cssnr/github-extension)

## Example

The below yaml is available in this file: [.github/workflows/mirror.yaml](mirror.yaml)

```yaml
name: 'Mirror'

on:
  workflow_dispatch:
  push:
    branches: ['**']
    tags: ['**']

jobs:
  mirror:
    name: 'Mirror'
    runs-on: ubuntu-latest
    timeout-minutes: 5

    steps:
      - name: 'Checkout'
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: 'Mirror to Codeberg'
        uses: cssnr/mirror-repository-action@v1
        with:
          #url: https://codeberg.org/cssnr/mirror-repository-action
          host: https://codeberg.org
          #owner: cssnr
          #repo: mirror-repository-action
          create: true
          username: shaner
          password: ${{ secrets.CODEBERG_TOKEN }}
```

> [!IMPORTANT]  
> Checkout `with: fetch-depth: 0` is necessary!

For more examples, you can check out other projects using this action:  
https://github.com/cssnr/mirror-repository-action/network/dependents

## Tags

The following rolling [tags](https://github.com/cssnr/mirror-repository-action/tags) are maintained.

| Version&nbsp;Tag                                                                                                                                                                                                                 | Rolling | Bugs | Feat. | Target   | Example  |
| :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :-----: | :--: | :---: | :------- | :------- |
| [![GitHub Tag Major](https://img.shields.io/github/v/tag/cssnr/mirror-repository-action?sort=semver&filter=!v*.*&style=for-the-badge&label=%20&color=44cc10)](https://github.com/cssnr/mirror-repository-action/releases/latest) |   ✅    |  ✅  |  ✅   | `vN.x.x` | `vN`     |
| [![GitHub Tag Minor](https://img.shields.io/github/v/tag/cssnr/mirror-repository-action?sort=semver&filter=!v*.*.*&style=for-the-badge&label=%20&color=blue)](https://github.com/cssnr/mirror-repository-action/releases/latest) |   ✅    |  ✅  |  ❌   | `vN.N.x` | `vN.N`   |
| [![GitHub Release](https://img.shields.io/github/v/release/cssnr/mirror-repository-action?style=for-the-badge&label=%20&color=red)](https://github.com/cssnr/mirror-repository-action/releases/latest)                           |   ❌    |  ❌  |  ❌   | `vN.N.N` | `vN.N.N` |

You can view the release notes for each version on the [releases](https://github.com/cssnr/mirror-repository-action/releases) page.

# Support

For general help or to request a feature, see:

- Q&A Discussion: https://github.com/cssnr/mirror-repository-action/discussions/categories/q-a
- Request a Feature: https://github.com/cssnr/mirror-repository-action/discussions/categories/feature-requests

If you are experiencing an issue/bug or getting unexpected results, you can:

- Report an Issue: https://github.com/cssnr/mirror-repository-action/issues
- Chat with us on Discord: https://discord.gg/wXy6m2X8wY
- Provide General Feedback: [https://cssnr.github.io/feedback/](https://cssnr.github.io/feedback/?app=Mirror%20Repository%20Action)

For more information, see the CSSNR [SUPPORT.md](https://github.com/cssnr/.github/blob/master/.github/SUPPORT.md#support).

# Contributing

Currently, the best way to contribute to this project is to star this project on GitHub.

For more information, see the CSSNR [CONTRIBUTING.md](https://github.com/cssnr/.github/blob/master/.github/CONTRIBUTING.md#contributing).

Additionally, you can support other GitHub Actions I have published:

- [Stack Deploy Action](https://github.com/cssnr/stack-deploy-action?tab=readme-ov-file#readme)
- [Portainer Stack Deploy](https://github.com/cssnr/portainer-stack-deploy-action?tab=readme-ov-file#readme)
- [VirusTotal Action](https://github.com/cssnr/virustotal-action?tab=readme-ov-file#readme)
- [Mirror Repository Action](https://github.com/cssnr/mirror-repository-action?tab=readme-ov-file#readme)
- [Update Version Tags Action](https://github.com/cssnr/update-version-tags-action?tab=readme-ov-file#readme)
- [Update JSON Value Action](https://github.com/cssnr/update-json-value-action?tab=readme-ov-file#readme)
- [Parse Issue Form Action](https://github.com/cssnr/parse-issue-form-action?tab=readme-ov-file#readme)
- [Cloudflare Purge Cache Action](https://github.com/cssnr/cloudflare-purge-cache-action?tab=readme-ov-file#readme)
- [Mozilla Addon Update Action](https://github.com/cssnr/mozilla-addon-update-action?tab=readme-ov-file#readme)
- [Docker Tags Action](https://github.com/cssnr/docker-tags-action?tab=readme-ov-file#readme)

For a full list of current projects to support visit: [https://cssnr.github.io/](https://cssnr.github.io/)
