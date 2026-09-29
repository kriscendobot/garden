---
tier: mentat
dispatch: manual
---
# Refresh, resolve, and (if warranted) conduct endojs/endo-but-for-bots#1356

You have full authority for this PR's outcome — refresh it, decide its
resolution, run whatever gauntlet stages make sense given that resolution,
and conduct (merge) it yourself once everything passes. Report back what you
did and why; no further check-in is required before merging.

## Context

PR: https://github.com/endojs/endo-but-for-bots/pull/1356 ("feat(ses): tame
and permit URL and URLSearchParams"), draft, base `master-6ee3fda`,
currently MERGEABLE.

This PR was flagged as overtaken by upstream `endo#3332`, which landed a URL/
URLSearchParams shim directly on `master`. **In parallel**, a separate job
(`endojs-endo-but-for-bots-sync-llm-master-20260929`) is merging current
`master` into `llm` to reconcile that same drift generally — it may complete
before or after you start. Check its outcome
(`jobs/tada/endojs-endo-but-for-bots-sync-llm-master-20260929`, once it
exists) and/or the current state of `master`/`llm` directly rather than
assuming either ordering.

## What "resolve" means here — decide, don't just rebase

1. Compare this PR's diff against what `endo#3332` actually shipped upstream
   (and whatever landed in `llm` via the sync merge, if that's already done).
2. If upstream's version fully subsumes this PR's contribution: close #1356
   as superseded, with a comment naming the subsuming commit/PR, and update
   the M2 roadmap tracking this referenced (`journal2` foreman milestone
   note) accordingly — no further gauntlet needed for a closed PR.
3. If this PR still carries something upstream's version lacks (a behavior,
   a test, an edge case): refresh it — rebase onto the current frozen base
   (or a fresh one, per `skills/frozen-base-branch/SKILL.md`, if `master` has
   moved meaningfully) — reducing the diff to just that residual
   contribution, then run it through the gauntlet
   (`skills/pr-creation-flow/SKILL.md`) to the extent a residual diff of that
   shape warrants (a trivial residual may not need the full code panel; use
   judgment and say so in your report), and merge once it passes.

Either outcome is an acceptable "resolution" — the maintainer's ask is that
this stops sitting stale and duplicated, not that it specifically merges.
