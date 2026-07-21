---
gate: orchestrated
orchestrated_by: daemon-store-family-build
priority: normal
role: builder
posted_by: producer
posted_at: 2026-07-21T23:24:18Z
---

role: builder

# Build Phase 2: durable strong SetStore in the endo pet daemon (design Phase 2)

Repo: endojs/endo-but-for-bots. Implement **Phase 2** of the persistent-stores
design on top of the Phase 1 MapStore substrate: a durable, incrementally-mutable
`SetStore`. Reuse the proven strong-entry table/codec/retention accounting from
Phase 1.

Concrete surface (see design § Interface, § Phased Implementation Phase 2):
- add `kind: 'set'` to the collection-store formula/record;
- `makeSetStore(petName)` on the guest/host interfaces;
- the `add(key)` / `has` / `delete` / `getSize` / `keys` / `entries` surface
  (entry == the key), and `snapshot()` -> a passable `CopySet`;
- write-through to SQLite on every mutation; keys serialized with the daemon's
  marshal body+slots so remotable keys join the retention graph.

## Tests
add/has/delete/getSize/keys/entries semantics incl. throw-conditions; CapTP
round-trip of a remotable key; CopySet snapshot; and **restart persistence**
(create set -> add entries -> restart daemon -> membership intact).

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
