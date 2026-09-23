---
title: Abstract
source: packages/ses/src/error/unhandled-rejection.js
source_repo: endojs/endo
source_branch: master
source_commit: dae7235011da907823c27ca5dfb9ed72519a4062
source_date: 2022-09-16
source_authors: [Mathieu Hofman]
source_lines: "1-122 (full file: browser-limitations preamble + makeRejectionHandlers factory + state + FinalizationRegistry wiring + three handlers)"
topics: [hardened-javascript, errors]
status: current
notes: |
  Twelfth comment-fragment ingest. Mathieu Hofman-authored
  rejection-tracking machinery — *the* SES file that lets Node-and-
  browser SES embeddings detect unhandled promise rejections via
  GC-driven finalization rather than just the platform's
  `unhandledrejection` event (which browsers withhold in
  cross-origin/console/debugger contexts). The 122-line file is
  honestly one cohesive argument-cluster — a single rejection-
  tracking-machinery factory — and decomposes as a single-section
  ingest like cycle-95 chat-rename-dismiss-to-clear (75-line
  single-section). Three structural ideas: (1) the *browser-prevent-
  access* limitations frame the design — the platform's event API
  is insufficient, so the machinery uses `FinalizationRegistry` as
  an *unhandled-and-no-longer-reachable* alternative; (2) the
  triple-bookkeeping state (id-to-reason Map + promise-to-id
  WeakMap + FinalizationRegistry) is the *three-key-lookup* design;
  (3) the three-handler split (unhandled / handled-after-the-fact /
  process-termination) plus the *empty-pool cancel-checking* idiom
  for *no-work-no-timer* discipline.
parent: endo--packages-ses-src-error-unhandled-rejection-js--browser-limitations-and-finalization-registry-rejection-tracking
---

The §file opens (lines 2-14) with a SES `commons.js` import that pulls *prototype-stable* aliases of the platform builtins this file uses: `FinalizationRegistry`, `Map`, `mapGet`/`mapDelete`/`mapSet`/`mapHas`/`mapEntries`, `WeakMap`, `weakmapSet`/`weakmapGet`, and `finalizationRegistryRegister`. The §discipline: SES files never call `map.get(key)` directly because the prototype could be mutated; they call `mapGet(map, key)` which is the captured-at-load-time method. The §opening JSDoc block (lines 16-33) documents the *browser-prevent-access* limitations:

> Note that modern browsers *prevent* access to the `unhandledrejection` and `rejectionhandled` events needed:
> - in cross-origin mode, like when served from `file://`
> - in the browser console (interactively typed-in code)
> - in the debugger
>
> Then, they just look like: `Uncaught (in promise) Error: ...` and don't implement the machinery.

The §workaround prescription: *serve your web page from an `http://` or `https://` web server and execute actual code*. The §`makeRejectionHandlers(reportReason)` factory (lines 34-122) returns `undefined` when `FinalizationRegistry === undefined` (older engines without GC-finalization callbacks); otherwise it constructs the machinery. The §state cluster (lines 39-58): `lastReasonId` monotonic counter (ReasonId is a `number` typedef); `idToReason` Map<ReasonId, unknown> as the *strong* record of pending unhandled rejections; `cancelChecking` optional teardown thunk (set by the host environment); `promiseToReasonId` WeakMap<Promise, ReasonId> as the *weak* back-reference from a promise to its tracking id (so the promise can be GC'd). The §`removeReasonId` helper (lines 48-55) deletes the entry and *empty-pool-cancels* — when the pool drains to zero, it invokes `cancelChecking()` and clears the thunk. The §`finalizeDroppedPromise(heldReasonId)` (lines 65-71) is the GC-driven path: if the ReasonId still has an entry, remove it and *report* the rejection via `reportReason(reason)` — the *unhandled-and-no-longer-reachable* condition. The §FinalizationRegistry registration (line 74) wires `promiseToReason = new FinalizationRegistry(finalizeDroppedPromise)`. The §three platform-event handlers: `unhandledRejectionHandler(reason, pr)` (lines 83-91) increments the counter, records both bookkeeping entries, and registers with the FinalizationRegistry; `rejectionHandledHandler(pr)` (lines 101-104) handles the *after-the-fact handler attachment* case by looking up the ReasonId via the WeakMap and removing it (no `removeReasonId(undefined)` check needed because `mapDelete` on undefined-not-present is a no-op); `processTerminationHandler()` (lines 110-115) flushes all remaining unhandled rejections at agent-cluster termination so they aren't lost when the process exits. The §returned bag (lines 117-121) exposes the three handlers — the host integration wires them to its platform-specific event surfaces (Node `process.on('unhandledRejection')` / `process.on('rejectionHandled')` / `process.on('beforeExit')` or browser `window.addEventListener('unhandledrejection')` / similar).
