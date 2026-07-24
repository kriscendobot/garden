from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-07-22T06:03:12Z
poison_base: daemon-store-phase4-sorted
poison_signature: deadline-overrun
notice_count: 1
first_seen: 2026-07-22T06:03:12Z
last_seen: 2026-07-22T06:03:12Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 DEADLINE-OVERRUN cycles on endolin-garden2-5bcdff64.
Its handler hit its OWN wall-clock budget every cycle (rc=124, elapsed≈GARDEN_HANDLER_TIMEOUT=2400s):
this job EXCEEDS THE HANDLER BUDGET and would be killed identically on every requeue,
so the reaper surfaced it after 1 overrun cycles (not the full 5-cycle poison threshold).
The work is preserved at jobs/plan/daemon-store-phase4-sorted; it stays HELD until a human promotes it
(promote-plan.sh daemon-store-phase4-sorted) or removes it. Triage: split the job, raise GARDEN_HANDLER_TIMEOUT
for this work, or fix what makes it run long.
Original job base: daemon-store-phase4-sorted

--- original job body ---
---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-22T05:07:03Z -->

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

<!-- garden-deadline-overrun: 1 -->
