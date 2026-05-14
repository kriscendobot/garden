---
title: Initial setup
source: CONTRIBUTING.md
source_repo: endojs/endo
source_commit: 6ad084a6900b
source_date: 2026-01-08
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [repository-governance, tooling]
status: current
---

> Abstract: Node.js + yarn install, dependency installation, the initial build. Includes a sub-section on action pinning (GitHub Actions versions are pinned by SHA for supply-chain safety; how to update or add pinned actions).

## Initial setup

```sh
git clone git@github.com:endojs/endo.git
cd endo
yarn
```

Endo is a yarn workspaces repository. Running yarn in the root will install and
hoist most dependencies up to the root `node_modules`.

Note: running yarn `--ignore-scripts` will not complete the setup of SES.
Note: Endo uses `lerna` only for releasing. `lerna bootstrap` is unlikely to work.

### Action pinning

GitHub Actions are pinned to commit SHAs.
Run `node scripts/update-action-pins.mjs` to refresh patch/minor pins.
Run `node scripts/update-action-pins.mjs --major` for major upgrades.
Use `--min-age-days 0` to bypass the default 5-day age gate (for zero-day fixes).
The updater reads the `# vX` comment on each `uses:` line.
If no version comment exists, it infers the latest tag for that action.

CI enforces pinning with `node scripts/update-action-pins.mjs --check-pins`.
If this check fails, run the updater and commit the resulting changes.


Source: [CONTRIBUTING.md](https://github.com/endojs/endo/blob/6ad084a6900b/CONTRIBUTING.md) at commit `6ad084a6`.
