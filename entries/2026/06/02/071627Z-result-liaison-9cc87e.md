---
host: endolin
role: liaison
dispatch_id: 9cc87e
date: 2026-06-02
kind: result
---

# result(librarian, cycle 100): unhandled-rejection.js — GC-driven rejection-tracking (1 section) — **600-section milestone**

**Cycle**: 100 (pivoted from papers-lane to comments-lane).
**Source**: `endojs/endo` `packages/ses/src/error/unhandled-rejection.js` (122 lines), last touched 2022-09-16 by Mathieu Hofman.
**Lane rotation**: cycle 100 was scheduled for papers-lane; pivoted to comments-lane after two consecutive papers-lane blocks (cycle 97 *problematic source* per user instruction; Stiegler-Miller HPL-2006-116 URLs 404 on multiple attempts).

## What

Ingested SES's rejection-tracking machinery — *the* file that lets SES embeddings detect unhandled promise rejections via GC-driven finalization rather than relying solely on the platform's `unhandledrejection` event (which modern browsers withhold in cross-origin/console/debugger contexts). The 122-line file is honestly one cohesive argument-cluster — a single `makeRejectionHandlers(reportReason)` factory — and ingests as a single section like cycle 95's chat-rename-dismiss-to-clear (75-line single-section).

### Section drafted

1. **Browser-limitations + FinalizationRegistry rejection-tracking** (full file, lines 1-122) — single cohesive ingest. The §opening JSDoc block documents *modern browsers prevent access to the `unhandledrejection` and `rejectionhandled` events* in three contexts (cross-origin `file://`, browser console, debugger) and prescribes the workaround (*serve your web page from `http://` or `https://`*). The §`makeRejectionHandlers(reportReason)` factory returns `undefined` on engines without `FinalizationRegistry` (fail-loud-not-degrade) and otherwise constructs the machinery. The §triple-bookkeeping state: `lastReasonId` monotonic counter + `idToReason` Map<ReasonId, unknown> (strong record) + `promiseToReasonId` WeakMap<Promise, ReasonId> (weak back-reference) + `FinalizationRegistry` registered with each promise. The §*unhandled-and-no-longer-reachable* detection fires only when the FinalizationRegistry callback runs AND the ReasonId is still in the Map (the §`mapHas` check is the discriminator). The §three handlers: `unhandledRejectionHandler(reason, pr)` (records via three-write commit), `rejectionHandledHandler(pr)` (cancels via WeakMap-lookup + Map-removal; relies on `mapDelete(undefined)` being a no-op), `processTerminationHandler()` (at-exit flush of all still-pending entries). The §*empty-pool-cancel-checking* idiom (`cancelChecking` thunk turns off background timer when queue drains; defensively present for future host-side setter wiring). The §explicit JSDoc *division-of-responsibility*: *Let the FinalizationRegistry or processTermination report any GCed unhandled rejected promises*. The §`mapEntries` + `mapDelete` mid-iteration safety (spec-defined Map.prototype.entries handles delete-of-visited-key).

### Library state after this cycle

- **600 sections** (was 599) / **145 sources** (was 144) / **44 concepts** (unchanged). **Milestone: 600 sections.**
- Topic pages updated: `hardened-javascript.md` (+1 row), `errors.md` (+1 row).
- `library/sources/README.md` and `library/sections/README.md` updated with the new cycle group.
- `library/keywords.md` extended with ~30 unhandled-rejection keywords (browser-prevent-access / FinalizationRegistry GC-driven detection / triple-bookkeeping / unhandled-and-no-longer-reachable / empty-pool-cancel-checking / fail-loud-not-degrade / division-of-responsibility / spec-defined Map iteration with mutation).

## SES error-observation surface

This cycle *complements* the SES causal-console substrate (cycles 90 + 93 + 96 + 98) by handling the *asynchronous-rejection-detection* path:

- **Cycles 90 + 93 + 96 + 98** — the *synchronous-throw rendering* path: track-turns annotations → tame-v8 stack-string → console.js rendering ← assert.js state and user surface.
- **Cycle 100** — the *asynchronous-rejection-detection* path: GC-driven `FinalizationRegistry`-based detection plus three handlers wired to platform events.

Together the five cycles describe the *full SES error-observation surface*: errors that get thrown are rendered via the causal-console; rejections that never get caught are detected via GC-finalization and fed into the host's `reportReason` callback.

## Rotation discipline

Cycle 100 was scheduled for papers-lane per the three-lane rotation but pivoted to comments-lane after two consecutive papers-lane blocks:

- **Cycle 97** — Miller-Drexler 1988 *Comparative Ecology* abandoned with user instruction *skip this problematic source and continue*.
- **Cycle 99 next-papers candidate** — Stiegler-Miller HPL-2006-116 *How Emily Tamed the Caml* — URLs at HPL.HP.com and Agoric mirror returned 404 on previous attempts (cycle 97 probes).

The §rotation discipline is *cohesion-honest* not *strict round-robin*: when a lane is blocked, the next-best candidate in another lane is appropriate. The pivot is recorded in this entry and in the source page's `notes:` block so future cycles can see the rationale.

## Notes

- The §triple-bookkeeping pattern (Map<ReasonId, unknown> + WeakMap<Promise, ReasonId> + FinalizationRegistry-on-promise) is reusable for any *strong-by-id + weak-back-reference + GC-finalization* tracking discipline. Used wherever a system needs to track a fact about a held object that should disappear when the object becomes unreachable.
- The §*platform-limitation-attribution* discipline (the opening comment documents the workaround so users don't blame SES) is reusable for any SES-internal module that depends on a platform feature with engine-specific gaps.
- The §JSDoc *division-of-responsibility* style (*Let the FinalizationRegistry or processTermination report*) is the canonical way to document which handler covers which case in a multi-handler state machine. The reader doesn't have to reconstruct the discipline from the code; the comment names it explicitly.
- Single-section ingest (cohesion-honest). The 122-line file is one tight argument-cluster — one factory, one state, three handlers. Forcing a 2-section split would create artificial divisions between the state and the handlers using it.

## 600-section milestone

The library has reached **600 sections** from **145 source documents**. The corpus composition (rough estimate):

- ~12 longform-comment ingests from `endojs/endo` packages (cycles 71, 74, 81, 84, 87, 90, 93, 96, 98, 100, plus pilot batch).
- ~21 chat-cluster sources from `endo-but-for-bots/llm/designs/chat-*` (chat-cluster now fully ingested).
- ~12 external papers (Miller-cluster + capability-security literature).
- Plus daemon-*, familiar-*, endopi-*, ocapn-*, endor-*, OCapN-related design docs.

The 600-section threshold is a structural milestone — the library is now substantively large enough to support deep cross-referenced querying via the topics/sources/concepts/keywords indexes.

## Next

- Cycle 101 (chat-lane): chat-cluster is fully ingested. Pivot to the broader `endo-but-for-bots/designs/*` corpus (daemon-*, familiar-*, endopi-*, ocapn-*, endor-*).
- Cycle 102 (papers-lane): consider trying *Saltzer-Schroeder 1975 Principle of Least Privilege* (canonical, public-domain-status); *KeyKOS* (Hardy 1985); *EROS* (Shapiro 1999); or another fresh URL search for Stiegler-Miller HPL-2006-116.
- Cycle 103 (comments-lane): `packages/ses/src/error/tame-console.js` (197 lines / ~24% density); `packages/exo/src/exo-makers.js`; `packages/patterns/src/keys/checkKey.js`; `packages/marshal/src/marshal-justin.js`.

ScheduleWakeup 1500s for cycle 101.
