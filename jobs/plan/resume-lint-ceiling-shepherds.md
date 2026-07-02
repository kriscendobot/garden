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

## Blocked PRs to resume (29; still-open as of 2026-07-02, consolidated from reaper POISON reports)

#60 #79 #96 #101 #235 #242 #250 #301 #306 #313 #316 #318 #320 #324 #335 #337 #377 #393 #410 #420 #438 #475 #541 #581 #585 #590 #591 #592 #593

(#590 and #581 are the two the fix report explicitly expects to go green on rebase; #592 is the PR
whose shepherd escalated the ceiling to the liaison rather than poisoning.)

## Provenance

Consolidated by the liaison (leader, endolinbot) on 2026-07-02 from the maintainer-inbox reaper
POISON reports for `endojs-endo-but-for-bots-pr<N>-shepherd` jobs, cross-checked against the live
open-PR set. Source fix: `endo-but-for-bots-lint-projectservice-ceiling` (tada) + DRAFT PR #594.
