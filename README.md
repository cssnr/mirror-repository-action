[![Tags](https://img.shields.io/github/actions/workflow/status/cssnr/mirror-repository-action/tags.yaml?logo=github&logoColor=white&label=tags)](https://github.com/cssnr/mirror-repository-action/actions/workflows/tags.yaml)
[![Test](https://img.shields.io/github/actions/workflow/status/cssnr/mirror-repository-action/test.yaml?logo=github&logoColor=white&label=test)](https://github.com/cssnr/mirror-repository-action/actions/workflows/test.yaml)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=cssnr_mirror-repository-action&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=cssnr_mirror-repository-action)
[![GitHub Release Version](https://img.shields.io/github/v/release/cssnr/mirror-repository-action?logo=github)](https://github.com/cssnr/mirror-repository-action/releases/latest)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/cssnr/mirror-repository-action?logo=github&logoColor=white&label=updated)](https://github.com/cssnr/mirror-repository-action/graphs/commit-activity)
[![Codeberg Last Commit](https://img.shields.io/gitea/last-commit/cssnr/mirror-repository-action/master?gitea_url=https%3A%2F%2Fcodeberg.org%2F&logo=codeberg&logoColor=white&label=updated)](https://codeberg.org/cssnr/mirror-repository-action)
[![GitHub Top Language](https://img.shields.io/github/languages/top/cssnr/mirror-repository-action?logo=htmx&logoColor=white)](https://github.com/cssnr/mirror-repository-action)
[![GitHub Org Stars](https://img.shields.io/github/stars/cssnr?style=flat&logo=github&logoColor=white)](https://cssnr.github.io/)
[![Discord](https://img.shields.io/discord/899171661457293343?logo=discord&logoColor=white&label=discord&color=7289da)](https://discord.gg/wXy6m2X8wY)

# Mirror Repository Action

Mirror Git Repository to Remote Host.

- [Inputs](#Inputs)
- [Support](#Support)
- [Contributing](#Contributing)
- [Development](#Development)

## Inputs

| input    | required      | default    | description                                              |
| -------- | ------------- | ---------- | -------------------------------------------------------- |
| url      | Not w/ `host` | -          | \* Full URL to Mirror, overrides: `host`/`owner`/`repo`  |
| host     | Not w/ `url`  | -          | \* Full Host to Mirror, example: `https://codeberg.org`  |
| owner    | No            | Repo Owner | \* Repository Owner of Mirror (if different from source) |
| repo     | No            | Repo Name  | \* Repository Name of Mirror (if different from source)  |
| create   | No            | -          | \* Set to `true` to attempt to Create the Mirror Repo    |
| username | No            | Repo Owner | Username for Authentication to Mirror                    |
| password | Yes           | -          | Token or Password for Authentication to Mirror           |

**url/host** - You must provide either a full repository `url` or a `host` value.

**owner/repo** - If different from source, you must specify these values.

**create** - Tested with codeberg but should also work with gitea/forgejo. Do not set or leave empty to disable.

1. Create a Token for Mirror to use as a Password for Pushing Commits, or Creating Repositories.

   - Codeberg/Gitea/Forgejo go here: https://codeberg.org/user/settings/applications
   - Select Permissions: `write:organization` `write:repository` `write:user`

2. Create Remote Repository to Mirror, or set `create` to `true`, for example: `https://codeberg.org`

3. Go to the settings for your source repository on GitHub and add the `CODEBERG_TOKEN` secret.

   - For organizations, you can add the token one time at the Organization level.

4. Add the following file to source repository on GitHub: `.github/workflows/mirror.yaml`

   - The `owner` is automatically set to the GitHub Organization or Username if personal. Set to override.
   - The `repo` is automatically set to the GitHub Repository Name. This should only be set to rename repo.
   - For Codeberg, use the `host` below and set the `username` to your Codeberg username.

The below yaml is available in this file: [.github/workflows/mirror.yaml](mirror.yaml)

```yaml
name: 'Mirror'

on:
  workflow_dispatch:
  release:
    types: ['published']
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

# Support

For general help or to request a feature, see:

- Q&A Discussion: https://github.com/cssnr/mirror-repository-action/discussions/categories/q-a
- Request a Feature: https://github.com/cssnr/mirror-repository-action/discussions/categories/feature-requests

If you are experiencing an issue/bug or getting unexpected results, you can:

- Report an Issue: https://github.com/cssnr/mirror-repository-action/issues
- Chat with us on Discord: https://discord.gg/wXy6m2X8wY
- Provide General
  Feedback: [https://cssnr.github.io/feedback/](https://cssnr.github.io/feedback/?app=Mirror%20Artifacts%20Action)

# Contributing

Currently, the best way to contribute to this project is to star this project on GitHub.

Additionally, you can support other GitHub Actions I have published:

- [VirusTotal Action](https://github.com/cssnr/virustotal-action)
- [Update Version Tags Action](https://github.com/cssnr/update-version-tags-action)
- [Update JSON Value Action](https://github.com/cssnr/update-json-value-action)
- [Parse Issue Form Action](https://github.com/cssnr/parse-issue-form-action)
- [Mirror Repository Action](https://github.com/cssnr/mirror-repository-action)
- [Stack Deploy Action](https://github.com/cssnr/stack-deploy-action)
- [Portainer Stack Deploy](https://github.com/cssnr/portainer-stack-deploy-action)
- [Mozilla Addon Update Action](https://github.com/cssnr/mozilla-addon-update-action)

For a full list of current projects to support visit: [https://cssnr.github.io/](https://cssnr.github.io/)

# Development

1. Install `act`: https://nektosact.com/installation/index.html
2. List Workflows: `act -l`
3. Run a Workflow: `act -j test`

If you need files from .gitignore use: `--use-gitignore=false`

For advanced using with things like secrets, variables and context see: https://nektosact.com/usage/index.html

You should also review the options from `act --help`

Note, the `.env`, `.secrets` and `.vars` files are automatically sourced with no extra options.
To source `event.json` you need to run act with `act -e event.json`
