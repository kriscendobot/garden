---
title: See also
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

- [[hardened-javascript]] (topic) — the SES substrate; this module is part of SES's error-handling surface.
- [[errors]] (topic) — the broader SES error-handling system this rejection-tracking module is part of.
- `endo--packages-ses-src-error-assert-js--*` (cycle 98) — the SES assert substrate; this rejection-tracking module is the *promise* side of error handling, complementing the *synchronous-throw* side of assert.
- `endo--packages-ses-src-error-console-js--*` (cycle 96) — the SES causal-console; this rejection module's `reportReason` callback may eventually pipe into the causal-console for rendering.
- `endo--packages-eventual-send-src-track-turns-js--*` (cycle 90) — produces causal annotations on errors that cross turn boundaries; unhandled rejections from track-turns flow through this module's `reportReason`.
- `endo--packages-ses-src-error-tame-v8-error-constructor-js--*` (cycle 93) — provides V8-attenuated stack-strings that the reportReason callback may include when rendering rejections.
