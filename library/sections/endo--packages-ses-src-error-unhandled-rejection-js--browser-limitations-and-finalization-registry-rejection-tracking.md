---
title: The §opening browser-limitations comment block documenting that *modern browsers prevent access to the `unhandledrejection` and `rejectionhandled` events* in cross-origin (`file://`), interactive-console, and debugger contexts — with the *serve from http:// or https://* workaround prescription; the `makeRejectionHandlers(reportReason)` factory that returns `undefined` on engines without `FinalizationRegistry` and otherwise constructs the rejection-tracking machinery; the state cluster (`lastReasonId` monotonic counter + `idToReason` Map<ReasonId, unknown> + `promiseToReasonId` WeakMap<Promise, ReasonId> + `cancelChecking` optional teardown thunk); the *GC-driven* finalize-dropped-promise via `FinalizationRegistry(finalizeDroppedPromise)` that reports a rejection only when the rejected promise itself is garbage-collected (the *unhandled-and-no-longer-reachable* discipline); the three handlers (`unhandledRejectionHandler` that records via id-bookkeeping + WeakMap-key + finalization-registry-register; `rejectionHandledHandler` that just removes the ReasonId when a handler is attached after-the-fact; `processTerminationHandler` that flushes all still-pending unhandled rejections at agent-cluster termination); the *no-double-report* guard via `removeReasonId` checking `mapHas` before reporting; the *empty-pool cancel-checking* idiom that lets the host turn off the rejection-checking timer when nothing is queued
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
kind: index
section_count: 6
---

Sections:

- [Abstract](endo--packages-ses-src-error-unhandled-rejection-js--browser-limitations-and-finalization-registry-rejection-tracking--abstract.md)
- [Body](endo--packages-ses-src-error-unhandled-rejection-js--browser-limitations-and-finalization-registry-rejection-tracking--body.md)
- [Connection to the wider library](endo--packages-ses-src-error-unhandled-rejection-js--browser-limitations-and-finalization-registry-rejection-tracking--connection-to-the-wider-library.md)
- [Translation block (comment idiom → contemporary practice)](endo--packages-ses-src-error-unhandled-rejection-js--browser-limitations-and-finalization-registry-rejection-tracking--translation-block-comment-idiom-contemporary-practice.md)
- [See also](endo--packages-ses-src-error-unhandled-rejection-js--browser-limitations-and-finalization-registry-rejection-tracking--see-also.md)
- [Common confusions](endo--packages-ses-src-error-unhandled-rejection-js--browser-limitations-and-finalization-registry-rejection-tracking--common-confusions.md)
