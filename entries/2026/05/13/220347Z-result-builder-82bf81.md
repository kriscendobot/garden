---
ts: 2026-05-13T22:03:47Z
kind: result
role: builder
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 240
    role: opened
refs:
  - entries/2026/05/13/215426Z-message-steward-5fd29d.md
---

# Builder: amend #121 turbo config to use `^build` (#240)

Dispatched per kriskowal's post-merge inline comment on #121 (2026-05-13T21:53:57Z): amend the turbo configuration on the premise that devDependency cycles have been obviated by #206's per-cut PRs, so the task graph can express build-before-transitively-dependent-tests.

## What landed

Draft PR endojs/endo-but-for-bots#240, against the upstream `llm` branch.

Diff: 2 files changed.

- `turbo.json`: `build` gains `dependsOn: ["^build"]`, `test` becomes `dependsOn: ["build", "^build"]`. `lint` keeps `dependsOn: ["build"]` (lint runs per package and does not consume upstream build artifacts; the cascade still reaches it transitively).
- `turbo.json.md`: rewritten to describe the post-cycle-break configuration, why `^build` is now the right shape, why `lint` stays on the in-package form, and how the change affects cache invalidation under a future remote cache.

## Local validation

`yarn turbo run test --dry=json` on `feat/turbo-test-depends-on-build`: exits non-zero with `Cyclic dependency detected` listing the remaining 12-package SCC (still includes `@endo/harden`, `@endo/promise-kit`, `@endo/lockdown`, `@endo/init`, `@endo/ses-ava`, `@endo/module-source`, `@endo/test262-runner`, `ses`, `@endo/eventual-send`, `@endo/hex`, `@endo/evasive-transform`, `@endo/compartment-mapper`).

The maintainer's premise (cycles obviated) is not yet true on `llm`. Cuts 2 (#211) and 3 (#209) of #206 have merged; Cut 4 (#210, harden) is open; Cut 1 (SES test scaffold) is unstarted. The PR is correct as a steady-state configuration but cannot pass CI until the remaining cuts land. PR body states this explicitly so the maintainer sees CI red as expected and not as a regression.

## Pre-flight

- `gh pr list --state all --search "turbo dependsOn ^build"`: no duplicate.
- Identity: kriscendobot, per pre-staged direct-push authorization for endo-but-for-bots and post-merge comment authorization on #121. PR opened directly against `llm` (no boatman), in draft per pr-creation-flow.
- Branch name: `feat/turbo-test-depends-on-build`.
- Commit author: `Kriscendo Bot <noreply@anthropic.com>` (matches the recent #121 review-fix commits).

## Hand-off

Per `pr-creation-flow`: this is the builder's hand-off. Next dispatches (assayer, jury, fixer, cleaner) are the orchestrator's call. Note that the PR depends on #210 (and Cut 1's eventual PR) for CI to converge; opening the jury before those land would be wasted work, since the jury's task graph reads the same cycle error the builder hit.

Self-improvement: the dispatch brief said to "amend the configuration on the assumption that we have obviated all devDependencies" but the brief's `b21f63b` reference was to the merge commit, which means the assumption was forward-looking. A future builder dispatched on a premise that depends on unlanded sister PRs benefits from the brief naming each prerequisite PR explicitly (#210 here; Cut 1 SES-test-scaffold not yet opened); the builder then knows whether to wait, surface the impasse, or proceed-with-caveat. This dispatch chose proceed-with-caveat because the directive was specific and the PR body can document the dependency, but the choice would have been faster to make if the brief had enumerated the prerequisites.
