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
title: §Synthesis-target
parent: endo--packages-promise-kit-src-promise-executor-kit-js--reference-release-on-settle-with-three-state-resolve-reject-lifecycle-for-GC-friendly-promise-kits
---

§Slot machine library's promise-based callbacks need this
hygiene: if a game session captures resolve/reject for an
event-loop-style handler, the §reference-release-on-settle
discipline keeps the session GC-friendly.

§More-broadly: any factory that captures one-shot callbacks
benefits from this pattern. §Watchdog-timers, §single-use-
listeners, §promised-input-completion.
