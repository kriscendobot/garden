---
source: packages/promise-kit/src/promise-executor-kit.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/promise-kit/src/promise-executor-kit.js
source_path: packages/promise-kit/src/promise-executor-kit.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - patterns
  - async-flow
genre: §endo-source-comment-fragment
cycle: 173
lane: chat
status: current
title: "§The-pattern-named: §reference-release-on-settle"
parent: endo--packages-promise-kit-src-promise-executor-kit-js--reference-release-on-settle-with-three-state-resolve-reject-lifecycle-for-GC-friendly-promise-kits
---

This is a §micro-pattern with three components:

1. **§Captured-state-as-mutable-let** (not const) — the
   variables must be re-assignable.
2. **§Three-distinct-states** distinguishable by JS value
   shape (undefined / function / null).
3. **§Symmetric-release-on-first-firing** — both halves of
   the pair are released, regardless of which side fired.

§Applicable-to-other-kit-shapes: any factory that captures
references it wants to release after a §single-firing event
can borrow this pattern. §Watchdog-timers, §one-shot-event-
emitters, §single-use-cleanup-handlers.
