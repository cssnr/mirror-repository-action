[![GitHub Tag Major](https://img.shields.io/github/v/tag/cssnr/mirror-repository-action?sort=semver&filter=!v*.*&logo=git&logoColor=white&labelColor=585858&label=%20)](https://github.com/cssnr/mirror-repository-action/tags)
[![GitHub Tag Minor](https://img.shields.io/github/v/tag/cssnr/mirror-repository-action?sort=semver&filter=!v*.*.*&logo=git&logoColor=white&labelColor=585858&label=%20)](https://github.com/cssnr/mirror-repository-action/releases)
[![GitHub Release Version](https://img.shields.io/github/v/release/cssnr/mirror-repository-action?logo=git&logoColor=white&labelColor=585858&label=%20)](https://github.com/cssnr/mirror-repository-action/releases/latest)
[![Workflow Release](https://img.shields.io/github/actions/workflow/status/cssnr/mirror-repository-action/release.yaml?logo=cachet&label=release)](https://github.com/cssnr/mirror-repository-action/actions/workflows/release.yaml)
[![Workflow Test](https://img.shields.io/github/actions/workflow/status/cssnr/mirror-repository-action/test.yaml?logo=cachet&label=test)](https://github.com/cssnr/mirror-repository-action/actions/workflows/test.yaml)
[![Workflow Lint](https://img.shields.io/github/actions/workflow/status/cssnr/mirror-repository-action/lint.yaml?logo=cachet&label=lint)](https://github.com/cssnr/mirror-repository-action/actions/workflows/lint.yaml)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=cssnr_mirror-repository-action&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=cssnr_mirror-repository-action)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/cssnr/mirror-repository-action?logo=github&label=updated)](https://github.com/cssnr/mirror-repository-action/pulse)
[![Codeberg Last Commit](https://img.shields.io/gitea/last-commit/cssnr/mirror-repository-action/master?gitea_url=https%3A%2F%2Fcodeberg.org%2F&logo=codeberg&logoColor=white&label=updated)](https://codeberg.org/cssnr/mirror-repository-action)
[![GitHub Contributors](https://img.shields.io/github/contributors/cssnr/mirror-repository-action?logo=github)](https://github.com/cssnr/mirror-repository-action/graphs/contributors)
[![GitHub Repo Size](https://img.shields.io/github/repo-size/cssnr/mirror-repository-action?logo=bookstack&logoColor=white&label=repo%20size)](https://github.com/cssnr/mirror-repository-action?tab=readme-ov-file#readme)
[![GitHub Top Language](https://img.shields.io/github/languages/top/cssnr/mirror-repository-action?logo=htmx)](https://github.com/cssnr/mirror-repository-action)
[![GitHub Discussions](https://img.shields.io/github/discussions/cssnr/mirror-repository-action?logo=github)](https://github.com/cssnr/mirror-repository-action/discussions)
[![GitHub Forks](https://img.shields.io/github/forks/cssnr/mirror-repository-action?style=flat&logo=github)](https://github.com/cssnr/mirror-repository-action/forks)
[![GitHub Repo Stars](https://img.shields.io/github/stars/cssnr/mirror-repository-action?style=flat&logo=github)](https://github.com/cssnr/mirror-repository-action/stargazers)
[![GitHub Org Stars](https://img.shields.io/github/stars/cssnr?style=flat&logo=github&label=org%20stars)](https://cssnr.github.io/)
[![Discord](https://img.shields.io/discord/899171661457293343?logo=discord&logoColor=white&label=discord&color=7289da)](https://discord.gg/wXy6m2X8wY)
[![Ko-fi](https://img.shields.io/badge/Ko--fi-72a5f2?logo=kofi&label=support)](https://ko-fi.com/cssnr)

# Mirror Repository Action

- [Inputs](#Inputs)
- [Setup Instructions](#Setup-Instructions)
- [Example](#Example)
- [Tags](#Tags)
- [Support](#Support)
- [Contributing](#Contributing)

Mirror Git Repository to Remote Host.

## Inputs

| Input    | Required  | Default&nbsp;Value | Description&nbsp;of&nbsp;Input&nbsp;Value                |
| :------- | :-------: | :----------------- | :------------------------------------------------------- |
| url      | or `host` | -                  | \* Full URL to Mirror; Overrides: `host`/`owner`/`repo`  |
| host     | or `url`  | -                  | \* Full Host to Mirror; Example: `https://codeberg.org`  |
| owner    |     -     | Repo Owner         | \* Repository Owner of Mirror (if different from source) |
| repo     |     -     | Repo Name          | \* Repository Name of Mirror (if different from source)  |
| create   |     -     | `false`            | \* Set to `true` to attempt to Create the Mirror Repo    |
| username |     -     | Repo Owner         | Username for Authentication to Mirror                    |
| password |  **Yes**  | -                  | Token or Password for Authentication to Mirror           |
| summary  |     -     | `true`             | Add Job Summary. Set to `false` to Disable               |
| priavte  |     -     | Repo Private       | If the Mirror Repo Status is Different from Source       |

**url/host:** You must provide either a full repository `url` or a `host` value.  
Example: https://github.com/cssnr/mirror-repository-action

**owner/repo:** If different from source, you must specify these values (overridden by `url`).

**create:** Tested with codeberg but should also work with gitea/forgejo. Set to `true` to enable.

**summary:** Write a Summary for the job. To disable this set to `false`.

<details><summary>👀 View Example Job Summary</summary>

---

✅ Successfully Mirrored: `cssnr/mirror-repository-action`

- https://codeberg.org/cssnr/mirror-repository-action

<details><summary>Results</summary>

```text
remote:
remote: Create a new pull request for 'updates':
remote:   https://codeberg.org/cssnr/mirror-repository-action/compare/master...updates
remote:
To https://codeberg.org/cssnr/mirror-repository-action
   eaadc3f..da84f34  origin/updates -> updates
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

| Version&nbsp;Tag                                                                                                                                                                                                                 | Rolling | Bugs | Feat. |   Name    |  Target  | Example  |
| :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :-----: | :--: | :---: | :-------: | :------: | :------- |
| [![GitHub Tag Major](https://img.shields.io/github/v/tag/cssnr/mirror-repository-action?sort=semver&filter=!v*.*&style=for-the-badge&label=%20&color=44cc10)](https://github.com/cssnr/mirror-repository-action/releases/latest) |   ✅    |  ✅  |  ✅   | **Major** | `vN.x.x` | `vN`     |
| [![GitHub Tag Minor](https://img.shields.io/github/v/tag/cssnr/mirror-repository-action?sort=semver&filter=!v*.*.*&style=for-the-badge&label=%20&color=blue)](https://github.com/cssnr/mirror-repository-action/releases/latest) |   ✅    |  ✅  |  ❌   | **Minor** | `vN.N.x` | `vN.N`   |
| [![GitHub Release](https://img.shields.io/github/v/release/cssnr/mirror-repository-action?style=for-the-badge&label=%20&color=red)](https://github.com/cssnr/mirror-repository-action/releases/latest)                           |   ❌    |  ❌  |  ❌   | **Micro** | `vN.N.N` | `vN.N.N` |

You can view the release notes for each version on the [releases](https://github.com/cssnr/mirror-repository-action/releases) page.

The **Major** tag is recommended. It is the most up-to-date and always backwards compatible.
Breaking changes would result in a **Major** version bump. At a minimum you should use a **Minor** tag.

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

Please consider making a donation to support the development of this project
and [additional](https://cssnr.com/) open source projects.

[![Ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/cssnr)

If you would like to submit a PR, please review the [CONTRIBUTING.md](#contributing-ov-file).

Additionally, you can support other GitHub Actions I have published:

- [Stack Deploy Action](https://github.com/cssnr/stack-deploy-action?tab=readme-ov-file#readme)
- [Portainer Stack Deploy Action](https://github.com/cssnr/portainer-stack-deploy-action?tab=readme-ov-file#readme)
- [Docker Context Action](https://github.com/cssnr/docker-context-action?tab=readme-ov-file#readme)
- [VirusTotal Action](https://github.com/cssnr/virustotal-action?tab=readme-ov-file#readme)
- [Mirror Repository Action](https://github.com/cssnr/mirror-repository-action?tab=readme-ov-file#readme)
- [Update Version Tags Action](https://github.com/cssnr/update-version-tags-action?tab=readme-ov-file#readme)
- [Docker Tags Action](https://github.com/cssnr/docker-tags-action?tab=readme-ov-file#readme)
- [Update JSON Value Action](https://github.com/cssnr/update-json-value-action?tab=readme-ov-file#readme)
- [JSON Key Value Check Action](https://github.com/cssnr/json-key-value-check-action?tab=readme-ov-file#readme)
- [Parse Issue Form Action](https://github.com/cssnr/parse-issue-form-action?tab=readme-ov-file#readme)
- [Cloudflare Purge Cache Action](https://github.com/cssnr/cloudflare-purge-cache-action?tab=readme-ov-file#readme)
- [Mozilla Addon Update Action](https://github.com/cssnr/mozilla-addon-update-action?tab=readme-ov-file#readme)
- [Package Changelog Action](https://github.com/cssnr/package-changelog-action?tab=readme-ov-file#readme)
- [NPM Outdated Check Action](https://github.com/cssnr/npm-outdated-action?tab=readme-ov-file#readme)
- [Label Creator Action](https://github.com/cssnr/label-creator-action?tab=readme-ov-file#readme)
- [Algolia Crawler Action](https://github.com/cssnr/algolia-crawler-action?tab=readme-ov-file#readme)
- [Upload Release Action](https://github.com/cssnr/upload-release-action?tab=readme-ov-file#readme)
- [Check Build Action](https://github.com/cssnr/check-build-action?tab=readme-ov-file#readme)
- [Web Request Action](https://github.com/cssnr/web-request-action?tab=readme-ov-file#readme)
- [Get Commit Action](https://github.com/cssnr/get-commit-action?tab=readme-ov-file#readme)

<details><summary>❔ Unpublished Actions</summary>

These actions are not published on the Marketplace, but may be useful.

- [cssnr/draft-release-action](https://github.com/cssnr/draft-release-action?tab=readme-ov-file#readme) - Keep a draft release ready to publish.
- [cssnr/env-json-action](https://github.com/cssnr/env-json-action?tab=readme-ov-file#readme) - Convert env file to json or vice versa.
- [cssnr/push-artifacts-action](https://github.com/cssnr/push-artifacts-action?tab=readme-ov-file#readme) - Sync files to a remote host with rsync.
- [smashedr/update-release-notes-action](https://github.com/smashedr/update-release-notes-action?tab=readme-ov-file#readme) - Update release notes.
- [smashedr/combine-release-notes-action](https://github.com/smashedr/combine-release-notes-action?tab=readme-ov-file#readme) - Combine release notes.

---

</details>

<details><summary>📝 Template Actions</summary>

These are basic action templates that I use for creating new actions.

- [js-test-action](https://github.com/smashedr/js-test-action?tab=readme-ov-file#readme) - JavaScript
- [py-test-action](https://github.com/smashedr/py-test-action?tab=readme-ov-file#readme) - Python
- [ts-test-action](https://github.com/smashedr/ts-test-action?tab=readme-ov-file#readme) - TypeScript
- [docker-test-action](https://github.com/smashedr/docker-test-action?tab=readme-ov-file#readme) - Docker Image

Note: The `docker-test-action` builds, runs and pushes images to [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry).

---

</details>

For a full list of current projects visit: [https://cssnr.github.io/](https://cssnr.github.io/)
