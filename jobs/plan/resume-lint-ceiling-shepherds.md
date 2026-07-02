---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/594
priority: high
posted_by: producer
posted_at: 2026-07-02T03:49:13Z
---

# Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService ceiling

**Repo:** `endojs/endo-but-for-bots` (bot-pushable; bot-repo work only, no upstream `endojs/endo` touch).

## Why this job exists (the trigger)

A typescript-eslint **project-service scaling ceiling** (one `eslint .` service must hold every
package's TS program; past a size threshold it tail-drops its alphabetically-last packages and
reports phantom `packages/zip/**` / `packages/where/**` "none of those TSConfigs include this file"
parsing errors) turned the CI `lint` check red on every large-enough bot PR. The CI-watcher
auto-dispatched a shepherd per red PR; none could go green (no shepherd-scope fix), so each failed
5× and the reaper **poisoned** it. This job consolidates every poisoned/blocked shepherd so none is
lost.

The fix landed as job `endo-but-for-bots-lint-projectservice-ceiling` (done) → **DRAFT PR #594**
`chore/lint-eslint-per-package-batches`: a batched `scripts/eslint-repo.sh` that lints one package
per process, so the whole-repo ceiling can never be reached. Its CI `lint` is green.

This plan is `gate: blocked, blocked_on: <PR #594>`. `garden-unblock` promotes it to `todo/` when
#594 resolves — that is the "infra cleared" trigger.

## Guard before acting

Confirm **#594 actually MERGED to master** (the `scripts/eslint-repo.sh` lint fix is on master).
`unblock.sh` promotes on merge **or close**, so if #594 was **closed without merging**, the ceiling
is NOT fixed: do **not** resume — post a maintainer-inbox note and re-park this plan (or drop it).

## Action once unblocked (and #594 confirmed merged)

For each PR below, dispatch a **shepherd** (`post-job.sh <base>` per PR, so the fleet parallelizes)
to **rebase the PR on the now-fixed master and drive CI to green**. With the ceiling gone, `lint`
should pass on rebase; the shepherd handles any other still-red checks and re-escalates only if a
genuinely different, out-of-shepherd-scope failure remains. Each shepherd re-fetches live PR state,
so any PR that has since merged/closed is a fast no-op — safe to include.

## Scope narrowed 2026-07-02: this plan now covers the `master` + feature-branch subset only

The **15 `llm`-based** PRs were split out to **`resume-lint-ceiling-shepherds-llm`** (blocked on the
`llm` fix job `ebfb-594-fresh-llm-pr-merge`), per the maintainer's "llm now, master after the
decision" directive: the `llm` branch gets its lint fix immediately, so those resume without waiting
on `master`. This plan retains only the PRs that genuinely wait on the `master` lint landing.

Note the `master` fix is **not guaranteed to be #594 as-is**: its final form is under an
evidence-based decision (bucket vs. shard) in job `ebfb-lint-master-strategy-evidence`, which will
land the fix on `master` (possibly via a different PR). The guard above still holds: if #594 is
closed in favor of that other PR, `unblock` fires on the close, so re-check that `master` actually
lints clean before resuming; otherwise re-park.

## `master`-based PRs to resume (9; open as of 2026-07-02)

#60 #79 #96 #235 #250 #337 #377 #438 #475

(Bases: live `master`, or `master-<sha>` frozen snapshots for #79/#96/#377/#438 — the shepherd
rebases onto live fixed `master`.)

## Feature-branch-stacked PRs (5; need their base branch fixed first — do NOT plain-rebase)

#393 #410 #420 (base `design/gateway-package-phase-*`) #541 (base `build/sturdyrefs-pass-style-ocapn`)
#591 (base `refactor/inter-package-far-repoint-deprecate`)

These are stacked on feature branches, not `master`/`llm` directly, so a rebase onto fixed `master`
is wrong — their `lint` clears only once **their own base branch carries the fix** (merge-forward the
fixed `master`/`llm` into the feature branch, or the stack is re-based when its parent PR merges).
When resuming, shepherd these only after confirming their base branch lints clean; otherwise leave
parked and note the base dependency.

## Provenance

Consolidated by the liaison (leader, endolinbot) on 2026-07-02 from the maintainer-inbox reaper
POISON reports for `endojs-endo-but-for-bots-pr<N>-shepherd` jobs, cross-checked against the live
open-PR set. Source fix: `endo-but-for-bots-lint-projectservice-ceiling` (tada) + DRAFT PR #594.
