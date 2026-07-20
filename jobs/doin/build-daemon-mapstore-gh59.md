role: builder

# Build Phase 1: durable MapStore in the endo pet daemon (closes kriskowal/garden#59)

Repo: endojs/endo-but-for-bots (branch `llm`).
Design: `packages/daemon/designs/daemon-persistent-stores.md` (design PR
https://github.com/endojs/endo-but-for-bots/pull/809). READ IT FIRST — it
grounds every path and decision below in the actual daemon source.

## Task

Implement **Phase 1** of that design: a durable, incrementally-mutable
`MapStore` (scalar keys) that a guest/host can create by pet name and that
survives a daemon restart. This is what the issue asks for ("if not, make a
design and build it"). Mirror the `@agoric/store` `MapStore` API
(init/set/get/delete/has/getSize/keys/values/entries/snapshot) over the
daemon's native formula + SQLite durability substrate — do NOT add an
`@agoric/*` dependency. Reuse `@endo/patterns` and `@endo/exo`.

Concrete surface (see the design for detail and file:line grounding):
- add `map-store` to `packages/daemon/src/formula-type.js` and a record schema
  in `formula-record.js`;
- add a `map_store_entry(store_number, key_body, key_slots, value_body,
  value_slots)` table in `manager-database.js`, following how `pet_store_entry`
  / `synced_store_entry` were added;
- new `packages/daemon/src/map-store.js` exo (M-guarded `MapStore` interface),
  write-through to SQLite on every mutation; serialize keys/values with the
  daemon's existing marshal body+slots encoding so remotable entries join the
  retention graph (see `src/store-controller.js`);
- dispatch `map-store` → `makeIdentifiedMapStore` in `manager.js`;
- expose `makeMapStore(petName)` on the guest and host interfaces
  (`src/interfaces.js`), alongside `makeDirectory` / `storeValue`.

## Tests (the deliverable the issue wants to SEE)

Add tests demonstrating: init/set/get/delete/has/getSize/keys/values/entries/
snapshot semantics including throw-conditions; CapTP round-trip of a remotable
value; and **restart persistence** (create store → set entries → restart the
daemon → entries still present). `test/endo.test.js` is the established home for
restart-survival tests. Run `yarn lint` and the daemon package tests locally
(see garden memory "Endo local test bin shims" for the PATH shims needed).

Open a DRAFT PR against `llm`; the build auto-runs the gauntlet (clean → panel →
fix-loop → un-draft). Keep the PR scoped to Phase 1 only. When the PR is green
and un-drafted, comment the outcome back on the issue below (link the PR).

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriskowal-garden-59
issue_url: https://github.com/kriskowal/garden/issues/59
submitter: dckc
----- END ISSUE NOTE -----

Reply on the issue when done:
  gh issue comment https://github.com/kriskowal/garden/issues/59 --body "…"

<!-- garden-deadline-overrun: 1 -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 13
  worker_kind: gardener
  claimed_at: 2026-07-20T20:00:08Z
