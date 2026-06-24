---
ts: 2026-05-20T06:40:13Z
kind: result
role: builder
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/builder--39f3fc/project
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/231
---

Wired the Familiar Release workflow into routine CI per `designs/familiar-release.md` G1 (the MVR's first line item: "Wire the existing build pipeline into a CI workflow that emits per-platform artifacts").

PR: https://github.com/endojs/endo-but-for-bots/pull/318 (DRAFT, base `llm`, head `feat/familiar-ci-build-pipeline`, commit `1467909d0`).

Single-file change. The existing `.github/workflows/familiar-release.yml` already carried the three-target make matrix (macos-14 arm64, macos-13 x64, ubuntu-latest linux-x64) and the bundle / chat / package / make pipeline; the gap was that the workflow only fired on `workflow_dispatch` and on `familiar-v*` tag push, so it had never run (zero historical runs verified via the workflow's runs API). The maintainer had no per-platform artifact set to pull down for smoke testing without first cutting a tag or invoking dispatch by hand.

Changes to the trigger and concurrency surface:

- Added `pull_request` trigger, path-filtered to `packages/{familiar,daemon,chat,lal,fae}/**` plus the workflow file itself.
- Added `push` trigger to `llm` and `master` with the same path filter (preserving the existing `familiar-v*` tag trigger).
- Added a `concurrency` group keyed on workflow + ref with `cancel-in-progress: true` (the matrix is the longest-running CI surface in this repo and rapid pushes would otherwise queue up redundant macos-14 / macos-13 / ubuntu-latest runs).
- Added `fail-fast: false` on the make matrix so a single-platform failure still leaves a partial artifact set for smoke testing.
- Added inline comments on the `release` job's `if:` documenting that pull-request and branch-push runs cannot accidentally publish a draft GitHub Release (the gate requires either a `familiar-v*` tag or a `workflow_dispatch` with an explicit version input).

What the artifacts look like. Each triggered run uploads three workflow-artifact entries downloadable from the run's Artifacts panel:

- `familiar-darwin-arm64` (the macos-14 runner's `packages/familiar/out/make/` output, a `.dmg` plus a `.zip` of the `.app`).
- `familiar-darwin-x64` (the macos-13 runner's `out/make/`, same shape).
- `familiar-linux-x64` (the ubuntu-latest runner's `out/make/`, a `.zip` of the Linux ELF tree).

Two ancillary artifacts (`chat-dist`, `bundles`) from the `build-artifacts` job also appear in the Artifacts panel; these are intermediate inputs to the make matrix and are uploaded by the existing pipeline shape.

Preserved as-is. The Node `v20.18.1` pin in the download step (separate G5 followup advances it to a current LTS); the `actions/setup-node`, `actions/upload-artifact`, `actions/download-artifact`, `softprops/action-gh-release`, `actions/checkout` SHAs; the Apple-side runner choices (macos-14 for arm64, macos-13 for x64). The npm-lifecycle-script defense (`YARN_ENABLE_SCRIPTS=false`, `npm_config_ignore_scripts=true`) was already at the workflow `env` level and was not touched.

Branch base. Dispatched onto `llm`, honored. The standing builder norm prefers `master`-base for implementation PRs whose design lives on `llm`, but `packages/familiar/` itself only exists on `llm` (the most recent reference PR for this package, #214, also based on `llm` and merged into `llm`), so for this package the master-base norm does not apply and the dispatch's explicit `llm` base is the right shape.

Pre-flight no-duplicate. `gh pr list --search "familiar-ci-build"` and `gh pr list --search "familiar-release"` returned only the design PR (#231) and unrelated dependency / fix PRs; no existing PR implements this G1 line item.

Pre-push gates. Ran via `garden/skills/pre-push-gates/pre-push-gates.sh --summary` after `yarn install --immutable`. The driver's auto-fix stages (`yarn format`, `yarn lint --fix`) made changes to several unrelated files across the monorepo (existing baseline drift in `packages/daemon/`, `packages/ses/`, `packages/evasive-transform/`, `packages/hex-test/`); I reset those before commit so the staged diff is strictly the workflow file. Probe results on the diff-scoped re-run: `no-inline-import-jsdoc`, `no-pull-citations`, `no-ascii-banners`, `filename-no-stutter`, `sentence-per-line-md`, `test-package-no-main` all pass; `security-md-hash-uniform` fails on pre-existing tree state (`packages/endo/` exists as a `mitm/node` subpath only and is missing a `SECURITY.md`, unrelated to this diff). `yarn typecheck` was skipped (no root `typecheck` script).

PR body. Used the upstream `.github/PULL_REQUEST_TEMPLATE.md` from `llm`, all section headings preserved verbatim. Refs #229 and #231 (no Closes, since the design has nine MVR items and this PR closes only the first). No checklists; no file-by-file callouts.

Cross-cutting observation. The pre-push-gate's auto-fix-on-unrelated-paths shape (already noted by the two preceding builder results today, `053040Z-result-builder-42023a.md` and `060600Z-result-builder-a41b0d.md`) reproduced for me on a workflow-only diff: a YAML-only PR triggered `yarn format` and `yarn lint --fix` to mutate JS files across the monorepo. This is the third independent observation today; the lesson (scope auto-fix re-staging to packages touched by the diff) is now well-supported. Routing this as a `message` to gardener below rather than as a self-improvement, since the fix is in the gate skill rather than my role file.

Self-improvement: nothing this time on the builder role itself. The cross-cutting observation about `pre-push-gates` auto-fix scope is routed via a separate `message` to the gardener.
