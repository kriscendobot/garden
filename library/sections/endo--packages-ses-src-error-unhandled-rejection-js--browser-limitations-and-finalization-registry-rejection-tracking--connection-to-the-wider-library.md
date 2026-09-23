---
title: Connection to the wider library
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

This section is the **canonical *GC-driven unhandled-rejection-detection* worked example**. Three threads:

1. **The platform-limitation-attribution discipline** — when the platform withholds the events the module needs, *document the workaround in the module's opening comment*. The user's first-bug-report attributing failure to SES gets saved time by the comment.

2. **The triple-bookkeeping state (Map + WeakMap + FinalizationRegistry)** is reusable for any *strong-by-id + weak-back-reference + GC-finalization* pattern. Used wherever a system needs to track a fact about a held object that should disappear when the object becomes unreachable.

3. **The three-event-source split (entry + handled-after-the-fact + at-exit)** generalizes to any *track-then-resolve-via-multiple-paths* state machine. The entry handler records; the handled-after-the-fact handler resolves; the at-exit handler flushes. Each path has its own discriminator.

This file *complements* the SES causal-console substrate (cycles 90 + 93 + 96 + 98) by handling the *promise-rejection-without-throw* path. The causal-console renders errors that get *thrown*; this file detects rejections that *never get caught*. Both feed into the same `reportReason`-style callback at the host integration boundary.
