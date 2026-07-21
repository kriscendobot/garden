---
gate: orchestrated
orchestrated_by: daemon-store-family-build
priority: normal
role: builder
posted_by: producer
posted_at: 2026-07-21T23:24:30Z
---

role: builder

# Build Phase 4: sorted variants and range queries (design Phase 4)

Repo: endojs/endo-but-for-bots. Implement **Phase 4** on top of the Phase 1-3
substrate: `SortedMapStore` and `SortedSetStore` with rank-ordered scans.

Concrete surface (see design § Two encoding roles, § Phased Phase 4):
- add the sorted kinds and `makeSortedMapStore` / `makeSortedSetStore`;
- `key_rank` column produced by `@endo/marshal` `makeEncodePassable` (the
  order-preserving rank encoding — keep it fixed; the body columns stay a free
  swap, see the design's Design Decision on body vs rank);
- the composite SQLite index on (store_number, key_rank);
- `keys(pattern, bounds)` / `values` / `entries` scans with inclusive/exclusive
  bounds, ordered by `key_rank`.

## Tests
arbitrary `M.key()` ordering; pattern covers; inclusive/exclusive bounds;
`O(log n + k)` query-plan use (assert the index is used, not a full scan); and
restart persistence for each sorted variant.

## Base / stacking (stacked-PR build)

Use skills/stacked-pr-build: because each phase depends on the code the prior
phase adds, do NOT branch off a bare `llm` for phases 2+. Branch off the PRIOR
phase's head branch so your worktree already contains its store substrate, and
open your DRAFT PR with that prior branch as the base (a stacked PR). Phase 1
branches off `llm`. If a prior phase has already merged to `llm` by the time you
start, rebase onto `llm` instead and base the PR on `llm`. Always
`git fetch` + rebase before you begin (skills/rebase-before-followup).

Open a DRAFT PR; the build auto-runs the gauntlet (clean -> panel -> fix-loop ->
un-draft). Keep the PR scoped to THIS phase only. Do NOT add an `@agoric/*`
dependency; reuse `@endo/patterns` / `@endo/exo` / the daemon's own marshal
substrate. Run `yarn lint` and the daemon package tests locally before pushing
(garden memory "Endo local test bin shims" for the PATH shims). If the design
proves insufficient for this phase, STOP and surface to the maintainer rather
than guessing — the orchestration halts on a child failure.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriskowal-garden-59
issue_url: https://github.com/kriskowal/garden/issues/59
submitter: dckc
----- END ISSUE NOTE -----

Design authority for the full detail and file:line grounding:
`packages/daemon/designs/daemon-persistent-stores.md` (merged from PR #809).
READ THE RELEVANT PHASE SECTION FIRST. When the PR is green and un-drafted,
comment the outcome (link the PR) on https://github.com/kriskowal/garden/issues/59.
