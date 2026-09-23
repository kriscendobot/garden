All work is complete and verified. Here is my completion report.

---

## Build Phase 1: durable strong `MapStore` in the endo pet daemon (kriskowal/garden#59)

**Draft PR: https://github.com/endojs/endo-but-for-bots/pull/819** (base `llm`, 2 commits, 11 files, +936).

### What I did
Implemented Phase 1 of the persistent-stores design: a durable, incrementally-mutable `MapStore` that a guest/host creates by pet name and that survives a daemon restart, mirroring the `@agoric/store` `MapStore` surface over the daemon's own formula + SQLite substrate. No `@agoric/*` dependency.

- **`collection-store` formula type** (`{ type, kind: 'map' }`) + inspector record (`formula-type.js`, `formula-record.js`, `types.d.ts`).
- **`collection_store_entry` table** + row ops in `manager-database.js`, exposed via `manager-persistence-powers.js`, following the `pet_store_entry`/`synced_store_entry` precedent. Each entry carries the key's canonical `makeEncodePassable` rank encoding (primary key) plus marshal body+slots for key and value.
- **`src/collection-store.js`** — the new M-guarded `MapStore` exo, write-through to SQLite on every mutation, reconstructing keys/values via the daemon's marshal codec.
- **Retention** — each entry's local remotable slots are retained through the pet-store edge hooks with per-slot refcounting; edges are seeded from persistence at startup **before the unreachable sweep** so a stored remotable survives a restart; entry rows are dropped when the store formula is collected.
- **`makeMapStore(petName)`** on the guest and host interfaces (`guest.js`, `host.js`, `interfaces.js`), plus `formulateCollectionStore` dispatch in `manager.js`.
- Keys land **scalar-first (commit 1), then broadened to full `M.key()` (commit 2)** — the design's within-phase follow-on, staged as the two commits.

### Verification (real execution)
- `tsc` (lint:types): **exit 0, clean**.
- `eslint .` on the daemon package: **0 errors** (489 pre-existing warnings, baseline).
- **9 MapStore ava tests pass** (`test/endo.test.js`): semantics + all throw-conditions; multiple scalar key types; structured `M.key()` record/array keys with by-value equality; **CapTP round-trip of a remotable value**; **entry persistence across a real daemon restart**; and **remotable-value + nested-remotable-key retention across a restart**.
- Regression check: `formula-type` / `formula-record` / `graph` / `graph-refcount` / `store-controller` suites — **40 pass**.
- The long worktree path pushes the daemon's AF_UNIX socket past the 104-char limit, so the daemon-boot tests were run with the sock base temporarily relocated to a short path (an uncommitted local edit, reverted — confirmed absent from the committed diff).

### Notable decision (surfacing per "STOP and surface rather than guess")
The job body's "concrete surface" named a `map-store` formula type / `map_store_entry` table / `makeIdentifiedMapStore`. The **design authority** (which the job explicitly named and told me to read first) instead specifies a single **`collection-store`** formula discriminated by `kind`, with a `collection_store_entry` table and `makeIdentifiedCollectionStore` — so Phases 2–4 (set, weak, sorted) slot onto the same substrate rather than minting a formula type per kind. I followed the design. This is a deliberate divergence from the job body's wording, not a guess; it's the design-conformant reading and reduces future churn. Not a blocker requiring a halt, so I proceeded.

### Follow-ups
- The PR is **draft**; the build auto-runs the gauntlet (clean → panel → fix-loop → un-draft). Per the job, the outcome comment on kriskowal/garden#59 is deferred until the PR is green and un-drafted, so I did **not** comment on the issue yet.
- Phases 2–6 (SetStore, weak variants + ERTP integration test, sorted variants + range queries, parity polish, CLI/WUI) remain per the design's phased plan.
