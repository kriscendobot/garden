---
title: Translation block (comment idiom → contemporary practice)
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

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| `modern browsers prevent access to the 'unhandledrejection' ... events ... in cross-origin mode, like when served from file://, in the browser console, in the debugger` | The platform-limitation-attribution discipline; document the workaround in the opening comment so users don't blame the module. |
| `The solution is to serve your web page from an http:// or https:// web server` | The honest-workaround prescription; tell the user what they can do to fix their environment. |
| `if (FinalizationRegistry === undefined) { return undefined; }` | The fail-loud-not-degrade discipline; do not silently provide a partial capability. |
| `Map<ReasonId, unknown>` + `WeakMap<Promise, ReasonId>` + `FinalizationRegistry<ReasonId>` triple-bookkeeping | The strong-by-id + weak-back-reference + GC-finalization triple-key pattern. |
| `No more unhandled rejections to check, just cancel the check.` | The empty-pool-cancel-checking idiom; turn off the background timer when the queue drains. |
| `Let the FinalizationRegistry or processTermination report any GCed unhandled rejected promises.` | The division-of-responsibility comment; document which other handler covers which case. |
| `Report all the unhandled rejections, now that we are abruptly terminating the agent cluster.` | The at-exit-flush discipline; don't let in-flight unhandled rejections silently vanish on process termination. |
| `weakmapGet(promiseToReasonId, pr)` returns undefined on unregistered → `removeReasonId(undefined)` no-ops | The defensive-fallback path; the no-check-needed pattern relies on downstream no-op-on-undefined behavior. |
| `lastReasonId` monotonic counter | The strictly-increasing-id discipline; new entries always get unique ids. |
| `finalizationRegistryRegister(promiseToReason, pr, reasonId, pr)` with `pr` as unregister token | The promise-itself-as-unregister-token pattern; defensive registration shape for future explicit-unregister. |
