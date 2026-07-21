---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-21T23:25:03Z -->

role: builder

# Build Phase 1: durable strong MapStore in the endo pet daemon (closes kriskowal/garden#59)

Repo: endojs/endo-but-for-bots. Implement **Phase 1** of the persistent-stores
design: a durable, incrementally-mutable `MapStore` (scalar `M.scalar()` keys)
that a guest/host creates by pet name and that survives a daemon restart. Mirror
the `@agoric/store` `MapStore` API (init/set/get/delete/has/getSize/keys/values/
entries/snapshot) over the daemon's native formula + SQLite durability substrate.

Concrete surface (see design § Storage model, § Interface):
- add `map-store` to `packages/daemon/src/formula-type.js` and a record schema in
  `formula-record.js`;
- add a `map_store_entry(store_number, key_body, key_slots, value_body,
  value_slots)` table in `manager-database.js`, following how `pet_store_entry` /
  `synced_store_entry` were added;
- new `packages/daemon/src/map-store.js` exo (M-guarded `MapStore` interface),
  write-through to SQLite on every mutation; serialize keys/values with the
  daemon's existing marshal body+slots encoding so remotable entries join the
  retention graph (see `src/store-controller.js`);
- dispatch `map-store` -> `makeIdentifiedMapStore` in `manager.js`;
- expose `makeMapStore(petName)` on the guest and host interfaces
  (`src/interfaces.js`), alongside `makeDirectory` / `storeValue`.
As the design's Phase 1 says, land scalar keys first, then in a follow-on change
within this phase broaden the same map to full `M.key()` keys (nested remotables)
with its own restart-persistence coverage.

## Tests (the deliverable #59 wants to SEE)
init/set/get/delete/has/getSize/keys/values/entries/snapshot semantics incl.
throw-conditions; CapTP round-trip of a remotable value; and **restart
persistence** (create store -> set entries -> restart daemon -> entries present).
`test/endo.test.js` is the established home for restart-survival tests.

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

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 12
  worker_kind: gardener
  claimed_at: 2026-07-21T23:25:07Z
