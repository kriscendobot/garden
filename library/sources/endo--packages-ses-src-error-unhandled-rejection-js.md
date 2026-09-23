---
source: packages/ses/src/error/unhandled-rejection.js
source_repo: endojs/endo
source_branch: master
source_commit: dae7235011da907823c27ca5dfb9ed72519a4062
source_date: 2022-09-16
source_authors: [Mathieu Hofman]
ingested: 2026-06-02
ingested_by: scholar
section_count: 1
status: current
notes: |
  Twelfth comment-fragment ingest. Mathieu Hofman-authored SES
  rejection-tracking machinery — *the* file that lets SES embeddings
  detect unhandled promise rejections via GC-driven finalization
  rather than relying solely on the platform's `unhandledrejection`
  event (which modern browsers withhold in cross-origin/console/
  debugger contexts). The 122-line file is honestly one cohesive
  argument-cluster — a single `makeRejectionHandlers(reportReason)`
  factory — and decomposes as a single-section ingest like cycle 95's
  chat-rename-dismiss-to-clear (75-line single-section). Three
  structural ideas: (1) the *browser-prevent-access* framing — the
  platform's event API is insufficient in three named contexts, so
  the module documents the workaround (*serve your web page from
  an `http://` or `https://` web server*) up-front; (2) the triple-
  bookkeeping state (idToReason Map + promiseToReasonId WeakMap +
  FinalizationRegistry-on-promise) covers three lookup directions
  with strong-id + weak-back-reference + GC-finalization; (3) the
  three-handler split (`unhandledRejectionHandler` records,
  `rejectionHandledHandler` cancels-after-the-fact,
  `processTerminationHandler` flushes-at-exit) with explicit
  *division-of-responsibility* JSDoc. Plus the *empty-pool-cancel-
  checking* idiom for *no-work-no-timer* discipline, the *fail-
  loud-not-degrade* discipline (`return undefined` when
  `FinalizationRegistry` is absent), and the *defensive-fallback*
  pattern (no-op on undefined lookups).
  
  This cycle pivoted from papers-lane (cycle 100 was scheduled as
  papers) to comments-lane because two consecutive papers-lane
  attempts had blocked (cycle 97 problematic source, Stiegler-Miller
  HPL-2006-116 URLs 404). The rotation discipline is *cohesion-
  honest* not *strict round-robin*; when a lane is blocked, the
  next-best candidate in another lane is appropriate.
---

> Abstract: `packages/ses/src/error/unhandled-rejection.js` is
> SES's rejection-tracking machinery — *the* file that lets SES
> embeddings detect unhandled promise rejections via GC-driven
> finalization rather than relying solely on the platform's
> `unhandledrejection` event. The opening comment block names the
> *browser-prevent-access* limitations: modern browsers withhold
> the `unhandledrejection` and `rejectionhandled` events in
> cross-origin (`file://`), interactive-console, and debugger
> contexts. The *workaround prescription*: serve your web page from
> an `http://` or `https://` web server. The
> `makeRejectionHandlers(reportReason)` factory returns `undefined`
> on engines without `FinalizationRegistry` (fail-loud-not-degrade)
> and otherwise constructs the machinery: a `lastReasonId`
> monotonic counter, an `idToReason` Map<ReasonId, unknown> for the
> strong record, a `promiseToReasonId` WeakMap<Promise, ReasonId>
> for the weak back-reference, and a `FinalizationRegistry`
> wired to `finalizeDroppedPromise(reasonId)`. The
> *unhandled-and-no-longer-reachable* condition is detected
> when the FinalizationRegistry fires AND the ReasonId is still
> in the strong Map. The factory returns three handlers:
> `unhandledRejectionHandler(reason, pr)` (records via three-write
> commit), `rejectionHandledHandler(pr)` (cancels via WeakMap
> lookup + Map removal), and `processTerminationHandler()`
> (at-exit-flush of all still-pending entries). The
> *empty-pool-cancel-checking* idiom (`cancelChecking` thunk)
> turns off the background timer when the queue drains. The
> JSDoc explicitly names the *division-of-responsibility*: this
> handler removes the entry; *the FinalizationRegistry or
> processTermination* reports any GC'd unhandled rejected
> promises.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [browser-limitations-and-finalization-registry-rejection-tracking](../sections/endo--packages-ses-src-error-unhandled-rejection-js--browser-limitations-and-finalization-registry-rejection-tracking.md) | hardened-javascript, errors | current |

The 122-line file is honestly one cohesive argument-cluster. The opening browser-limitations preamble + the makeRejectionHandlers factory + the state + the FinalizationRegistry wiring + the three handlers all decompose into one ingest section. Forcing a multi-section split would create artificial divisions between the state-cluster and the handlers that use it.

## Provenance

- Fetched 2026-06-02 from `endojs/endo@dae7235011da907823c27ca5dfb9ed72519a4062` via the local bare-clone.
- Last touched 2022-09-16 by Mathieu Hofman. Mathieu's authorship of the rejection-tracking machinery makes sense — Mathieu has been one of the SES module's most active maintainers for the error-handling and FinalizationRegistry-using surfaces.
- Verified file existence and structure via the local bare-clone (`git show master:packages/ses/src/error/unhandled-rejection.js`): 122 lines / single export `makeRejectionHandlers` / explicit JSDoc on every function.
- **Twelfth comment-fragment ingest**. The chosen file *complements* the SES causal-console substrate (cycles 90 + 93 + 96 + 98) by handling the *promise-rejection-without-throw* path:
  - **Cycles 90 + 93 + 96 + 98** are the *synchronous-throw* rendering path: track-turns annotations → tame-v8 stack-string → console.js rendering ← assert.js state and user surface.
  - **Cycle 100** (this ingest) is the *asynchronous-rejection-detection* path: the platform-event-or-GC-finalization mechanism that triggers reporting of unhandled rejections.
  - Together the five cycles describe the *full SES error-observation surface*: errors that get thrown are rendered via the causal-console; rejections that never get caught are detected via GC-finalization and fed into `reportReason`.
- Cycle 100 pivoted from papers-lane (the scheduled rotation) to comments-lane after two consecutive papers-lane blocks (cycle 97 *problematic source* per user instruction; Stiegler-Miller HPL-2006-116 URLs returned 404 on multiple attempts). The §rotation discipline is *cohesion-honest* — when a lane is blocked, the next-best candidate in another lane is appropriate.
- Single-section cohesion-honest count. The 122-line file is *one tight argument-cluster* — one factory, one state cluster, three handlers that all reference the same state. Forcing a 2-section split would create an artificial divide between the state and the handlers using it.
