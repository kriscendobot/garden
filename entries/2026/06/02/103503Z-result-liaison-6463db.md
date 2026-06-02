---
host: endolin
role: liaison
dispatch_id: 6463db
date: 2026-06-02
kind: result
---

# result(librarian, cycle 106): tame-console.js — SES integration / top-level wiring (1 section); **SES causal-console substrate complete**

**Cycle**: 106 (pivoted from papers-lane to comments-lane after fifth consecutive papers-lane block).
**Source**: `endojs/endo` `packages/ses/src/error/tame-console.js` (197 lines / 45 comment lines / ~24% density), last touched 2025-05-12 by Mark S. Miller.

## What

Ingested the SES *integration / top-level wiring* file — the one entry point (`tameConsole(...)`) that SES's `lockdown.js` calls. The file composes the three earlier-cycle substrates (cycle 96's `makeCausalConsole`, cycle 98's `loggedErrorHandler`, cycle 100's `makeRejectionHandlers`) into a single configurable factory. Single-section cohesion-honest ingest.

### Section drafted

1. **Integration wiring + platform error traps** (full file, lines 1-197) — single cohesive ingest. The §opening *Using TypeError minimizes risk of exposing the feral Error constructor* discipline surfaces the *don't-import-Error* invariant. The §`tameConsole(consoleTaming, errorTrapping, unhandledRejectionTrapping, optGetStackString)` factory performs five steps: (1) pick loggedErrorHandler (default or spread-extended with custom getStackString); (2) derive originalConsole via three-tier fallback (`globalThis.console` → `globalThis.print`-built five-method-log-stub for eshost SpiderMonkey → undefined); (3) upgrade a log-only console (define `warn`/`error` as `log` aliases); (4) compose `ourConsole` — `makeCausalConsole(originalConsole, loggedErrorHandler)` unless `consoleTaming === 'unsafe'`; (5) wire platform-API error traps for Node and Browser. The §*avoid Parcel overweaning gaze* discipline uses `globalThis.process` / `globalThis.window` instead of bare `process` / `window` because Parcel would install a `process` shim forcing sloppy mode that breaks SES's strict-mode invariant. The §Node.js wiring registers four events (`uncaughtException` + `unhandledRejection` + `rejectionHandled` + `exit`); the §Browser wiring registers four events (`error` + `unhandledrejection` + `rejectionhandled` + `beforeunload`). The §five-mode errorTrapping enumeration: `platform`/`exit` call `process.exit(exitCode || -1)`; `abort` calls `process.abort`; `report` just logs; `none` skips. The §browser `about:blank` redirect for exit/abort modes. The §`SES_UNCAUGHT_EXCEPTION:` and `SES_UNHANDLED_REJECTION:` error-code prefixes link to canonical docs in `packages/ses/error-codes/`. The factory returns `{ console: ourConsole }` — extensible record shape.

### Library state after this cycle

- **607 sections** (was 606) / **151 sources** (was 150) / **44 concepts** (unchanged).
- Topic pages updated: `hardened-javascript.md` (+1 row), `errors.md` (+1 row).
- `library/sources/README.md` and `library/sections/README.md` updated with the new cycle group.
- `library/keywords.md` extended with ~40 tame-console keywords (tameConsole factory / don't-import-Error invariant / three-tier originalConsole fallback / avoid-Parcel-overweaning-gaze / globalThis.process / SES strict-mode invariant / event.preventDefault / about:blank browser exit / SES_*_* error code prefixes / extensible record return shape).

## SES causal-console substrate complete

This cycle **completes** the SES causal-console substrate documented in the library. The six-cycle arc:

- **Cycle 90** `track-turns.js` (Mark Miller) — causal annotations producer.
- **Cycle 93** `tame-v8-error-constructor.js` (Richard Gibson) — getStackString capability.
- **Cycle 96** `console.js` (Mark Miller) — causal-console rendering.
- **Cycle 98** `assert.js` (Richard Gibson) — state + loggedErrorHandler bridge.
- **Cycle 100** `unhandled-rejection.js` (Mathieu Hofman) — GC-driven rejection detection.
- **Cycle 106** `tame-console.js` (Mark Miller, this ingest) — *integration / top-level wiring*.

Together the six files describe the *full SES error-observation surface from substrate to integration*. The library now has a complete picture of SES's error-handling architecture from the lowest-level (V8 stack-attenuation) through the substrate (assert state + console rendering + rejection detection) to the integration point (the file SES's lockdown.js calls).

## Rotation discipline

Cycle 106 was scheduled for papers-lane but pivoted to comments-lane after the *fifth consecutive papers-lane block* (cycles 97 / 100 / 102 / 104 / 106). The §rotation discipline is *cohesion-honest* not *strict round-robin*; when a lane is structurally hard (papers-lane requires PDF-fetching infrastructure I don't have reliable access to), the rotation extends gracefully into adjacent lanes. The library has grown substantially via comments-lane and design-lane pivots — 5 comments-lane ingests since cycle 97 plus 4 design-lane ingests, accumulating 15 sections and 9 sources across the persistent papers-lane block.

## Notes

- The §*don't-import-Error* invariant (*Using TypeError minimizes risk of exposing the feral Error constructor*) is a worked example of the §narrowest-applicable-error-subtype + captured-and-tamed-binding discipline. Reusable for any SES-internal file that needs error-construction.
- The §*avoid Parcel overweaning gaze* discipline (`globalThis.process` / `globalThis.window` not bare `process` / `window`) is structurally important: it demonstrates that *lexical form matters* even when *runtime semantics are identical*. Bundler scanners pattern-match source text; semantically-equivalent reformulations can escape the scanner.
- The §three-tier originalConsole fallback is the canonical *gracefully-degrade-for-constrained-environments* shape: `globalThis.console` (most environments) → `globalThis.print` five-method-stub for eshost SpiderMonkey → undefined. Each tier handles a documented environment class.
- The §*SES_<CODE>:-prefix-with-URL* pattern (`SES_UNCAUGHT_EXCEPTION:` / `SES_UNHANDLED_REJECTION:` linking to `packages/ses/error-codes/<CODE>.md`) is reusable for any system that emits named log codes — every prefix maps to a documented explanation.
- The §extensible-record-return-shape (`return { console: ourConsole }` instead of `return ourConsole`) is the canonical *forward-compatible-API* discipline. Future versions can add fields without breaking destructuring callers.

## Next

- Cycle 107 (chat-lane): chat-cluster exhausted; pivot to broader endo-but-for-bots designs. Candidates: daemon-form-request (Implemented; 435 lines — likely 2 sections); daemon-agent-tools (Not Started; 350 lines); daemon-mount (In Progress; 718 lines — 3+ sections); daemon-capability-bus (In Progress; 526 lines — 2 sections); familiar-* (10 designs); endopi-* (12 designs); ocapn-* (7 designs).
- Cycle 108 (papers-lane): the persistent five-cycle block (97-106) suggests this lane needs structural infrastructure I lack. Continue pivoting unless fresh PDF access becomes available.
- Cycle 109 (comments-lane): `packages/exo/src/exo-makers.js` (242 lines); `packages/marshal/src/marshal-justin.js` (510 lines / ~23%); `packages/patterns/src/keys/copySet.js` (109 lines); `packages/exo/src/exo-tools.js` (513 lines).

ScheduleWakeup 1500s for cycle 107.
