---
title: Common confusions
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

- **"`FinalizationRegistry` runs deterministically when the promise is GC'd."** It does *not*. The spec gives engines wide latitude; finalization may be delayed indefinitely or never run for objects that survive to process exit. The §`processTerminationHandler` is the safety net for the *never-finalized* case.
- **"`if (FinalizationRegistry === undefined) return undefined` is dead code."** It is the *engine-without-FinalizationRegistry* fallback. As of this commit, all currently-supported Node and major-browser versions have FinalizationRegistry, but the SES module supports older engines via this branch.
- **"`unhandledRejectionHandler` should also report the reason."** It should *not*. The §discipline: a rejection is *only* reported when it becomes *definitively unhandled* — either (a) the promise is GC'd without a handler, or (b) the process is terminating. A rejection that gets a handler attached after-the-fact is *not* an error; reporting it immediately would produce false positives.
- **"`cancelChecking` is unused dead code."** It is *declared but not exported as a setter* — it is *defensively present* for future use. The variable is referenced by `removeReasonId` so when a setter lands (or the host wires it in), the cancellation logic is already in place.
- **"`processTerminationHandler` should also unregister from the FinalizationRegistry."** It doesn't need to. When the process terminates, the FinalizationRegistry and all its registrations are torn down by the runtime; explicit unregister would be redundant.
- **"The triple-bookkeeping is over-engineered — two of three would suffice."** Each member serves a distinct lookup direction. Remove `idToReason` and there's no way to get the reason from the FinalizationRegistry's held-value (which is just the ReasonId number). Remove `promiseToReasonId` and there's no way to handle the `rejectionHandledHandler(pr)` case. Remove `FinalizationRegistry` and there's no GC-driven detection. All three are load-bearing.
- **"The `mapEntries` + `mapDelete` mid-iteration is undefined behavior."** It is *spec-defined behavior*. ECMA-262 `Map.prototype.entries` returns a *spec-compliant iterator* that handles deletion of visited keys safely. Most engines implement this correctly; the module relies on the spec without comment.
- **"`reportReason(reason)` should be guaranteed not to throw."** The module doesn't guarantee anything about `reportReason`'s behavior. A throwing `reportReason` would propagate up through `finalizeDroppedPromise` and break the GC-finalization callback. The host is *responsible* for providing a non-throwing callback (or accepting the consequence).
