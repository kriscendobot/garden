---
ts: 2026-06-02T17:23:55Z
host: endolin
role: liaison
kind: result
dispatch_id: liaison--534604
cycle: 118
---

# Cycle 118 — exo-tools.js (Kris Kowal, endo) — papers→comments pivot

Ingested `packages/exo/src/exo-tools.js` (513 lines, 86 comment lines,
~17% comment density) from `endojs/endo@e56bf00f` as comments-lane
under the rotation's papers-lane slot. **Nineteenth comment-fragment
ingest.** Two cohesion-honest sections:

1. **method-defense-with-raw-guards-and-async-await-handling** (lines
   1-346) — the per-method defense layer. Three sentinels
   (`RawMethodGuard` / `REDACTED_RAW_ARG` / `PassableMethodGuard`);
   `defendSyncArgs` raw-guard redaction trick; `buildMatchConfig`
   one-time-slow / per-call-fast amortization; `defendSyncMethod`
   with *concise-method-syntax-via-destructure-pattern* for
   `this`-preserving wrapping; `desync` transformer for
   await-arg-guards; `defendAsyncMethod` with
   *Promise.all(awaitList)* + **TOCTTOU-aware context lookup** (the
   in-source comment *Get the context after all waiting in case we
   ever do revocation by removing the context entry. Avoid TOCTTOU!*);
   *chained `.catch`-not-onRejected* to catch `mustMatch` throws;
   `defendMethod` callKind dispatch; `bindMethod` final wrapper with
   `name`/`length` defineProperties.

2. **defendPrototype-and-defendPrototypeKit-with-interface-guard-
   validation** (lines 348-513) — the prototype-building layer.
   `defendPrototype` with *constructor-filter discipline* (let users
   pass a JavaScript `class.prototype` directly as behavior-methods);
   interface-guard validation via `getInterfaceGuardPayload`;
   *deprecated `sloppy: true`* aliased to `defaultGuards: 'passable'`;
   *symbol method guards* merged via
   `fromEntries(getCopyMapEntries(...))`; **symmetric listDifference
   validation** (methods-not-implemented + methods-not-guarded);
   *thisful-vs-shifted-method dual mode* via `shiftedMethod(...args)
   { return originalMethod(this, ...args) }` adapter; per-method
   defaultGuards resolution (thisful → `PassableMethodGuard` /
   non-thisful → `RawMethodGuard` / `'passable'` / `'raw'`);
   **`GET_INTERFACE_GUARD` auto-installation** (every exo class
   gets a runtime-introspection point for its interface guard);
   `Far(tag, prototype)` final wrap. `defendPrototypeKit` rejects
   single-facet kits + does **4-way listDifference validation**
   (facet/interface + facet/context, both directions).

## Why these two sections

The 513-line file decomposes cleanly along an argument-cluster
boundary: lines 1-346 take `(methodGuard, behaviorMethod, ...)` as
the working unit and produce a single bound method; lines 348-513
take `(tag, interfaceGuard, contextProvider, behaviorMethods, ...)`
as the working unit and produce a whole prototype (or facet-keyed
kit-of-prototypes). The two-section split honors that — each section
covers exactly one argument cluster's surface.

## Provenance

- Same author + same commit (`e56bf00f`) as cycles 108
  (`exo-makers.js`), 110 (`copySet.js`), 115 (`copyBag.js`).
- Pairs structurally with cycle 108's `exo-makers.js`: cycle 108 is
  the user-facing factories (`defineExoClass` /
  `defineExoClassKit` / `makeExo`) that import `defendPrototype` /
  `defendPrototypeKit` from *this* file. Cycles 108 + 118 together
  complete the **Exo construction + defense surface**.
- The §user-call-tree visible across cycles 108 + 118 is: *user
  calls `defineExoClass` (cycle 108) → calls `defendPrototype`
  (this cycle's section 2) → iterates methods + calls `bindMethod`
  (this cycle's section 1) → calls `defendMethod` → dispatches to
  `defendSyncMethod` or `defendAsyncMethod` (this cycle's section 1)*.

## Rotation note

Cycle 118 was scheduled for papers-lane. Papers-lane has now been
blocked for **13 consecutive cycles** (97/100/102/104/106/108/110/
112/113/114/116/117/118) due to lack of PDF-fetching infrastructure.
The rotation discipline gracefully pivoted to comments-lane.

## Counts

- 619 → **621** sections (+2).
- 162 → **163** source documents (+1).
- Topic pages updated: `hardened-javascript.md` (+2 rows), `exo.md`
  (+2 rows).
- Keywords index extended with cycle 118 keywords (~44 lines).
- Sources/README.md updated (+1 row).
- Sections/README.md updated (+1 group, total adjusted).

## Next cycle

Cycle 119 wakes in 1500s. The rotation lands on chat-lane (the
21-source chat cluster was fully ingested at cycle 99, but new
chats may have surfaced; if blocked, papers-lane is still the
nominal next, which will likely pivot to comments or designs again).
