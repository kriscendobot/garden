---
section: three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint
source: endo-but-for-bots--llm-designs-ci-no-npm-lifecycle
topics: [tooling, repository-governance, security-disclosure]
status: current
title: The §two-layer enforcement
parent: endo-but-for-bots--llm-designs-ci-no-npm-lifecycle--three-layer-auditable-lifecycle-script-defense-with-belt-and-suspenders-env-and-CI-lint
---

> *Two complementary checks keep the posture from rotting.*

**Layer 1: §repository-level-lint**:

`scripts/check-no-ci-lifecycle.mjs` (new) scans
`.github/workflows/*.yml` and fails if:

- Any step runs `yarn install` / `yarn` / `npm install` /
  `npm i` / `npm ci` *without* either `--ignore-scripts` or
  the env block.
- Any step runs `yarn publish` / `npm publish` / `lerna
  publish` *outside* an allowlisted release-workflow job.
- The checked-in `.yarnrc.yml` no longer contains
  `enableScripts: false`.

§Runs-as-CI-job-gated-on-relevant-paths: the lint runs only
when `.github/`, `.yarnrc.yml`, `.yarnrc`, or `package.json`
changes. Same shape as the existing `check-action-pins` job.

**Layer 2: §positive-tripwire** via `@lavamoat/preinstall-always-fail`:

> *If any workflow accidentally enables scripts globally,
> this package's `preinstall` fires first and fails the
> install with an obvious error message, rather than letting
> a silent supply-chain script run.*

The §canary-package-fails-loud discipline: a package
*designed to fail* sits at the front of the dependency tree;
if scripts run at all, *its* script runs first and aborts the
install with a visible error. Catches the policy regression
at install time, not after the malicious payload runs.

The §two-layer-enforcement architecture: lint catches policy
violations at PR-review time; tripwire catches them at
install time. Both fail loud.
